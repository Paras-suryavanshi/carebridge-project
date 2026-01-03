from rest_framework import viewsets
from .models import PatientProfile, VitalSign
from .serializers import PatientProfileSerializer, VitalSignSerializer

class PatientViewSet(viewsets.ModelViewSet):
    queryset = PatientProfile.objects.all()
    serializer_class = PatientProfileSerializer

class VitalSignViewSet(viewsets.ModelViewSet):
    queryset = VitalSign.objects.all()
    serializer_class = VitalSignSerializer