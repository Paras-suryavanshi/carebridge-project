from django.db import models
from django.conf import settings

class CallLog(models.Model):
    """
    Logs of calls between doctors and patients.
    Source: call_logs_screen.dart
    """
    STATUS_CHOICES = (
        ('Completed', 'Completed'),
        ('Missed', 'Missed'),
        ('Ongoing', 'Ongoing'),
    )
    
    TYPE_CHOICES = (
        ('Video', 'Video'),
        ('Audio', 'Audio'),
    )

    # Doctor is the user initiating/receiving, Patient is the target
    doctor = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='doctor_calls')
    patient = models.ForeignKey('patients.PatientProfile', on_delete=models.CASCADE, related_name='patient_calls')
    
    duration = models.CharField(max_length=20, help_text="Duration string like 15:32")
    started_at = models.DateTimeField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES)
    call_type = models.CharField(max_length=10, choices=TYPE_CHOICES)
    notes = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"Call {self.status} - {self.patient.user.username}"


class ChatMessage(models.Model):
    """
    Care AI chat history.
    Source: message_model.dart / care_ai_screen.dart
    """
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='chat_messages')
    content = models.TextField()
    is_user_sender = models.BooleanField(default=True, help_text="True if sent by user, False if sent by AI")
    timestamp = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['timestamp']

    def __str__(self):
        sender = "User" if self.is_user_sender else "AI"
        return f"{sender}: {self.content[:30]}..."