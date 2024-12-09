import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void initialize() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setUser(user);
    });
  }
}
