import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:nestly_ui/api/api_client.dart';
import 'package:nestly_ui/services/auth_service.dart';

final getIt = GetIt.instance;

void setup() {
  // Register ApiClient in the DI container
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(
      firebaseAuth: FirebaseAuth.instance,
      apiClient: getIt<ApiClient>(),
    ),
  );
}
