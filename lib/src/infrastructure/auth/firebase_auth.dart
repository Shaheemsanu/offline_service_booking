/// This class is a replica of FirebaseAuth class
/// which comes form firebase_auth package
class FirebaseAuth {
  Future<void> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception();
    }
  }
}
