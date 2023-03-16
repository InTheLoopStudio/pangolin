import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intheloopapp/data/notification_repository.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

final fcm = FirebaseMessaging.instance;
final _fireStore = FirebaseFirestore.instance;
final tokensRef = _fireStore.collection('device_tokens');

class CloudMessagingImpl extends NotificationRepository {
  CloudMessagingImpl(this._client);

  final StreamChatClient _client;

  @override
  Future<void> saveDeviceToken({required String userId}) async {
    final settings = await fcm.requestPermission();

    // print('User granted permission: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await fcm.getToken();

      // print('Device Token: ' + (token ?? ''));

      if (token != null) {
        try {
          if (Platform.isIOS) {
            // register the device with APN (Apple only)
            await _client.addDevice(token, PushProvider.apn);
          } else if (Platform.isAndroid) {
            // register the device with Firebase (Android only)
            await _client.addDevice(token, PushProvider.firebase);
          }

          await tokensRef.doc(userId).collection('tokens').doc(token).set({
            'token': token,
            'platform': Platform.operatingSystem,
          });
        } on Exception {
          // print('Saving device token failed');
        }
      }
    }
  }
}
