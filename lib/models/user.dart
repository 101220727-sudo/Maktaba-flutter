import 'package:uuid/uuid.dart';

class User {
  User({
    required this.email,
    required this.phoneNumber,
    required this.name,
    required this.location,
    required this.password,
    id,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String email;
  final String phoneNumber;
  final String name;
  final String location;
  final String password;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),          // convert backend id to string
      email: json['email'] ?? '',
      phoneNumber: json['phone'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      password: json['password'] ?? '',
    );
  }


  Map<String, Object?> get userMap {
    return {
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'name': name,
      'location': location,
      'password': password,
    };
  }
}
