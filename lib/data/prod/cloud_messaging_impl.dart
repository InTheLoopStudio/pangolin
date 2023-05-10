import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intheloopapp/app_logger.dart';
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
    try {
      logger.debug('saving device token for user: $userId');
      final settings = await fcm.requestPermission();

      logger.debug('User granted permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final token = await fcm.getToken();

        logger.debug('Device Token: ${token ?? ''}');

        if (token != null) {
          // final devices = await _client.getDevices();
          // logger.debug('devices ${devices.devices.map((e) => e.id)}');

          try {
            await tokensRef.doc(userId).collection('tokens').doc(token).set({
              'token': token,
              'platform': Platform.operatingSystem,
            });

            await _client.addDevice(
              token,
              PushProvider.firebase,
              pushProviderName: 'tapped_firebase',
            );
          } catch (e, s) {
            logger.error(
              'Saving device token failed',
              error: e,
              stackTrace: s,
            );
          }
        }
      }
    } catch (e, s) {
      logger.error(
        'Saving device token failed',
        error: e,
        stackTrace: s,
      );
    }
  }
}
