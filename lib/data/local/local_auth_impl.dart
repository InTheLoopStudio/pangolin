import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

class LocalAuthImpl extends AuthRepository {
  @override
  Stream<UserModel> get user => const Stream.empty();

  @override
  Future<void> updateUserData({required UserModel userData}) async {
    await Future.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Future<bool> isSignedIn() async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  @override
  Future<String> getAuthUserId() async {
    await Future.delayed(const Duration(seconds: 2));
    return '1';
  }

  @override
  Future<void> logout() async {
    return;
  }

  @override
  Future<void> recoverPassword({String email = ''}) async {
    return;
  }

  @override
  Future<UserModel> signInWithApple() async {
    await Future.delayed(const Duration(seconds: 2));
    return UserModel.empty();
  }

  @override
  Future<void> reauthenticateWithApple() async {}

  @override
  Future<UserModel> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 2));
    return UserModel.empty();
  }

  @override
  Future<void> reauthenticateWithGoogle() async {}

  @override
  Future<void> deleteUser() async {
    return;
  }
}
