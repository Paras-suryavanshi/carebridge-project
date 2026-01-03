import os
import gc
import tempfile
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.conf import settings
from django.shortcuts import get_object_or_404
from datetime import timedelta
from django.utils import timezone

# Models & Serializers
from .models import ChatMessage, CallLog
from .serializers import ChatMessageSerializer
from patients.models import PatientProfile
from django.contrib.auth import get_user_model
from django.contrib.auth.models import User
from django.http import JsonResponse

# --- AI SDK Imports ---
import google.generativeai as genai
from azure.ai.textanalytics import TextAnalyticsClient
from azure.core.credentials import AzureKeyCredential
import azure.cognitiveservices.speech as speechsdk

User = get_user_model()

# ==========================================
# 1. HELPER FUNCTIONS (AI Setup)
# ==========================================

def get_gemini_response(text_input):
    """Interacts with Google Gemini Pro"""
    try:
        genai.configure(api_key=settings.GOOGLE_API_KEY)
        model = genai.GenerativeModel('gemini-2.5-flash-lite')
        
        # Context prompt to make it behave like a medical assistant
        system_prompt = (
            "You are CareAI, a compassionate medical assistant for seniors. "
            "Keep responses short, encouraging, and easy to understand. "
            "If the user mentions serious symptoms, advise them to call a doctor."
        )
        
        response = model.generate_content(f"{system_prompt}\nUser: {text_input}")
        return response.text
    except Exception as e:
        print(f"Gemini Error: {e}")
        return "I'm having trouble connecting to the network right now, but I'm here for you."

def analyze_mood_azure(text_input):
    """Uses Azure Language Service to detect sentiment"""
    try:
        endpoint = settings.AZURE_LANGUAGE_ENDPOINT
        key = settings.AZURE_LANGUAGE_KEY
        
        credential = AzureKeyCredential(key)
        client = TextAnalyticsClient(endpoint=endpoint, credential=credential)
        
        documents = [text_input]
        response = client.analyze_sentiment(documents=documents)[0]
        
        # Map Azure Sentiment to App Moods ('happy', 'sad', 'neutral')
        if response.sentiment == 'positive':
            return 'happy'
        elif response.sentiment == 'negative':
            return 'sad'
        else:
            return 'neutral'
    except Exception as e:
        print(f"Azure Language Error: {e}")
        return 'neutral' # Default fallback

# ==========================================
# 2. API VIEWS
# ==========================================

class ChatAPIView(APIView):
    """
    Handles Chatbot interaction + Mood Detection
    """
    def get(self, request, user_id):
        # Return chat history
        messages = ChatMessage.objects.filter(user_id=user_id).order_by('timestamp')
        serializer = ChatMessageSerializer(messages, many=True)
        return Response(serializer.data)

    def post(self, request):
        # 1. Validate Input
        serializer = ChatMessageSerializer(data=request.data)
        if serializer.is_valid():
            # Save User Message
            user_msg = serializer.save()
            user_text = user_msg.content
            user_id = user_msg.user.id
            
            # 2. Get AI Response (Gemini)
            ai_text = get_gemini_response(user_text)
            
            # 3. Save AI Message to Database
            ai_msg = ChatMessage.objects.create(
                user_id=user_id,
                content=ai_text,
                is_user_sender=False
            )
            
            # 4. Analyze Mood (Azure) & Update Patient Profile
            detected_mood = analyze_mood_azure(user_text)
            try:
                # Update the profile associated with this user
                profile = PatientProfile.objects.get(user_id=user_id)
                profile.current_mood = detected_mood
                profile.save()
            except PatientProfile.DoesNotExist:
                pass # If user is a doctor or has no profile, skip
            
            # 5. Return response to Flutter
            return Response({
                "status": "success",
                "ai_response": ai_text,
                "detected_mood": detected_mood,
                "data": ChatMessageSerializer(ai_msg).data
            }, status=status.HTTP_201_CREATED)
            
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class CallTranscriptionView(APIView):
    """
    Handles Audio File Upload -> Azure Speech-to-Text
    """
    def post(self, request):
        if 'audio' not in request.FILES:
            return Response({"error": "No audio file provided"}, status=status.HTTP_400_BAD_REQUEST)
            
        audio_file = request.FILES['audio']
        temp_audio_path = None
        
        try:
            # 1. Save to a temporary file
            # delete=False is crucial for Windows so we can close it before Azure reads it
            with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as temp_audio:
                for chunk in audio_file.chunks():
                    temp_audio.write(chunk)
                temp_audio_path = temp_audio.name
            
            # FILE IS NOW CLOSED BY PYTHON (Exited 'with' block)
            
            # 2. Configure Azure Speech
            speech_config = speechsdk.SpeechConfig(
                subscription=settings.AZURE_SPEECH_KEY, 
                region=settings.AZURE_SPEECH_REGION
            )
            audio_config = speechsdk.audio.AudioConfig(filename=temp_audio_path)
            speech_recognizer = speechsdk.SpeechRecognizer(
                speech_config=speech_config, 
                audio_config=audio_config
            )

            # 3. Perform recognition
            result = speech_recognizer.recognize_once_async().get()

            # 4. CRITICAL: Force release of file handle on Windows
            del speech_recognizer
            del audio_config
            del speech_config
            
            # Force garbage collection to ensure C++ objects release the file lock
            gc.collect() 

            # 5. Process Result
            if result.reason == speechsdk.ResultReason.RecognizedSpeech:
                response_data = {
                    "status": "success",
                    "transcript": result.text
                }
            elif result.reason == speechsdk.ResultReason.NoMatch:
                response_data = {"status": "error", "message": "No speech could be recognized"}
            else:
                response_data = {"status": "error", "message": f"Canceled: {result.cancellation_details.reason}"}

            return Response(response_data)

        except Exception as e:
            return Response({"status": "error", "message": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        finally:
            # 6. Safe Deletion
            # We put this in 'finally' to ensure it runs even if errors occur above
            if temp_audio_path and os.path.exists(temp_audio_path):
                try:
                    os.remove(temp_audio_path)
                except PermissionError:
                    # If Windows still locks it, just pass. 
                    # The OS will clean up temp files eventually.
                    print(f"Warning: Could not delete temp file {temp_audio_path}")
                    pass

class ClinicalSummaryView(APIView):
    """
    Generates a clinical summary for the Doctor based on recent chat logs.
    """
    def get(self, request, user_id):
        # 1. Fetch recent messages (last 24 hours)
        # You can remove the time filter if you want to summarize ALL history for the demo
        last_24h = timezone.now() - timedelta(hours=24)
        messages = ChatMessage.objects.filter(
            user_id=user_id, 
            is_user_sender=True,  # Only summarize what the PATIENT said
            # timestamp__gte=last_24h 
        ).order_by('timestamp')

        if not messages.exists():
            return Response({"summary": "No patient activity recorded recently."})

        # 2. Format the logs for the AI
        logs_text = "\n".join([f"- {msg.content} ({msg.timestamp.strftime('%H:%M')})" for msg in messages])

        # 3. Create the Doctor Prompt
        prompt = (
            f"You are an expert Medical Scribe. Summarize the following patient chat logs into a "
            f"concise clinical note using standard medical terminology (SOAP format if possible). "
            f"Highlight any symptoms, pain points, or mental health indicators.\n\n"
            f"Patient Logs:\n{logs_text}"
        )

        # 4. Ask Gemini
        try:
            summary = get_gemini_response(prompt) # Reusing your existing helper function
            return Response({
                "status": "success",
                "patient_id": user_id,
                "summary": summary
            })
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

def setup_database(request):
    # 1. Create Superuser (if not exists)
    if not User.objects.filter(username='admin').exists():
        User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
        admin_msg = "Superuser 'admin' created (password: admin123)."
    else:
        admin_msg = "Superuser 'admin' already exists."

    # 2. Create Patient User (if not exists)
    if not User.objects.filter(username='patient1').exists():
        p_user = User.objects.create_user('patient1', 'patient@example.com', 'patient123')
        
        # 3. Create Patient Profile for ID #1 (or whatever ID connects to it)
        PatientProfile.objects.create(
            user=p_user,
            caregiver_name="Sarah",
            medical_conditions="Hypertension",
            current_status="Stable",
            current_mood="Neutral"
        )
        patient_msg = "Patient 'patient1' and Profile created."
    else:
        patient_msg = "Patient 'patient1' already exists."

    return JsonResponse({
        "status": "success", 
        "admin": admin_msg, 
        "patient": patient_msg
    })