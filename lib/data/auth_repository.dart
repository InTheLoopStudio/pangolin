import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get user;
  Future<bool> isSignedIn();
  Future<String> getAuthUserId();
  Future<User?> getAuthUser();
  Future<String?> signInWithCredentials(
    String email,
    String password,
  );
  Future<void> reauthenticateWithCredentials(
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
