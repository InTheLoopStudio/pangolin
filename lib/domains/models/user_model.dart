import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// The different account types for a user
enum AccountType {
  /// Venue users
  @JsonValue('venue')
  venue,

  /// Users with free accounts
  @JsonValue('free')
  free,
}

@JsonSerializable()
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.artistName,
    required this.profilePicture,
    required this.bio,
    required this.location,
    required this.onboarded,
    required this.loopsCount,
    required this.badgesCount,
    required this.deleted,
    required this.shadowBanned,
    required this.accountType,
    required this.youtubeChannelId,
    required this.soundcloudHandle,
    required this.tiktokHandle,
    required this.instagramHandle,
    required this.twitterHandle,
    required this.pushNotificationsLikes,
    required this.pushNotificationsComments,
    required this.pushNotificationsFollows,
    required this.pushNotificationsDirectMessages,
    required this.pushNotificationsITLUpdates,
    required this.emailNotificationsAppReleases,
    required this.emailNotificationsITLUpdates,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    late final AccountType accountType;
    try {
      accountType = $enumDecode(
        _$AccountTypeEnumMap,
        doc.getOrElse('accountType', 'free'),
      );
    } on Exception {
      accountType = AccountType.free;
    }

    return UserModel(
      id: doc.id,
      email: doc.getOrElse('email', '') as String,
      username: doc.getOrElse('username', 'anonymous') as String,
      artistName: doc.getOrElse('artistName', '') as String,
      profilePicture: doc.getOrElse('profilePicture', '') as String,
      bio: doc.getOrElse('bio', '') as String,
      location: doc.getOrElse('location', 'Global') as String,
      onboarded: doc.getOrElse('onboarded', false) as bool,
      loopsCount: doc.getOrElse('loopsCount', 0) as int,
      badgesCount: doc.getOrElse('badgesCount', 0) as int,
      deleted: doc.getOrElse('deleted', false) as bool,
      shadowBanned: doc.getOrElse('shadowBanned', false) as bool,
      accountType: accountType,
      youtubeChannelId: doc.getOrElse('youtubeChannelId', '') as String,
      soundcloudHandle: doc.getOrElse('soundcloudHandle', '') as String,
      tiktokHandle: doc.getOrElse('tiktokHandle', '') as String,
      instagramHandle: doc.getOrElse('instagramHandle', '') as String,
      twitterHandle: doc.getOrElse('twitterHandle', '') as String,
      pushNotificationsLikes:
          doc.getOrElse('pushNotificationsLikes', true) as bool,
      pushNotificationsComments:
          doc.getOrElse('pushNotificationsComments', true) as bool,
      pushNotificationsFollows:
          doc.getOrElse('pushNotificationsFollows', true) as bool,
      pushNotificationsDirectMessages:
          doc.getOrElse('pushNotificationsDirectMessages', true) as bool,
      pushNotificationsITLUpdates:
          doc.getOrElse('pushNotificationsITLUpdates', true) as bool,
      emailNotificationsAppReleases:
          doc.getOrElse('emailNotificationsAppReleases', true) as bool,
      emailNotificationsITLUpdates:
          doc.getOrElse('emailNotificationsITLUpdates', true) as bool,
    );
  }
  final String id;
  final String email;
  final String username;
  final String artistName;
  final String profilePicture;
  final String bio;
  final String location;
  final bool onboarded;
  final int loopsCount;
  final int badgesCount;
  final bool deleted;
  final bool shadowBanned;
  final AccountType accountType;

  final String youtubeChannelId;
  final String soundcloudHandle;
  final String tiktokHandle;
  final String instagramHandle;
  final String twitterHandle;

  final bool pushNotificationsLikes;
  final bool pushNotificationsComments;
  final bool pushNotificationsFollows;
  final bool pushNotificationsDirectMessages;
  final bool pushNotificationsITLUpdates;

  final bool emailNotificationsAppReleases;
  final bool emailNotificationsITLUpdates;

  @override
  List<Object> get props => [
        id,
        email,
        username,
        artistName,
        profilePicture,
        bio,
        location,
        onboarded,
        loopsCount,
        badgesCount,
        deleted,
        shadowBanned,
        accountType,
        youtubeChannelId,
        soundcloudHandle,
        tiktokHandle,
        instagramHandle,
        twitterHandle,
        pushNotificationsLikes,
        pushNotificationsComments,
        pushNotificationsFollows,
        pushNotificationsDirectMessages,
        pushNotificationsITLUpdates,
        emailNotificationsAppReleases,
        emailNotificationsITLUpdates,
      ];

  static UserModel get empty => const UserModel(
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
  bool get isEmpty => this == UserModel.empty;
  bool get isNotEmpty => this != UserModel.empty;
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? artistName,
    String? profilePicture,
    String? bio,
    String? location,
    bool? onboarded,
    int? loopsCount,
    int? badgesCount,
    bool? deleted,
    bool? shadowBanned,
    AccountType? accountType,
    String? youtubeChannelId,
    String? soundcloudHandle,
    String? tiktokHandle,
    String? instagramHandle,
    String? twitterHandle,
    bool? pushNotificationsLikes,
    bool? pushNotificationsComments,
    bool? pushNotificationsFollows,
    bool? pushNotificationsDirectMessages,
    bool? pushNotificationsITLUpdates,
    bool? emailNotificationsAppReleases,
    bool? emailNotificationsITLUpdates,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      artistName: artistName ?? this.artistName,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      onboarded: onboarded ?? this.onboarded,
      loopsCount: loopsCount ?? this.loopsCount,
      badgesCount: badgesCount ?? this.badgesCount,
      deleted: deleted ?? this.deleted,
      shadowBanned: shadowBanned ?? this.shadowBanned,
      accountType: accountType ?? this.accountType,
      youtubeChannelId: youtubeChannelId ?? this.youtubeChannelId,
      soundcloudHandle: soundcloudHandle ?? this.soundcloudHandle,
      tiktokHandle: tiktokHandle ?? this.tiktokHandle,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      twitterHandle: twitterHandle ?? this.twitterHandle,
      pushNotificationsLikes:
          pushNotificationsLikes ?? this.pushNotificationsLikes,
      pushNotificationsComments:
          pushNotificationsComments ?? this.pushNotificationsComments,
      pushNotificationsFollows:
          pushNotificationsFollows ?? this.pushNotificationsFollows,
      pushNotificationsDirectMessages: pushNotificationsDirectMessages ??
          this.pushNotificationsDirectMessages,
      pushNotificationsITLUpdates:
          pushNotificationsITLUpdates ?? this.pushNotificationsITLUpdates,
      emailNotificationsAppReleases:
          emailNotificationsAppReleases ?? this.emailNotificationsAppReleases,
      emailNotificationsITLUpdates:
          emailNotificationsITLUpdates ?? this.emailNotificationsITLUpdates,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'artistName': artistName,
      'bio': bio,
      'profilePicture': profilePicture,
      'location': location,
      'onboarded': onboarded,
      'loopsCount': loopsCount,
      'badgesCount': badgesCount,
      'deleted': deleted,
      'shadowBanned': shadowBanned,
      'accountType': _$AccountTypeEnumMap[accountType],
      'youtubeChannelId': youtubeChannelId,
      'soundcloudHandle': soundcloudHandle,
      'tiktokHandle': tiktokHandle,
      'instagramHandle': instagramHandle,
      'twitterHandle': twitterHandle,
      'pushNotificationsLikes': pushNotificationsLikes,
      'pushNotificationsComments': pushNotificationsComments,
      'pushNotificationsFollows': pushNotificationsFollows,
      'pushNotificationsDirectMessages': pushNotificationsDirectMessages,
      'pushNotificationsITLUpdates': pushNotificationsITLUpdates,
      'emailNotificationsAppReleases': emailNotificationsAppReleases,
      'emailNotificationsITLUpdates': emailNotificationsITLUpdates,
    };
  }
}
