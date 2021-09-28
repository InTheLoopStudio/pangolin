import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

final _functions = FirebaseFunctions.instance;
final _fireStore = FirebaseFirestore.instance;

final usersRef = _fireStore.collection('users');

class StreamImpl extends StreamRepository {
  StreamImpl(this._client);

  final StreamChatClient _client;
  bool _connected = false;

  @override
  Future<UserModel> connectUser(UserModel user) async {
    final String token = await getToken(
      user.id,
    );

    Map<String, dynamic> extraData = {};
    if (user.profilePicture != null) {
      extraData['image'] = user.profilePicture;
    }
    if (user.username != null) {
      extraData['name'] = user.username;
    }

    if (!_connected) {
      await _client.connectUser(
        User(
          id: user.id,
          extraData: extraData,
        ),
        token,
        // user.streamChatToken,
      );
      _connected = true;
    }

    return user;
  }

  @override
  Future<List<UserModel>> getChatUsers() async {
    final result = await _client.queryUsers();
    final chatUsers = await Future.wait(result.users
        .where((element) => element.id != _client.state.currentUser!.id)
        .map(
      (User e) async {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await usersRef.doc(e.id).get();
        UserModel user = UserModel.fromDoc(userSnapshot);

        return user;
      },
    ));
    return chatUsers;
  }

  @override
  Future<String> getToken(
    String userId,
    // String streamChatToken,
  ) async {
    HttpsCallable callable = _functions.httpsCallable('createStreamChatToken');
    final results = await callable({
      'userId': userId,
    });

    return results.data;

    // In Development mode you can just use :
    // return _client.devToken(userId).rawValue;
  }

  @override
  Future<Channel> createGroupChat(
    String id,
    String? name,
    List<String?>? members, {
    String? image,
  }) async {
    Channel channel = _client.channel('messaging');

    final res = await _client.queryChannelsOnline(
      state: false,
      watch: false,
      filter: Filter.raw(value: {
        'members': [
          ...members!,
          _client.state.currentUser!.id,
        ],
        'distinct': true,
      }),
      messageLimit: 0,
      paginationParams: PaginationParams(
        limit: 1,
      ),
    );

    final _channelExisted = res.length == 1;
    if (_channelExisted) {
      channel = res.first;
      await channel.watch();
    } else {
      channel = _client.channel(
        'messaging',
        extraData: {
          'name': name!,
          'image': image!,
          'members': [
            ...members,
            _client.state.currentUser!.id,
          ],
        },
      );
      await channel.watch();
    }

    return channel;
  }

  @override
  Future<Channel> createSimpleChat(String? friendId) async {
    Channel channel = _client.channel('messaging');

    final res = await _client.queryChannelsOnline(
      state: false,
      watch: false,
      filter: Filter.raw(value: {
        'members': [
          // ..._selectedUsers.map((e) => e.id),
          friendId,
          _client.state.currentUser!.id,
        ],
        'distinct': true,
      }),
      messageLimit: 0,
      paginationParams: PaginationParams(
        limit: 1,
      ),
    );

    final _channelExisted = res.length == 1;
    if (_channelExisted) {
      channel = res.first;
      await channel.watch();
    } else {
      channel = _client.channel(
        'messaging',
        extraData: {
          'members': [
            // ..._selectedUsers.map((e) => e.id),
            friendId,
            _client.state.currentUser!.id,
          ],
        },
      );
      channel.watch();
    }

    return channel;
  }

  @override
  Future<void> logout() async {
    return _client.disconnectUser();
  }

  // @override
  // Future<bool> connectIfExist(String userId) async {
  //   final token = await getToken(userId);
  //   await _client.connectUser(
  //     User(id: userId),
  //     token ?? '',
  //   );
  //   return _client.state.currentUser!.id != userId;
  // }
}
