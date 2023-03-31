// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      markedRead: json['markedRead'] as bool,
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'markedRead': instance.markedRead,
    };

const _$ActivityTypeEnumMap = {
  ActivityType.follow: 'follow',
  ActivityType.like: 'like',
  ActivityType.comment: 'comment',
  ActivityType.bookingRequest: 'bookingRequest',
  ActivityType.bookingUpdate: 'bookingUpdate',
};
