import 'package:intheloopapp/domains/models/user_model.dart';

abstract class AuthRepository {
  Stream<UserModel> get user;
  Future<void> updateUserData({required UserModel userData});
  Future<bool> isSignedIn();
  Future<String> getAuthUserId();
  Future<UserModel> signInWithGoogle();
  Future<void> reauthenticateWithGoogle();
  Future<UserModel> signInWithApple();
  Future<void> reauthenticateWithApple();
  Future<void> logout();
  Future<void> recoverPassword({String email});
  Future<void> deleteUser();
}
