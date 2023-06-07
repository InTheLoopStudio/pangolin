import 'package:firebase_auth/firebase_auth.dart';
import 'package:intheloopapp/domains/models/option.dart';

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
  Future<Option<SignInPayload>> signInWithApple();
  Future<void> reauthenticateWithApple();
  Future<void> logout();
  Future<void> recoverPassword({String email});
  Future<void> deleteUser();
}

class SignInPayload {
  SignInPayload({
    required this.uid,
    required this.displayName,
    required this.email,
  });

  final String uid;
  final String displayName;
  final String email;
}
