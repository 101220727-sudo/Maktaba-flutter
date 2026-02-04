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
  })  : status = status ?? '',
        activityType = activityType ?? '',
        placeName = placeName ?? location,
        time = time ?? TimeOfDay.now(),
        date = date ?? eventDate;

  /// Parse JSON from API safely
  factory Visit.fromJson(Map<String, dynamic> json) {
    
    TimeOfDay parseTime(String timeStr) {
      final parts = timeStr.split(':');
      return TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 0,
          minute: int.tryParse(parts[1]) ?? 0);
    }

    return Visit(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      userId: json['user_id'] != null
          ? int.tryParse(json['user_id'].toString()) ?? 0
          : 0,
      packageId: json['package_id'] != null
          ? int.tryParse(json['package_id'].toString()) ?? 0
          : 0,
      eventDate: json['event_date'] != null
          ? DateTime.tryParse(json['event_date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      location: json['location']?.toString() ?? '',
      age: json['age'] != null ? int.tryParse(json['age'].toString()) ?? 0 : 0,
      nbOfVisitors: json['nb_of_visitors'] != null
          ? int.tryParse(json['nb_of_visitors'].toString()) ?? 0
          : 0,
      gender: json['gender']?.toString(),
      phone: json['phone']?.toString() ?? '',
      status: json['status']?.toString() ?? "",
      activityType: json['activity_type']?.toString() ?? '',
      placeName: json['place_name']?.toString() ?? json['location']?.toString() ?? '',
      time: json['time'] != null
          ? parseTime(json['time'].toString())
          : TimeOfDay.now(),
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString())?.toLocal() ?? DateTime.now()
          :DateTime.now(),

    );
  }

  /// Convert Visit to JSON for submission
  Map<String, dynamic> toJson() => {

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
