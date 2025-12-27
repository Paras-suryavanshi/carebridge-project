import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/landing/landing_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/patient/patient_dashboard.dart';
import '../screens/patient/care_ai_screen.dart';
import '../screens/patient/medications_screen.dart';
import '../screens/patient/settings_screen.dart';
import '../screens/patient/about_screen.dart';
import '../screens/doctor/doctor_dashboard.dart';
import '../screens/doctor/patients_screen.dart';
import '../screens/doctor/call_logs_screen.dart';
import '../screens/doctor/analytics_screen.dart';
import '../screens/doctor/alerts_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Route Names
  static const String splash = '/';
  static const String landing = '/landing';
  static const String login = '/login';

  // Patient Routes
  static const String patientDashboard = '/patient/dashboard';
  static const String careAI = '/patient/care-ai';
  static const String patientCareAI = '/patient/care-ai';
  static const String medications = '/patient/medications';
  static const String patientMedications = '/patient/medications';
  static const String settings = '/patient/settings';
  static const String patientSettings = '/patient/settings';
  static const String about = '/patient/about';
  static const String patientAbout = '/patient/about';

  // Doctor Routes
  static const String doctorDashboard = '/doctor/dashboard';
  static const String doctorPatients = '/doctor/patients';
  static const String callLogs = '/doctor/call-logs';
  static const String analytics = '/doctor/analytics';
  static const String alerts = '/doctor/alerts';

  // Route Generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case landing:
        return MaterialPageRoute(builder: (_) => const LandingScreen());

      case login:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => LoginScreen(role: args?['role'] ?? 'patient'),
        );

      // Patient Routes
      case patientDashboard:
        return MaterialPageRoute(builder: (_) => const PatientDashboard());

      case patientCareAI:
        return MaterialPageRoute(builder: (_) => const CareAIScreen());

      case patientMedications:
        return MaterialPageRoute(builder: (_) => const MedicationsScreen());

      case patientSettings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case patientAbout:
        return MaterialPageRoute(builder: (_) => const AboutScreen());

      // Doctor Routes
      case doctorDashboard:
        return MaterialPageRoute(builder: (_) => const DoctorDashboard());

      case doctorPatients:
        return MaterialPageRoute(builder: (_) => const PatientsScreen());

      case callLogs:
        return MaterialPageRoute(builder: (_) => const CallLogsScreen());

      case analytics:
        return MaterialPageRoute(builder: (_) => const AnalyticsScreen());

      case alerts:
        return MaterialPageRoute(builder: (_) => const AlertsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  // Navigation Helpers
  static void navigateToLanding(BuildContext context) {
    Navigator.pushReplacementNamed(context, landing);
  }

  static void navigateToLogin(BuildContext context, {required String role}) {
    Navigator.pushNamed(context, login, arguments: {'role': role});
  }

  static void navigateToPatientDashboard(BuildContext context) {
    Navigator.pushReplacementNamed(context, patientDashboard);
  }

  static void navigateToDoctorDashboard(BuildContext context) {
    Navigator.pushReplacementNamed(context, doctorDashboard);
  }

  static void logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, landing, (route) => false);
  }
}
