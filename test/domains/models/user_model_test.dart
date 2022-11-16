import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
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
        username: 'anonymous',
        artistName: '',
        profilePicture: '',
        bio: '',
        location: 'Global',
        onboarded: false,
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
      ),
    );
  });

  test('empty UserModels should be verified using isEmpty and isNotEmpty', () {
    final emptyUser = UserModel(
      id: '',
      email: '',
      username: 'anonymous',
      artistName: '',
      profilePicture: '',
      bio: '',
      location: 'Global',
      onboarded: false,
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
    );

    expect(emptyUser.isEmpty, true);
    expect(emptyUser.isNotEmpty, false);
  });

  test('non-empty UserModels shuold be verified using isEmpty and isNotEmpty',
      () {
    final emptyUser = UserModel(
      id: '1234',
      email: 'jane@example.com',
      username: 'blah',
      artistName: 'blah',
      profilePicture: '',
      bio: '',
      location: 'Global',
      onboarded: false,
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
        'onboarded': false,
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
        'emailNotificationsITLUpdates': false
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
        'onboarded': false,
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
      },
    );

    when(mockDocumentSnapshot.id).thenReturn('');

    final userModel = UserModel.fromDoc(mockDocumentSnapshot);
    expect(
      userModel,
      UserModel(
        id: '',
        email: '',
        username: 'anonymous',
        artistName: '',
        profilePicture: '',
        bio: '',
        location: 'Global',
        onboarded: false,
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
      ),
    );
  });
}
