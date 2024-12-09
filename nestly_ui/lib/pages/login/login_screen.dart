import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nestly_ui/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = GetIt.I<AuthService>();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child:
                    Text(_errorMessage!, style: TextStyle(color: Colors.red)),
              ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _loginWithEmailPassword,
                    child: Text('Login with Email'),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginWithGoogle,
              child: Text('Login with Google'),
            ),
          ],
        ),
      ),
    );
  }

  // Handle email/password login
  Future<void> _loginWithEmailPassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    bool success =
        await _authService.authenticateWithEmailPassword(email, password);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    }
  }

  // Handle Google login
  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    bool success = await _authService.authenticateWithGoogle();

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = 'Google sign-in failed';
      });
    }
  }
}
