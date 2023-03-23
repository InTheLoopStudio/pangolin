// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: Username.fromJson(json['username'] as Map<String, dynamic>),
      artistName: json['artistName'] as String,
      profilePicture: json['profilePicture'] as String,
      bio: json['bio'] as String,
      placeId: json['placeId'] as String,
      geohash: json['geohash'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      loopsCount: json['loopsCount'] as int,
      badgesCount: json['badgesCount'] as int,
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
      bookingRate: json['bookingRate'] as int,
      stripeConnectedAccountId: json['stripeConnectedAccountId'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'artistName': instance.artistName,
      'profilePicture': instance.profilePicture,
      'bio': instance.bio,
      'placeId': instance.placeId,
      'geohash': instance.geohash,
      'lat': instance.lat,
      'lng': instance.lng,
      'loopsCount': instance.loopsCount,
      'badgesCount': instance.badgesCount,
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
      'bookingRate': instance.bookingRate,
      'stripeConnectedAccountId': instance.stripeConnectedAccountId,
    };

const _$AccountTypeEnumMap = {
  AccountType.venue: 'venue',
  AccountType.free: 'free',
};
