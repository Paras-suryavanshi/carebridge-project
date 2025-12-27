class PatientModel {
  final String id;
  final String name;
  final int age;
  final String phone;
  final String language;
  final String caregiver;
  final String lastCall;
  final String mood;
  final String avatar;
  final String status;
  final String condition;
  final int heartRate;
  final double temperature;
  final String bloodPressure;
  final String lastUpdate;

  PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.phone,
    required this.language,
    required this.caregiver,
    required this.lastCall,
    required this.mood,
    required this.avatar,
    this.status = 'Stable',
    this.condition = 'General',
    this.heartRate = 72,
    this.temperature = 98.6,
    this.bloodPressure = '120/80',
    this.lastUpdate = 'Just now',
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      phone: json['phone'],
      language: json['language'],
      caregiver: json['caregiver'],
      lastCall: json['lastCall'],
      mood: json['mood'],
      avatar: json['avatar'],
      status: json['status'] ?? 'Stable',
      condition: json['condition'] ?? 'General',
      heartRate: json['heartRate'] ?? 72,
      temperature: json['temperature']?.toDouble() ?? 98.6,
      bloodPressure: json['bloodPressure'] ?? '120/80',
      lastUpdate: json['lastUpdate'] ?? 'Just now',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'phone': phone,
      'language': language,
      'caregiver': caregiver,
      'lastCall': lastCall,
      'mood': mood,
      'avatar': avatar,
      'status': status,
      'condition': condition,
      'heartRate': heartRate,
      'temperature': temperature,
      'bloodPressure': bloodPressure,
      'lastUpdate': lastUpdate,
    };
  }

  String get moodEmoji {
    switch (mood.toLowerCase()) {
      case 'happy':
        return '😊';
      case 'sad':
        return '😢';
      case 'neutral':
        return '😐';
      default:
        return '😊';
    }
  }

  String get initials {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  String get moodIcon {
    return moodEmoji;
  }

  static List<PatientModel> samplePatients = [
    PatientModel(
      id: '1',
      name: 'Rajesh Kumar',
      age: 72,
      phone: '+91 98765 43210',
      language: 'Hindi',
      caregiver: 'Priya Kumar',
      lastCall: '2 hours ago',
      mood: 'happy',
      avatar: 'RK',
    ),
    PatientModel(
      id: '2',
      name: 'Sunita Devi',
      age: 68,
      phone: '+91 87654 32109',
      language: 'Bengali',
      caregiver: 'Amit Devi',
      lastCall: '4 hours ago',
      mood: 'neutral',
      avatar: 'SD',
    ),
    PatientModel(
      id: '3',
      name: 'Mohammed Ali',
      age: 75,
      phone: '+91 76543 21098',
      language: 'English',
      caregiver: 'Fatima Ali',
      lastCall: '1 day ago',
      mood: 'sad',
      avatar: 'MA',
    ),
    PatientModel(
      id: '4',
      name: 'Lakshmi Iyer',
      age: 70,
      phone: '+91 65432 10987',
      language: 'Tamil',
      caregiver: 'Ravi Iyer',
      lastCall: '30 minutes ago',
      mood: 'happy',
      avatar: 'LI',
    ),
  ];
}
