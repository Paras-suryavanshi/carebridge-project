from django.urls import path
from . import views

urlpatterns = [
    path('login/', views.login_view, name='login'),
    path('register/', views.register_view, name='register'),
    path('profile/', views.get_profile, name='profile'),
    path('settings/', views.get_settings, name='settings'),
    path('settings/update/', views.update_settings, name='update_settings'),
]