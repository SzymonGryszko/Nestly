import 'package:flutter/material.dart';
import 'package:nestly_ui/pages/home_page/home_page.dart';
import 'package:nestly_ui/pages/login/login_screen.dart';
import 'package:nestly_ui/state/auth_provider.dart' as provider;
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<provider.AuthProvider>(context).user;

    if (user != null) {
      return HomePage(); // The next page after login
    } else {
      return LoginScreen();
    }
  }
}
