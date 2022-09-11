// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      profilePicture: json['profilePicture'] as String,
      bio: json['bio'] as String,
      location: json['location'] as String,
      onboarded: json['onboarded'] as bool,
      loopsCount: json['loopsCount'] as int,
      deleted: json['deleted'] as bool,
      shadowBanned: json['shadowBanned'] as bool,
      accountType: $enumDecode(_$AccountTypeEnumMap, json['accountType']),
      youtubeChannelId: json['youtubeChannelId'] as String,
      soundcloudHandle: json['soundcloudHandle'] as String,
      tiktokHandle: json['tiktokHandle'] as String,
      instagramHandle: json['instagramHandle'] as String,
      twitterHandle: json['twitterHandle'] as String,
      pushNotificationsLikes: json['pushNotificationsLikes'] as bool,
      pushNotificationsComments: json['pushNotificationsComments'] as bool,
      pushNotificationsFollows: json['pushNotificationsFollows'] as bool,
      pushNotificationsDirectMessages:
          json['pushNotificationsDirectMessages'] as bool,
      pushNotificationsITLUpdates: json['pushNotificationsITLUpdates'] as bool,
      emailNotificationsAppReleases:
          json['emailNotificationsAppReleases'] as bool,
      emailNotificationsITLUpdates:
          json['emailNotificationsITLUpdates'] as bool,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'profilePicture': instance.profilePicture,
      'bio': instance.bio,
      'location': instance.location,
      'onboarded': instance.onboarded,
      'loopsCount': instance.loopsCount,
      'deleted': instance.deleted,
      'shadowBanned': instance.shadowBanned,
      'accountType': _$AccountTypeEnumMap[instance.accountType]!,
      'youtubeChannelId': instance.youtubeChannelId,
      'soundcloudHandle': instance.soundcloudHandle,
      'tiktokHandle': instance.tiktokHandle,
      'instagramHandle': instance.instagramHandle,
      'twitterHandle': instance.twitterHandle,
      'pushNotificationsLikes': instance.pushNotificationsLikes,
      'pushNotificationsComments': instance.pushNotificationsComments,
      'pushNotificationsFollows': instance.pushNotificationsFollows,
      'pushNotificationsDirectMessages':
          instance.pushNotificationsDirectMessages,
      'pushNotificationsITLUpdates': instance.pushNotificationsITLUpdates,
      'emailNotificationsAppReleases': instance.emailNotificationsAppReleases,
      'emailNotificationsITLUpdates': instance.emailNotificationsITLUpdates,
    };

const _$AccountTypeEnumMap = {
  AccountType.Vendor: 'vendor',
  AccountType.Free: 'free',
};
