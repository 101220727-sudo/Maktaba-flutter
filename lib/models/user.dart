import 'package:uuid/uuid.dart';

class User {
  User({
    required this.email,
    required this.phoneNumber,
    required this.name,
    required this.type,
    required this.password,
    id,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String email;
  final String phoneNumber;
  final String name;
  final String type;
  final String password;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      type: json['type'].toString(),
      email: json['email'] ?? '',
      phoneNumber: json['phone'] ?? '',
      name: json['name'] ?? '',

      password: json['password'] ?? '',
    );
  }


  Map<String, Object?> get userMap {
    return {
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'name': name,
      'type': type,
      'password': password,
    };
  }
}
