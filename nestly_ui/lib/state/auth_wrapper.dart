class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    if (user != null) {
      return HomePage(); // The next page after login
    } else {
      return LoginScreen();
    }
  }
}