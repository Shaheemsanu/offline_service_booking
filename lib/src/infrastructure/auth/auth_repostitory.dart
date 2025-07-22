import 'package:offline_service_booking/src/domain/auth/i_auth_repostitory.dart';
import 'package:offline_service_booking/src/domain/core/failures/api_failure.dart';
import 'package:offline_service_booking/src/infrastructure/auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

// Implement the interface created in domain layer to
// create repository like this

// @LazySingleton used to registor a singleton class
//with abstraction with get_it
@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  AuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Future<void> signup({required String email, required String password}) async {
    try {
      await _firebaseAuth.registerWithEmailPassword(
        email: email,
        password: password,
      );
    } catch (_) {
      throw ApiFailure();
    }
  }

  @override
  void login({required String email, required String password}) {}
}
