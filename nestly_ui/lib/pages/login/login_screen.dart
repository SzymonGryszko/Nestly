import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:nestly_ui/api/api_client.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providerConfigs: [
        EmailProviderConfiguration(),
        GoogleProviderConfiguration(
          clientId: DefaultFirebaseOptions.currentPlatform.googleClientId,
        ),
      ],
      actions: [
        AuthStateChangeAction((context, _) async {
          final user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            // Get the Firebase ID token
            final idToken = await user.getIdToken();

            // Send the token to your backend for validation and user creation
            final response = await _authenticateWithBackend(idToken!);

            if (response.statusCode == 200) {
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              // Handle backend error (e.g., invalid token)
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Authentication Failed'),
                  content: Text('Unable to validate user.'),
                ),
              );
            }
          }
        }),
      ],
    );
  }

  Future<Response> _authenticateWithBackend(String idToken) async {
    final ApiClient _apiClient = GetIt.instance<ApiClient>();
    final response = await _apiClient.post('auth/validate-token');
    return response;
  }
}
