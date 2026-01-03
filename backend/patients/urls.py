from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import PatientViewSet, VitalSignViewSet

router = DefaultRouter()
router.register(r'profiles', PatientViewSet)
router.register(r'vitals', VitalSignViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
