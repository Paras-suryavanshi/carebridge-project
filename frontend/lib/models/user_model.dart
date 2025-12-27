class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'patient' or 'doctor'
  final String? phone;
  final String? avatar;
  final DateTime? dateOfBirth;
  final String? bloodGroup;
  final int? age;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.avatar,
    this.dateOfBirth,
    this.bloodGroup,
    this.age,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
      avatar: json['avatar'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      bloodGroup: json['bloodGroup'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'avatar': avatar,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'bloodGroup': bloodGroup,
      'age': age,
    };
  }

  String get initials {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  String get firstName {
    return name.split(' ').first;
  }
}
