import 'package:flutter/material.dart';

class Visit {
  final int id;
  final int userId;
  final int packageId;
  final DateTime eventDate;
  final String location;
  final int age;
  final int nbOfVisitors;
  final String? gender;
  final String phone;
  final String status;
  final String activityType;
  final String placeName;
  final TimeOfDay time;
  final DateTime date;

  Visit({
    required this.id,
    required this.userId,
    required this.packageId,
    required this.eventDate,
    required this.location,
    required this.age,
    required this.nbOfVisitors,
    this.gender,
    required this.phone,
    String? status,
    String? activityType,
    String? placeName,
    TimeOfDay? time,
    DateTime? date,
  }) :
    status = status ?? 'pending',
    activityType = activityType ?? '',
    placeName = placeName ?? location,
    time = time ?? TimeOfDay.now(),
    date = date ?? eventDate;

  factory Visit.fromJson(Map<String, dynamic> json) {
    // Parse time string like "10:00" to TimeOfDay
    TimeOfDay parseTime(String timeStr) {
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return Visit(
      id: json['id'],
      userId: json['user_id'],
      packageId: json['package_id'],
      eventDate: DateTime.parse(json['event_date']),
      location: json['location'],
      age: json['age'],
      nbOfVisitors: json['nb_of_visitors'],
      gender: json['gender'],
      phone: json['phone'],
      status: json['status'] ?? 'pending',
      activityType: json['activity_type'] ?? '',
      placeName: json['place_name'] ?? json['location'],
      time: json['time'] != null ? parseTime(json['time']) : TimeOfDay.now(),
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.parse(json['event_date']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'package_id': packageId,
        'event_date': eventDate.toIso8601String(),
        'location': location,
        'age': age,
        'nb_of_visitors': nbOfVisitors,
        'gender': gender,
        'phone': phone,
      };
}
