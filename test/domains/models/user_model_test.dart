import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/models/username.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_model_test.mocks.dart';

@GenerateMocks([DocumentSnapshot])
void main() {
  test('UserModel.empty() provides a UserModel with default fields', () {
    final emptyUser = UserModel.empty();
    expect(
      emptyUser,
      UserModel(
        id: '',
        email: '',
        username: Username.fromString('anonymous'),
        artistName: '',
        profilePicture: '',
        bio: '',
        placeId: '',
        geohash: '',
        lat: 0,
        lng: 0,
        loopsCount: 0,
        badgesCount: 0,
        deleted: false,
        shadowBanned: false,
        accountType: AccountType.free,
        youtubeChannelId: '',
        soundcloudHandle: '',
        tiktokHandle: '',
        instagramHandle: '',
        twitterHandle: '',
        pushNotificationsLikes: false,
        pushNotificationsComments: false,
        pushNotificationsFollows: false,
        pushNotificationsDirectMessages: false,
        pushNotificationsITLUpdates: false,
        emailNotificationsAppReleases: false,
        emailNotificationsITLUpdates: false,
        bookingRate: 0,
        stripeConnectedAccountId: '',
        stripeCustomerId: '', 
        genres: const [],
      ),
    );
  });

  test('empty UserModels should be verified using isEmpty and isNotEmpty', () {
    final emptyUser = UserModel(
      id: '',
      email: '',
      username: Username.fromString('anonymous'),
      artistName: '',
      profilePicture: '',
      bio: '',
      placeId: '',
      geohash: '',
      lat: 0,
      lng: 0,
      loopsCount: 0,
      badgesCount: 0,
      deleted: false,
      shadowBanned: false,
      accountType: AccountType.free,
      youtubeChannelId: '',
      soundcloudHandle: '',
      tiktokHandle: '',
      instagramHandle: '',
      twitterHandle: '',
      pushNotificationsLikes: false,
      pushNotificationsComments: false,
      pushNotificationsFollows: false,
      pushNotificationsDirectMessages: false,
      pushNotificationsITLUpdates: false,
      emailNotificationsAppReleases: false,
      emailNotificationsITLUpdates: false,
      bookingRate: 0,
      stripeConnectedAccountId: '',
      stripeCustomerId: '',
        genres: const [],
    );

    expect(emptyUser.isEmpty, true);
    expect(emptyUser.isNotEmpty, false);
  });

  test('non-empty UserModels shuold be verified using isEmpty and isNotEmpty',
      () {
    final emptyUser = UserModel(
      id: '1234',
      email: 'jane@example.com',
      username: Username.fromString('blah'),
      artistName: 'blah',
      profilePicture: '',
      bio: '',
      placeId: '',
      geohash: '',
      lat: 0,
      lng: 0,
      loopsCount: 0,
      badgesCount: 0,
      deleted: false,
      shadowBanned: false,
      accountType: AccountType.free,
      youtubeChannelId: '',
      soundcloudHandle: '',
      tiktokHandle: '',
      instagramHandle: '',
      twitterHandle: '',
      pushNotificationsLikes: false,
      pushNotificationsComments: false,
      pushNotificationsFollows: false,
      pushNotificationsDirectMessages: false,
      pushNotificationsITLUpdates: false,
      emailNotificationsAppReleases: false,
      emailNotificationsITLUpdates: false,
      bookingRate: 0,
      stripeConnectedAccountId: '',
      stripeCustomerId: '',
        genres: const [],
    );

    expect(emptyUser.isEmpty, false);
    expect(emptyUser.isNotEmpty, true);
  });

  test('UserModels should be able to convert to Maps', () {
    final userMap = UserModel.empty().toMap();
    expect(
      userMap,
      {
        'id': '',
        'email': '',
        'username': 'anonymous',
        'artistName': '',
        'profilePicture': '',
        'bio': '',
        'location': 'Global',
        'loopsCount': 0,
        'badgesCount': 0,
        'deleted': false,
        'shadowBanned': false,
        'accountType': 'free',
        'youtubeChannelId': '',
        'soundcloudHandle': '',
        'tiktokHandle': '',
        'instagramHandle': '',
        'twitterHandle': '',
        'pushNotificationsLikes': false,
        'pushNotificationsComments': false,
        'pushNotificationsFollows': false,
        'pushNotificationsDirectMessages': false,
        'pushNotificationsITLUpdates': false,
        'emailNotificationsAppReleases': false,
        'emailNotificationsITLUpdates': false,
        'bookingRate': 0,
        'stripeConnectedAccountId': '',
      },
    );
  });

  test('UserModels should be able to be created from DocumentSnapshots', () {
    final DocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot =
        MockDocumentSnapshot<Map<String, dynamic>>();

    when(mockDocumentSnapshot.data()).thenReturn(
      {
        'email': '',
        'username': 'anonymous',
        'artistName': '',
        'profilePicture': '',
        'bio': '',
        'location': 'Global',
        'loopsCount': 0,
        'badgesCount': 0,
        'deleted': false,
        'shadowBanned': false,
        'accountType': 'free',
        'youtubeChannelId': '',
        'soundcloudHandle': '',
        'tiktokHandle': '',
        'instagramHandle': '',
        'twitterHandle': '',
        'pushNotificationsLikes': false,
        'pushNotificationsComments': false,
        'pushNotificationsFollows': false,
        'pushNotificationsDirectMessages': false,
        'pushNotificationsITLUpdates': false,
        'emailNotificationsAppReleases': false,
        'emailNotificationsITLUpdates': false,
        'bookingRate': 0,
        'stripeConnectedAccountId': '',
      },
    );

    when(mockDocumentSnapshot.id).thenReturn('');

    final userModel = UserModel.fromDoc(mockDocumentSnapshot);
    expect(
      userModel,
      UserModel(
        id: '',
        email: '',
        username: Username.fromString('anonymous'),
        artistName: '',
        profilePicture: '',
        bio: '',
        placeId: '',
        geohash: '',
        lat: 0,
        lng: 0,
        loopsCount: 0,
        badgesCount: 0,
        deleted: false,
        accountType: AccountType.free,
        shadowBanned: false,
        youtubeChannelId: '',
        soundcloudHandle: '',
        tiktokHandle: '',
        instagramHandle: '',
        twitterHandle: '',
        pushNotificationsLikes: false,
        pushNotificationsComments: false,
        pushNotificationsFollows: false,
        pushNotificationsDirectMessages: false,
        pushNotificationsITLUpdates: false,
        emailNotificationsAppReleases: false,
        emailNotificationsITLUpdates: false,
        bookingRate: 0,
        stripeConnectedAccountId: '',
        stripeCustomerId: '',
        genres: const [],
      ),
    );
  });
}
