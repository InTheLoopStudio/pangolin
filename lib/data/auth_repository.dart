abstract class AuthRepository {
  Stream<String> get userId;
  Future<bool> isSignedIn();
  Future<String> getAuthUserId();
  Future<String?> signInWithCredentials(
    String email,
    String password,
  );
  Future<String?> signUpWithCredentials(
    String email,
    String password,
  );
  Future<String> signInWithGoogle();
  Future<void> reauthenticateWithGoogle();
  Future<String> signInWithApple();
  Future<void> reauthenticateWithApple();
  Future<void> logout();
  Future<void> recoverPassword({String email});
  Future<void> deleteUser();
}
