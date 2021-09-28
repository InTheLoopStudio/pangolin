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
      youtubeChannelId: json['youtubeChannelId'] as String,
      soundcloudHandle: json['soundcloudHandle'] as String,
      tiktokHandle: json['tiktokHandle'] as String,
      instagramHandle: json['instagramHandle'] as String,
      twitterHandle: json['twitterHandle'] as String,
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
      'youtubeChannelId': instance.youtubeChannelId,
      'soundcloudHandle': instance.soundcloudHandle,
      'tiktokHandle': instance.tiktokHandle,
      'instagramHandle': instance.instagramHandle,
      'twitterHandle': instance.twitterHandle,
    };
