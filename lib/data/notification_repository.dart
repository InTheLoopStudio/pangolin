import 'package:intheloopapp/domains/models/user_model.dart';

// ignore: one_member_abstracts
abstract class NotificationRepository {
  Future<void> saveDeviceToken({required UserModel user});
}
