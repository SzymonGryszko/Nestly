class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> checkAuthState() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setUser(user);
    });
  }
}