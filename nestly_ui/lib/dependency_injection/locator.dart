import 'package:get_it/get_it.dart';
import 'package:nestly_ui/api/api_client.dart';

final getIt = GetIt.instance;

void setup() {
  // Register ApiClient in the DI container
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
}
