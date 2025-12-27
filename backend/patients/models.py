from django.db import models
from django.conf import settings

class PatientProfile(models.Model):
    """
    Specific profile data for users with role='patient'.
    Source: patient_model.dart
    """
    STATUS_CHOICES = (
        ('Stable', 'Stable'),
        ('Critical', 'Critical'),
        ('High', 'High'), # Inferred from alerts
    )
    
    MOOD_CHOICES = (
        ('happy', 'Happy'),
        ('sad', 'Sad'),
        ('neutral', 'Neutral'),
    )

    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='patient_profile')
    caregiver_name = models.CharField(max_length=255, blank=True)
    language = models.CharField(max_length=50, default='English')
    medical_condition = models.CharField(max_length=255, default='General')
    # Link patient to a specific doctor
    assigned_doctor = models.ForeignKey(
        settings.AUTH_USER_MODEL, 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True,
        related_name='assigned_patients',
        limit_choices_to={'role': 'doctor'}
    )
    
    # For the Analytics Dashboard (4.8 rating)
    satisfaction_score = models.FloatField(default=5.0)
    
    # Current status snapshots (updated frequently)
    current_status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Stable')
    current_mood = models.CharField(max_length=20, choices=MOOD_CHOICES, default='neutral')
    
    # Snapshot of last known vitals for quick dashboard access
    last_heart_rate = models.IntegerField(default=72)
    last_temperature = models.FloatField(default=98.6)
    last_blood_pressure = models.CharField(max_length=20, default='120/80')
    last_update = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Profile: {self.user.get_full_name()}"


class VitalSign(models.Model):
    """
    Historical log of health metrics.
    Source: vital_signs_model.dart
    """
    patient = models.ForeignKey(PatientProfile, on_delete=models.CASCADE, related_name='vitals')
    heart_rate = models.IntegerField()
    steps = models.IntegerField(default=0)
    sleep_hours = models.FloatField(default=0.0)
    blood_pressure = models.CharField(max_length=20, default='120/80')
    temperature = models.FloatField(default=98.6)
    oxygen_level = models.IntegerField(default=98)
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Vitals for {self.patient.user.username} at {self.timestamp}"


class Medication(models.Model):
    """
    Prescriptions and schedule.
    Source: medication_model.dart
    """
    patient = models.ForeignKey(PatientProfile, on_delete=models.CASCADE, related_name='medications')
    name = models.CharField(max_length=255)
    dosage = models.CharField(max_length=100)
    frequency = models.CharField(max_length=100) # e.g., "Once daily"
    time_of_day = models.CharField(max_length=100) # e.g., "Morning"
    is_taken = models.BooleanField(default=False)
    notes = models.TextField(blank=True, null=True)
    color_hex = models.CharField(max_length=10, default='#C6E2B5') # For UI styling

    def __str__(self):
        return f"{self.name} - {self.patient.user.username}"


class HealthAlert(models.Model):
    """
    System generated alerts based on vitals or missed meds.
    Source: alerts_screen.dart
    """
    TYPE_CHOICES = (
        ('Critical', 'Critical'),
        ('High', 'High'),
        ('Medium', 'Medium'),
        ('Low', 'Low'),
    )

    patient = models.ForeignKey(PatientProfile, on_delete=models.CASCADE, related_name='alerts')
    alert_type = models.CharField(max_length=20, choices=TYPE_CHOICES)
    message = models.TextField()
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.alert_type}: {self.patient.user.username}"