from rest_framework import serializers
from .models import ChatMessage, CallLog

class ChatMessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChatMessage
        fields = ['id', 'user', 'content', 'is_user_sender', 'timestamp']

class CallLogSerializer(serializers.ModelSerializer):
    class Meta:
        model = CallLog
        fields = ['id', 'doctor', 'patient', 'duration', 'started_at', 'status', 'call_type', 'notes']