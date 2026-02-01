import 'package:flutter/material.dart';
import '../models/loggedInUser.dart';

class AuthProvider extends ChangeNotifier {
  LoggedInUser? _user;

  LoggedInUser? get user => _user;

  // ------------------ Set logged-in user ------------------
  void setLoggedInUser(LoggedInUser user) {
    _user = user;
    notifyListeners();
  }

  // ------------------ Logout ------------------
  void logout() {
    _user = null;
    notifyListeners();
  }

  // ------------------ Check if user is logged in ------------------
  bool get isLoggedIn => _user != null;
}
