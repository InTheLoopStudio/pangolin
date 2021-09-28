import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

abstract class StreamRepository {
  Future<List<UserModel>> getChatUsers();
  Future<String> getToken(String userId);
  // Future<bool> connectIfExist(String userId);
  Future<UserModel> connectUser(UserModel user);
  Future<Channel> createGroupChat(
    String channelId,
    String? name,
    List<String?>? members, {
    String? image,
  });
  Future<Channel> createSimpleChat(String? friendId);
  Future<void> logout();
}
