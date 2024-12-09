import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nestly_ui/state/auth_provider.dart' as provider;
import 'package:nestly_ui/state/auth_wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("firebase auth faile ${e}");
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => provider.AuthProvider()..checkAuthState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthWrapper(),
    );
  }
}
