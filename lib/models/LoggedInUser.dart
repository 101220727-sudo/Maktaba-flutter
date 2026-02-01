class LoggedInUser {
  LoggedInUser({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.name,
    required this.location,
  });

  final String id;
  final String email;
  final String phoneNumber;
  final String name;
  final String location;

  // ---------------- From JSON ----------------
  factory LoggedInUser.fromJson(Map<String, dynamic> json) {
    return LoggedInUser(
      id: json['id'].toString(),
      email: json['email'] ?? '',
      phoneNumber: json['phone'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
    );
  }

  // ---------------- To JSON ---------------- (optional)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phoneNumber,
      'name': name,
      'location': location,
    };
  }
}
