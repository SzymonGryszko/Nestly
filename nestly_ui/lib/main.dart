import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nestly_ui/dependency_injection/locator.dart';
import 'package:nestly_ui/pages/login/login_screen.dart';
import 'package:nestly_ui/state/nestly_auth_provider.dart' as provider;
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
      create: (_) => provider.NestlyAuthProvider()..initialize(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: ChangeNotifierProvider(
        create: (_) => getIt<provider.NestlyAuthProvider>(),
        child: LoginPage(),
      ),
    );
  }
}
