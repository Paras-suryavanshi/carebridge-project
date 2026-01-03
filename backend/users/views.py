import json
from django.contrib.auth import authenticate, login
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import User, UserSettings

@csrf_exempt
def login_view(request):
    """
    Simple JSON login.
    Returns user ID and role on success.
    """
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            username = data.get('email')  # Frontend sends email as username
            password = data.get('password')
            
            # Simple hackathon auth: assumes username=email for now
            user = authenticate(request, username=username, password=password)
            
            if user is not None:
                login(request, user)
                return JsonResponse({
                    'success': True,
                    'user_id': user.id,
                    'role': user.role,
                    'name': user.get_full_name() or user.username
                })
            else:
                return JsonResponse({'success': False, 'message': 'Invalid credentials'}, status=401)
        except Exception as e:
            return JsonResponse({'success': False, 'message': str(e)}, status=400)
    return JsonResponse({'message': 'Method not allowed'}, status=405)

def get_profile(request):
    """
    Returns current user details.
    """
    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Unauthorized'}, status=401)
    
    user = request.user
    return JsonResponse({
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'role': user.role,
        'phone': user.phone,
        'avatar_url': user.avatar.url if user.avatar else None,
    })

def get_settings(request):
    """
    Fetches user preferences.
    """
    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Unauthorized'}, status=401)

    # Get or create settings if missing
    settings, _ = UserSettings.objects.get_or_create(user=request.user)
    
    return JsonResponse({
        'notifications': settings.notifications_enabled,
        'voice_alerts': settings.voice_alerts_enabled,
        'dark_mode': settings.dark_mode_enabled
    })

@csrf_exempt
def update_settings(request):
    """
    Updates user preferences (Dark mode, etc).
    """
    if not request.user.is_authenticated:
        return JsonResponse({'error': 'Unauthorized'}, status=401)

    if request.method == 'POST':
        data = json.loads(request.body)
        settings, _ = UserSettings.objects.get_or_create(user=request.user)
        
        if 'notifications' in data:
            settings.notifications_enabled = data['notifications']
        if 'voice_alerts' in data:
            settings.voice_alerts_enabled = data['voice_alerts']
        if 'dark_mode' in data:
            settings.dark_mode_enabled = data['dark_mode']
            
        settings.save()
        return JsonResponse({'success': True})
    
    return JsonResponse({'error': 'Method not allowed'}, status=405)

from patients.models import PatientProfile # Import PatientProfile to create empty profile on signup

@csrf_exempt
def register_view(request):
    """
    Registers a new user and creates their profile.
    """
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            email = data.get('email')
            password = data.get('password')
            name = data.get('name')
            role = data.get('role', 'patient') # Default to patient

            # 1. Validation
            if not email or not password or not name:
                return JsonResponse({'success': False, 'message': 'All fields are required'}, status=400)

            if User.objects.filter(username=email).exists():
                return JsonResponse({'success': False, 'message': 'Email already registered'}, status=400)

            # 2. Create User (Username is set to email)
            user = User.objects.create_user(username=email, email=email, password=password)
            user.first_name = name.split(" ")[0]
            user.last_name = " ".join(name.split(" ")[1:]) if " " in name else ""
            user.role = role
            user.save()

            # 3. Create Patient Profile if role is patient
            if role == 'patient':
                PatientProfile.objects.create(
                    user=user,
                    caregiver_name="Not Assigned", 
                    medical_condition="General"
                )

            # 4. Auto-Login (Return success data)
            login(request, user)
            return JsonResponse({
                'success': True,
                'user_id': user.id,
                'role': user.role,
                'name': user.get_full_name() or user.username
            })

        except Exception as e:
            return JsonResponse({'success': False, 'message': str(e)}, status=400)

    return JsonResponse({'message': 'Method not allowed'}, status=405)