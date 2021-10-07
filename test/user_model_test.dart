import 'package:flutter_test/flutter_test.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

void main() {
  test('UserModel.empty provides a UserModel with default fields', () {
    final emptyUser = UserModel.empty;
    expect(
      emptyUser,
      UserModel(
        id: '',
        email: '',
        username: 'anonymous',
        profilePicture: '',
        bio: '',
        location: 'Global',
        onboarded: false,
        loopsCount: 0,
        deleted: false,
        shadowBanned: false,
        youtubeChannelId: '',
        soundcloudHandle: '',
        tiktokHandle: '',
        instagramHandle: '',
        twitterHandle: '',
      ),
    );
  });

  test('empty UserModels should be verified using isEmpty and isNotEmpty', () {
    final emptyUser = UserModel(
      id: '',
      email: '',
      username: 'anonymous',
      profilePicture: '',
      bio: '',
      location: 'Global',
      onboarded: false,
      loopsCount: 0,
      deleted: false,
      shadowBanned: false,
      youtubeChannelId: '',
      soundcloudHandle: '',
      tiktokHandle: '',
      instagramHandle: '',
      twitterHandle: '',
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
      profilePicture: '',
      bio: '',
      location: 'Global',
      onboarded: false,
      loopsCount: 0,
      deleted: false,
      shadowBanned: false,
      youtubeChannelId: '',
      soundcloudHandle: '',
      tiktokHandle: '',
      instagramHandle: '',
      twitterHandle: '',
    );

    expect(emptyUser.isEmpty, false);
    expect(emptyUser.isNotEmpty, true);
  });

  test('UserModels should be able to convert to Maps', () {
    final userMap = UserModel.empty.toMap();
    expect(
      userMap,
      {
        'id': '',
        'email': '',
        'username': 'anonymous',
        'profilePicture': '',
        'bio': '',
        'location': 'Global',
        'onboarded': false,
        'loopsCount': 0,
        'deleted': false,
        'shadowBanned': false,
        'youtubeChannelId': '',
        'soundcloudHandle': '',
        'tiktokHandle': '',
        'instagramHandle': '',
        'twitterHandle': '',
      },
    );
  });
}
