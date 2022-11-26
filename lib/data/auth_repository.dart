abstract class AuthRepository {
  Stream<String> get userId;
  Future<void> updateUserData({required String userId});
  Future<bool> isSignedIn();
  Future<String> getAuthUserId();
  Future<String> signInWithGoogle();
  Future<void> reauthenticateWithGoogle();
  Future<String> signInWithApple();
  Future<void> reauthenticateWithApple();
  Future<void> logout();
  Future<void> recoverPassword({String email});
  Future<void> deleteUser();
}
