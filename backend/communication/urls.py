from django.urls import path
from .views import ChatAPIView, CallTranscriptionView, ClinicalSummaryView # <--- Import this

urlpatterns = [
    path('chat/', ChatAPIView.as_view(), name='chat_api'),
    path('chat/<int:user_id>/', ChatAPIView.as_view(), name='chat_history'),
    path('transcribe/', CallTranscriptionView.as_view(), name='transcribe_call'),
    
    # New Endpoint for Doctor
    path('summary/<int:user_id>/', ClinicalSummaryView.as_view(), name='clinical_summary'),
]