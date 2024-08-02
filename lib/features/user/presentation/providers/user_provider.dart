import 'package:flutter/material.dart';
// import 'package:gemini/features/authentication/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
class UserProvider extends ChangeNotifier {
  User? _user;
  String? _profile;

  User? get user => _user;
  String? get profile => _profile;

  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  set profileUpdate(String profile) {
    _profile = profile;
    notifyListeners();
  }
}
