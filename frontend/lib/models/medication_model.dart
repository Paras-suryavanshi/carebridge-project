class MedicationModel {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final String time;
  final bool isTaken;
  final String? notes;
  final String color;

  MedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.time,
    this.isTaken = false,
    this.notes,
    this.color = '#C6E2B5',
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      time: json['time'],
      isTaken: json['isTaken'] ?? false,
      notes: json['notes'],
      color: json['color'] ?? '#C6E2B5',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'time': time,
      'isTaken': isTaken,
      'notes': notes,
      'color': color,
    };
  }

  MedicationModel copyWith({
    String? id,
    String? name,
    String? dosage,
    String? frequency,
    String? time,
    bool? isTaken,
    String? notes,
    String? color,
  }) {
    return MedicationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      time: time ?? this.time,
      isTaken: isTaken ?? this.isTaken,
      notes: notes ?? this.notes,
      color: color ?? this.color,
    );
  }

  static List<MedicationModel> sampleMedications = [
    MedicationModel(
      id: '1',
      name: 'Lisinopril',
      dosage: '10mg',
      frequency: 'Once daily',
      time: 'Morning',
      isTaken: true,
      color: '#C6E2B5',
    ),
    MedicationModel(
      id: '2',
      name: 'Metformin',
      dosage: '500mg',
      frequency: 'Twice daily',
      time: 'Morning & Evening',
      isTaken: false,
      color: '#A8DADC',
    ),
    MedicationModel(
      id: '3',
      name: 'Aspirin',
      dosage: '81mg',
      frequency: 'Once daily',
      time: 'Evening',
      isTaken: false,
      color: '#FFD580',
    ),
  ];
}
