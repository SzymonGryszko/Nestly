import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nestly_ui/dependency_injection/locator.dart';
import 'package:nestly_ui/pages/home_page/home_page.dart';
import 'package:nestly_ui/pages/login/login_screen.dart';
import 'package:nestly_ui/state/auth_provider.dart' as provider;
import 'package:provider/provider.dart';

void main() async {
  setup();

  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("firebase auth faile ${e}");
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => provider.AuthProvider()..initialize(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return ChangeNotifierProvider<provider.AuthProvider>(
      create: (_) => provider.AuthProvider()..initialize(),
      child: MaterialApp(
        title: 'Nestly',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => LoginPage(),
          '/home': (context) => HomePage(), // Your home page
        },
      ),
    );
  }
}
