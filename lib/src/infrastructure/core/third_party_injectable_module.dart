import 'package:offline_service_booking/src/infrastructure/auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

// Register module for third party dependencies
@module
abstract class ThirdPartyInjectableModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth();
}
