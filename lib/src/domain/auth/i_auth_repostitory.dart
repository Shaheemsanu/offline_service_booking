// Create an interface for a repository like this

abstract class IAuthRepository {
  Future<void> signup({required String email, required String password});

  void login({required String email, required String password});
}
