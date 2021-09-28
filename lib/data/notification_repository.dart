import 'package:intheloopapp/domains/models/user_model.dart';

abstract class NotificationRepository {
  Future<void> saveDeviceToken({required UserModel user});
}
