import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/visit.dart';
import '../services/api_service.dart';

class VisitProvider extends ChangeNotifier {
  int? _userId;
  int? _packageId;
  String? _activityType;
  DateTime? _eventDate;
  String? _location;
  int? _age;
  int? _nbOfVisitors;
  String? _gender;
  String? _phone;

  bool _isLoading = false;
  List<Visit> _visits = [];

  int? get userId => _userId;
  int? get packageId => _packageId;
  String? get activityType => _activityType;
  DateTime? get eventDate => _eventDate;
  String? get location => _location;
  int? get age => _age;
  int? get nbOfVisitors => _nbOfVisitors;
  String? get gender => _gender;
  String? get phone => _phone;
  bool get isLoading => _isLoading;
  List<Visit> get visits => _visits;

  void setUserId(int v) { _userId = v; notifyListeners(); }
  void setPackageId(int v) { _packageId = v; notifyListeners(); }
  void setActivityType(String v) { _activityType = v; notifyListeners(); }
  void setEventDate(DateTime v) { _eventDate = v; notifyListeners(); }
  void setLocation(String v) { _location = v; notifyListeners(); }
  void setAge(int v) { _age = v; notifyListeners(); }
  void setNbOfVisitors(int v) { _nbOfVisitors = v; notifyListeners(); }
  void setGender(String v) { _gender = v; notifyListeners(); }
  void setPhone(String v) { _phone = v; notifyListeners(); }

  Future<bool> submitVisit() async {
    if (_userId == null ||
        _packageId == null ||
        _eventDate == null ||
        _location == null ||
        _age == null ||
        _nbOfVisitors == null ||
        _phone == null) {
      throw Exception('يرجى ملء جميع الحقول');
    }

    _isLoading = true;
    notifyListeners();

    try {
      final success = await ApiService.submitVisit(
        userId: _userId!,
        eventPackageId: _packageId!,
        eventDate: _eventDate!,
        location: _location!,
        age: _age!,
        nbOfVisitors: _nbOfVisitors!,
        phone: _phone!,
        gender: _gender,
        activityType: _activityType,
      );

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Visit submission error: $e");
      return false;
    }
  }

  void resetForm() {
    _userId = null;
    _packageId = null;
    _activityType = null;
    _eventDate = null;
    _location = null;
    _age = null;
    _nbOfVisitors = null;
    _gender = null;
    _phone = null;
    notifyListeners();
  }
}
