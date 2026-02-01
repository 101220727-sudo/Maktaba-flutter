import 'package:flutter/material.dart';
import '../models/package.dart';
import '../services/api_service.dart';

class PackageProvider extends ChangeNotifier {
  List<EventPackage> _packages = [];
  bool _isLoading = false;

  List<EventPackage> get packages => _packages;
  bool get isLoading => _isLoading;

  Future<void> loadPackages({
    int? age,
    int? visitors,
    String? gender,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      _packages = await ApiService.getPackages(
        age: age,
        visitors: visitors,
        gender: gender,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
