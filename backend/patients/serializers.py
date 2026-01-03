from rest_framework import serializers
from .models import PatientProfile, VitalSign, HealthAlert

class VitalSignSerializer(serializers.ModelSerializer):
    class Meta:
        model = VitalSign
        fields = '__all__'

class PatientProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = PatientProfile
        fields = '__all__'