import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';
import '../models/visit.dart';
import '../models/package.dart';
import '../models/news.dart';
//import '../models/user.dart';
import '../models/loggedInUser.dart';
import 'package:flutter/foundation.dart';
import '../models/upcoming_event.dart';


class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  // ---------------- REGISTER ----------------
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String type,
  }) async {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/register"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'type': type,
      }),
    );
    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
    
  }

  // ---------------- PACKAGES ----------------
  // ---------------- PACKAGES ----------------
  static Future<List<EventPackage>> getPackages({
    int? age,        // change from ageGroup
    int? visitors,
    String? gender,
  }) async {
    Uri url;
    final query = {
      if (age != null) 'age': age.toString(),
      if (visitors != null) 'visitors': visitors.toString(),
      if (gender != null) 'gender': gender,
    };
    url = Uri.parse("$baseUrl/event-packages").replace(queryParameters: query);

    final response = await http.get(url,headers: {'Accept': 'application/json',},);

    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('RESPONSE BODY: ${response.body}');
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List jsonData = decoded['data'] ?? decoded; // sometimes API returns list directly
      return jsonData.map((e) => EventPackage.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load packages: ${response.body}");
    }
  }




  // ---------------- SUBMIT VISIT ----------------
  static Future<bool> submitVisit({
   required int userId,
   required int eventPackageId,
   required DateTime eventDate,
   required String location,
   required int age,
   required int nbOfVisitors,
   String? gender,
   required String phone,
   String? activityType,
  }) async {


  final response = await http.post(
    Uri.parse("$baseUrl/event-requests"),
    headers: {
    'Content-Type': 'application/json', // tells Laravel you are sending JSON
    'Accept': 'application/json',  
    },
    body: jsonEncode({
      "user_id": userId,
      "event_package_id": eventPackageId,
      "event_date": eventDate.toIso8601String(),
      "location": location,
      "age": age,
      "nb_of_visitors": nbOfVisitors,
      "gender": gender,
      "phone": phone,
      "activity_type": activityType,
    }),
  );

  debugPrint("SEND BODY: userId: $userId, eventPackageId: $eventPackageId, eventDate: $eventDate, location: $location, nbOfVisitors: $nbOfVisitors, gender: $gender");

  final data = json.decode(response.body);

  if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
    debugPrint("Visit created successfully: ID ${data['visit']['id']}");
    return true;
  } else {
    debugPrint("ERROR RESPONSE: ${response.body}");
    return false;
  }
}


  // Get all visits of a user
  static Future<List<Visit>> getUserVisits(int userId) async {
    final url = Uri.parse("$baseUrl/event-requests/$userId");
    final response = await http.get(url, headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
     print("Raw visits response: ${response.body}");
     final data = jsonDecode(response.body);

     // If backend returns an array directly
     final List visitList = data is List ? data : data['data'] ?? [];

     final visits = visitList.map((v) => Visit.fromJson(v)).toList();
     print("Parsed visits count: ${visits.length}");
     return visits;
    } else {
      debugPrint("ERROR RESPONSE: ${response.body}");
      throw Exception('Failed to load visits');
    }
  }



    // ---------------- NEWS ----------------
  static Future<List<News>> getNews() async {
    final response = await http.get(
      Uri.parse("$baseUrl/news"),
      headers: {'Accept': 'application/json'},
    );

    debugPrint('NEWS STATUS: ${response.statusCode}');
    debugPrint('NEWS BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      final List jsonData = decoded['data'] ?? decoded;
      return jsonData.map((e) => News.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load news: ${response.body}");
    }
  }

  // ---------------- LOGIN ----------------
  static Future<LoggedInUser> loginUser({
  required String email,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse("$baseUrl/login"),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'email': email, 'password': password}),
  );

  debugPrint('STATUS: ${response.statusCode}');
  debugPrint('BODY: ${response.body}');


  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['status'] == true) {
      return LoggedInUser.fromJson(data['user']);
    } else {
      throw Exception(data['message']);
    }
  } else {
    throw Exception('Login failed: ${response.body}');
  }
}

// ---------------- UPCOMING EVENTS ----------------
static Future<List<UpcomingEvent>> fetchUpcomingEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/upcoming-events'));

  debugPrint('STATUS: ${response.statusCode}');
  debugPrint('BODY: ${response.body}');



    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<UpcomingEvent> events = (data['events'] as List)
          .map((eventJson) => UpcomingEvent.fromJson(eventJson))
          .toList();
      return events;
    } else {
      throw Exception('Failed to load upcoming events');
    }
  }

  // ---------------- DELETE VISIT ----------------
  static Future<bool> deleteVisit(int id) async {
    final url = "$baseUrl/event-requests/$id";
    debugPrint("DELETE URL: $url");

    final res = await http.delete(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
      },
    );

    debugPrint("DELETE STATUS: ${res.statusCode}");
    debugPrint("DELETE BODY: ${res.body}");

    return res.statusCode == 200;
  }


}


