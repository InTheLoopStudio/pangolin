import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// [StreamRepository] is an interface defining what methods are
/// needed to get instant messaging or DMs to work
///
/// This work a little different with direct messaging because
/// in practice, it is using a separate service and DB
abstract class StreamRepository {
  /// Method to get all the users from the chat DM
  /// (excluding the current logged in user)
  Future<List<UserModel>> getChatUsers();

  /// Method to get the user's client-side token that
  /// they'll user to interact with the chat DM
  Future<String> getToken();

  // Future<bool> connectIfExist(String userId);

  /// Connects the [userId] with chat DB using their `token`
  Future<bool> connectUser(String userId);

  /// Creates a group chat in the chat DB between the given [members]
  Future<Channel> createGroupChat(
    String id,
    String? name,
    List<String?>? members, {
    String? image,
  });

  /// Creates a direct message chat between the current logged in user
  /// and [friendId]
  Future<Channel> createSimpleChat(String? friendId);

  /// Disconnects the user from the Chat DM
  Future<void> logout();
}
