import 'package:flutter/material.dart';

// --- IMPORTS FOR SCREENS WE HAVE BUILT ---
import '../screens/patient/patient_dashboard.dart';
import '../screens/patient/care_ai_screen.dart';
import '../screens/doctor/doctor_dashboard.dart';

// --- IMPORTS FOR AUTH (Uncomment if you have these files) ---
import '../screens/splash/splash_screen.dart';
import '../screens/landing/landing_screen.dart';
import '../screens/auth/login_screen.dart';

// --- IMPORTS FOR OTHER SCREENS (Uncomment if you have these files) ---
import '../screens/patient/medications_screen.dart';
import '../screens/patient/settings_screen.dart';
import '../screens/patient/about_screen.dart';
import '../screens/doctor/patients_screen.dart';
import '../screens/doctor/call_logs_screen.dart';
import '../screens/doctor/analytics_screen.dart';
import '../screens/doctor/alerts_screen.dart';

class AppRoutes {
  AppRoutes._();

  // --- ROUTE NAMES ---
  static const String splash = '/';
  static const String landing = '/landing';
  static const String login = '/login';

  // Patient Routes
  static const String patientDashboard = '/patient/dashboard';
  static const String careAI = '/patient/care-ai';
  static const String medications = '/patient/medications';
  static const String settings = '/patient/settings';
  static const String about = '/patient/about';

  // Doctor Routes
  static const String doctorDashboard = '/doctor/dashboard';
  static const String doctorPatients = '/doctor/patients';
  static const String callLogs = '/doctor/call-logs';
  static const String analytics = '/doctor/analytics';
  static const String alerts = '/doctor/alerts';

  // --- ROUTE GENERATOR ---
  // Fix 1: Renamed argument to 'routeSettings' to avoid conflict with 'settings' constant
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      // 1. Splash & Auth
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case landing:
        return MaterialPageRoute(builder: (_) => const LandingScreen());
      case login:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => LoginScreen(role: args?['role'] ?? 'patient'),
        );

      // 2. Patient Routes
      case patientDashboard:
        return MaterialPageRoute(builder: (_) => const PatientDashboard());
      case careAI:
        return MaterialPageRoute(builder: (_) => const CareAIScreen());
      case medications:
        return MaterialPageRoute(builder: (_) => const _PlaceholderScreen(title: "Medications"));
      case settings:
        return MaterialPageRoute(builder: (_) => const _PlaceholderScreen(title: "Settings"));
      case about:
        return MaterialPageRoute(builder: (_) => const _PlaceholderScreen(title: "About App"));

      // 3. Doctor Routes
      case doctorDashboard:
        return MaterialPageRoute(builder: (_) => const DoctorDashboard());
      case doctorPatients:
        return MaterialPageRoute(builder: (_) => const _PlaceholderScreen(title: "Doctor: Patient List"));
      case callLogs:
        return MaterialPageRoute(builder: (_) => const _PlaceholderScreen(title: "Doctor: Call Logs"));
      case analytics:
        return MaterialPageRoute(builder: (_) => const _PlaceholderScreen(title: "Doctor: Analytics"));
      case alerts:
        return MaterialPageRoute(builder: (_) => const _PlaceholderScreen(title: "Doctor: Alerts"));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${routeSettings.name}')),
          ),
        );
    }
  }

  // --- FIX 2: RE-ADDED NAVIGATION HELPERS ---
  
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

// --- HELPER WIDGET ---
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Under Development", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}