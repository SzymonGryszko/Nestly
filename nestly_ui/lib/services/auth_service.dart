import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nestly_ui/api/api_client.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final ApiClient _apiClient;
  final GoogleSignIn _googleSignIn;

  AuthService(this._firebaseAuth, this._apiClient, this._googleSignIn);

  // Authenticate with email and password
  Future<bool> authenticateWithEmailPassword(
      String email, String password) async {
    try {
      // Sign in with Firebase
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Call your backend to validate and create the user if needed
      await authenticateWithBackend(userCredential.user!.uid);

      return true;
    } catch (e) {
      // Handle authentication failure
      return false;
    }
  }

  // Authenticate with Google sign-in
  Future<bool> authenticateWithGoogle() async {
    try {
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return false; // User cancelled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a credential to sign in with Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Call your backend to validate and create the user if needed
      await authenticateWithBackend(userCredential.user!.uid);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticateWithBackend(String firebaseUid) async {
    try {
      // Call the backend to authenticate the user
      final response = await _apiClient.post('/auth/login', data: {
        'firebaseUid': firebaseUid,
      });

      if (response.statusCode == 200) {
        // Backend authentication successful
        // You can handle saving the token or user data if necessary
        return true;
      } else {
        // Backend returned an error (e.g., user not found)
        return false;
      }
    } catch (e) {
      // Handle any errors (network issues, etc.)
      return false;
    }
  }

  // Sign out the user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
