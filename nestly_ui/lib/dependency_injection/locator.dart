import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nestly_ui/api/api_client.dart';
import 'package:nestly_ui/services/auth_service.dart';
import 'package:nestly_ui/state/nestly_auth_provider.dart';

final getIt = GetIt.instance;

void setup() {
  // Register ApiClient in the DI container
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
  getIt.registerLazySingleton<NestlyAuthProvider>(() => NestlyAuthProvider());
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(FirebaseAuth.instance, getIt<ApiClient>(),
        getIt<GoogleSignIn>(), getIt<NestlyAuthProvider>()),
  );
}
