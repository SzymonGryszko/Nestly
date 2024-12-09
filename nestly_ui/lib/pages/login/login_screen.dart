class LoginScreen extends StatefulWidget {
    @override
    _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController =  TextEditingController();

      @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _loginWithEmailPassword(),
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () => _registerWithEmailPassword(),
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () => _loginWithGoogle(),
              child: Text('Login with Google'),
            ),
            TextButton(
              onPressed: () => _resetPassword(),
              child: Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }


Future<void> _loginWithEmailPassword() async {
    try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
    print('User logged in: ${userCredential.user?.uid}');
  } catch (e) {
    print('Login failed: $e');
  }
  }

  Future<void> _registerWithEmailPassword() async {
     try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
    print('User registered: ${userCredential.user?.uid}');
  } catch (e) {
    print('Registration failed: $e');
  }
  }

  Future<void> _loginWithGoogle() async {
    try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print('Google login success: ${userCredential.user?.uid}');
  } catch (e) {
    print('Google login failed: $e');
  }
  }

  Future<void> _resetPassword() async {
      try {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailController.text);
    print('Password reset email sent');
  } catch (e) {
    print('Password reset failed: $e');
  }
  }


}