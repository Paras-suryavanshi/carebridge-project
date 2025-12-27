from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    """
    Extended User model to support roles and profile fields found in frontend.
    Source: user_model.dart
    """
    ROLE_CHOICES = (
        ('patient', 'Patient'),
        ('doctor', 'Doctor'),
    )

    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='patient')
    phone = models.CharField(max_length=20, blank=True, null=True)
    avatar = models.ImageField(upload_to='avatars/', blank=True, null=True)
    date_of_birth = models.DateField(blank=True, null=True)
    blood_group = models.CharField(max_length=5, blank=True, null=True)
    
    # Age is derived from DOB in logic, but storing for caching if needed
    age = models.IntegerField(blank=True, null=True)

    def __str__(self):
        return f"{self.username} ({self.role})"
    
class UserSettings(models.Model):
    """
    Persist user preferences from settings_screen.dart
    """
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='settings')
    notifications_enabled = models.BooleanField(default=True)
    voice_alerts_enabled = models.BooleanField(default=True)
    dark_mode_enabled = models.BooleanField(default=False)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Settings for {self.user.username}"