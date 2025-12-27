class VitalSignsModel {
  final int heartRate;
  final int steps;
  final double sleepHours;
  final int medicationsTaken;
  final int totalMedications;
  final String bloodPressure;
  final double temperature;
  final int oxygenLevel;
  final DateTime timestamp;

  VitalSignsModel({
    required this.heartRate,
    required this.steps,
    required this.sleepHours,
    required this.medicationsTaken,
    required this.totalMedications,
    this.bloodPressure = '120/80',
    this.temperature = 98.6,
    this.oxygenLevel = 98,
    required this.timestamp,
  });

  factory VitalSignsModel.fromJson(Map<String, dynamic> json) {
    return VitalSignsModel(
      heartRate: json['heartRate'],
      steps: json['steps'],
      sleepHours: json['sleepHours'].toDouble(),
      medicationsTaken: json['medicationsTaken'],
      totalMedications: json['totalMedications'],
      bloodPressure: json['bloodPressure'] ?? '120/80',
      temperature: json['temperature']?.toDouble() ?? 98.6,
      oxygenLevel: json['oxygenLevel'] ?? 98,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'heartRate': heartRate,
      'steps': steps,
      'sleepHours': sleepHours,
      'medicationsTaken': medicationsTaken,
      'totalMedications': totalMedications,
      'bloodPressure': bloodPressure,
      'temperature': temperature,
      'oxygenLevel': oxygenLevel,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  String get heartRateStatus {
    if (heartRate < 60) return 'Low';
    if (heartRate > 100) return 'High';
    return 'Normal';
  }

  String get stepsStatus {
    if (steps < 3000) return 'Low';
    if (steps > 7000) return 'Excellent';
    return 'Good';
  }

  String get sleepStatus {
    if (sleepHours < 6) return 'Poor';
    if (sleepHours > 9) return 'Too Much';
    return 'Good';
  }

  String get medicationStatus {
    if (medicationsTaken == totalMedications) return 'On Track';
    if (medicationsTaken > totalMedications / 2) return 'Partial';
    return 'Behind';
  }

  String get sleep {
    return '${sleepHours}h';
  }

  factory VitalSignsModel.defaultValues() {
    return VitalSignsModel(
      heartRate: 72,
      steps: 5420,
      sleepHours: 7.5,
      medicationsTaken: 2,
      totalMedications: 3,
      bloodPressure: '120/80',
      temperature: 98.6,
      oxygenLevel: 98,
      timestamp: DateTime.now(),
    );
  }
}
