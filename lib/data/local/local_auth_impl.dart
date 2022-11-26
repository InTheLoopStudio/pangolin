import 'package:intheloopapp/data/auth_repository.dart';

class LocalAuthImpl extends AuthRepository {
  @override
  Stream<String> get userId => const Stream.empty();

  @override
  Future<void> updateUserData({required String userId}) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Future<bool> isSignedIn() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return true;
  }

  @override
  Future<String> getAuthUserId() async {
    await Future<void>.delayed(const Duration(seconds: 2));
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
  Future<String> signInWithApple() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return '';
  }

  @override
  Future<void> reauthenticateWithApple() async {}

  @override
  Future<String> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return '';
  }

  @override
  Future<void> reauthenticateWithGoogle() async {}

  @override
  Future<void> deleteUser() async {
    return;
  }
}
