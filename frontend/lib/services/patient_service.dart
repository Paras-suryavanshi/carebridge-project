import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vital_signs_model.dart';

class PatientService {
  // Use 127.0.0.1 for Web, 10.0.2.2 for Android Emulator
  static const String baseUrl = 'http://127.0.0.1:8000/api/patients';

  // Fetch Profile (Mood, Status, Basic Info)
  // We use ID 1 for the hackathon demo
  static Future<Map<String, dynamic>> getPatientProfile() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/profiles/1/'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      // Return fallback data if server is down
      return {
        'current_status': 'Unknown',
        'current_mood': 'Neutral',
        'last_heart_rate': 0,
        'last_temperature': 0.0,
      };
    }
  }

  // Fetch Vitals (Heart Rate, Steps history)
  static Future<VitalSignsModel> getLatestVitals() async {
    final profile = await getPatientProfile();
    
    // Helper to safely convert numeric values to double
    double toDouble(dynamic value) {
      if (value is int) return value.toDouble();
      if (value is double) return value;
      return 0.0;
    }

    return VitalSignsModel(
      heartRate: profile['last_heart_rate'] ?? 72,
      steps: 0, // Placeholder as we don't have step tracking yet
      
      // FIX 1: Correct parameter name (sleepHours) and type (double)
      sleepHours: 0.0, 
      
      // FIX 2: Added required 'totalMedications' parameter
      medicationsTaken: 0,
      totalMedications: 0, 
      
      bloodPressure: profile['last_blood_pressure'] ?? '120/80',
      
      // FIX 3: Ensure temperature is a double
      temperature: toDouble(profile['last_temperature'] ?? 98.6),
      
      // FIX 4: Added required 'timestamp'
      timestamp: DateTime.now(),
    );
  }
}