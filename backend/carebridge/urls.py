from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/communication/', include('communication.urls')),
    path('api/patients/', include('patients.urls')),
    # Users API can be added similarly if needed
]
