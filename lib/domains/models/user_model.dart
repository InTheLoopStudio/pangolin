import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

enum AccountType {
  @JsonValue("vendor") Vendor,
  @JsonValue("free") Free,
}

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String username;
  final String profilePicture;
  final String bio;
  final String location;
  final bool onboarded;
  final int loopsCount;
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

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.profilePicture,
    required this.bio,
    required this.location,
    required this.onboarded,
    required this.loopsCount,
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

  List<Object> get props => [
        this.id,
        this.email,
        this.username,
        this.profilePicture,
        this.bio,
        this.location,
        this.onboarded,
        this.loopsCount,
        this.deleted,
        this.shadowBanned,
        this.accountType,
        this.youtubeChannelId,
        this.soundcloudHandle,
        this.tiktokHandle,
        this.instagramHandle,
        this.twitterHandle,
        this.pushNotificationsLikes,
        this.pushNotificationsComments,
        this.pushNotificationsFollows,
        this.pushNotificationsDirectMessages,
        this.pushNotificationsITLUpdates,
        this.emailNotificationsAppReleases,
        this.emailNotificationsITLUpdates,
      ];

  static UserModel get empty => UserModel(
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
        accountType: AccountType.Free,
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

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? profilePicture,
    String? bio,
    String? location,
    bool? onboarded,
    int? loopsCount,
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
    bool? emailNotificationsITLUpdates
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      onboarded: onboarded ?? this.onboarded,
      loopsCount: loopsCount ?? this.loopsCount,
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

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserModel(
      id: doc.id,
      email: doc.getOrElse('email', ''),
      username: doc.getOrElse('username', 'anonymous'),
      profilePicture: doc.getOrElse('profilePicture', ''),
      bio: doc.getOrElse('bio', ''),
      location: doc.getOrElse('location', 'Global'),
      onboarded: doc.getOrElse('onboarded', false),
      loopsCount: doc.getOrElse('loopsCount', 0),
      deleted: doc.getOrElse('deleted', false),
      shadowBanned: doc.getOrElse('shadowBanned', false),
      accountType: $enumDecode(_$AccountTypeEnumMap, doc.getOrElse('accountType', 'free')),
      youtubeChannelId: doc.getOrElse('youtubeChannelId', ""),
      soundcloudHandle: doc.getOrElse('soundcloudHandle', ""),
      tiktokHandle: doc.getOrElse('tiktokHandle', ""),
      instagramHandle: doc.getOrElse('instagramHandle', ""),
      twitterHandle: doc.getOrElse('twitterHandle', ""),
      pushNotificationsLikes: doc.getOrElse('pushNotificationsLikes', true),
      pushNotificationsComments: doc.getOrElse('pushNotificationsComments', true),
      pushNotificationsFollows: doc.getOrElse('pushNotificationsFollows', true),
      pushNotificationsDirectMessages: doc.getOrElse('pushNotificationsDirectMessages', true),
      pushNotificationsITLUpdates: doc.getOrElse('pushNotificationsITLUpdates', true),
      emailNotificationsAppReleases: doc.getOrElse('emailNotificationsAppReleases', true),
      emailNotificationsITLUpdates: doc.getOrElse('emailNotificationsITLUpdates', true),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'email': this.email,
      'username': this.username,
      'bio': this.bio,
      'profilePicture': this.profilePicture,
      'location': this.location,
      'onboarded': this.onboarded,
      'loopsCount': this.loopsCount,
      'deleted': this.deleted,
      'shadowBanned': this.shadowBanned,
      'accountType': _$AccountTypeEnumMap[this.accountType],
      'youtubeChannelId': this.youtubeChannelId,
      'soundcloudHandle': this.soundcloudHandle,
      'tiktokHandle': this.tiktokHandle,
      'instagramHandle': this.instagramHandle,
      'twitterHandle': this.twitterHandle,
      'pushNotificationsLikes': this.pushNotificationsLikes,
      'pushNotificationsComments': this.pushNotificationsComments,
      'pushNotificationsFollows': this.pushNotificationsFollows,
      'pushNotificationsDirectMessages': this.pushNotificationsDirectMessages,
      'pushNotificationsITLUpdates': this.pushNotificationsITLUpdates,
      'emailNotificationsAppReleases': this.emailNotificationsAppReleases,
      'emailNotificationsITLUpdates': this.emailNotificationsITLUpdates,
    };
  }
}
