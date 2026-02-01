import 'package:flutter/material.dart';
import 'package:library_app/db/library_database.dart';
import 'package:library_app/models/visit.dart';

Future<void> insertVisit(Visit visit) async {
  final db = await LibraryDatabase().getDatabase();
  await db.insert('visits', visitDbMap(visit));
}

Future<List<Visit>> loadVisits(String userId) async {
  final db = await LibraryDatabase().getDatabase();

  final result = await db.query(
    'visits',
    where: 'userId = ?',
    whereArgs: [int.parse(userId)],
  );

  return result.map((row) {
    return Visit(
      id: row['id'] as int,
      userId: row['userId'] as int,
      packageId: row['packageId'] as int,
      eventDate: DateTime.parse(row['eventDate'] as String),
      location: row['location'] as String,
      age: row['age'] as int,
      nbOfVisitors: row['nbOfVisitors'] as int,
      gender: row['gender'] as String?,
      phone: row['phone'] as String,
      status: row['status'] as String? ?? 'pending',
      activityType: row['activityType'] as String? ?? '',
      placeName: row['placeName'] as String? ?? row['location'] as String,
      time: TimeOfDay(hour: 10, minute: 0), // Default time, adjust as needed
      date: DateTime.parse(row['eventDate'] as String),
    );
  }).toList();
}

Future<void> deleteVisit(Visit visit) async {
  final db = await LibraryDatabase().getDatabase();
  await db.delete('visits', where: 'id = ?', whereArgs: [visit.id]);
}

Future<void> updateVisit(Visit visit) async {
  final db = await LibraryDatabase().getDatabase();
  await db.update(
    'visits',
    visitDbMap(visit),
    where: 'id = ?',
    whereArgs: [visit.id],
  );
}

/// Map for SQLite (NOT API)
Map<String, dynamic> visitDbMap(Visit v) => {
      'id': v.id,
      'userId': v.userId,
      'packageId': v.packageId,
      'eventDate': v.eventDate.toIso8601String(),
      'location': v.location,
      'age': v.age,
      'nbOfVisitors': v.nbOfVisitors,
      'gender': v.gender,
      'phone': v.phone,
      'status': v.status,
      'activityType': v.activityType,
      'placeName': v.placeName,
      'time': '${v.time.hour}:${v.time.minute.toString().padLeft(2, '0')}',
      'date': v.date.toIso8601String(),
    };
