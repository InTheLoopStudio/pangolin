// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowActivity _$FollowActivityFromJson(Map<String, dynamic> json) =>
    FollowActivity(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      markedRead: json['markedRead'] as bool,
    );

Map<String, dynamic> _$FollowActivityToJson(FollowActivity instance) =>
    <String, dynamic>{
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
  ActivityType.loopMention: 'loopMention',
  ActivityType.commentMention: 'commentMention',
};

LikeActivity _$LikeActivityFromJson(Map<String, dynamic> json) => LikeActivity(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      markedRead: json['markedRead'] as bool,
      loopId: json['loopId'] as String?,
    );

Map<String, dynamic> _$LikeActivityToJson(LikeActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'markedRead': instance.markedRead,
      'loopId': instance.loopId,
    };

CommentActivity _$CommentActivityFromJson(Map<String, dynamic> json) =>
    CommentActivity(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      markedRead: json['markedRead'] as bool,
      rootId: json['rootId'] as String?,
      commentId: json['commentId'] as String?,
    );

Map<String, dynamic> _$CommentActivityToJson(CommentActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'markedRead': instance.markedRead,
      'rootId': instance.rootId,
      'commentId': instance.commentId,
    };

BookingRequestActivity _$BookingRequestActivityFromJson(
        Map<String, dynamic> json) =>
    BookingRequestActivity(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      markedRead: json['markedRead'] as bool,
      bookingId: json['bookingId'] as String?,
    );

Map<String, dynamic> _$BookingRequestActivityToJson(
        BookingRequestActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'markedRead': instance.markedRead,
      'bookingId': instance.bookingId,
    };

BookingUpdateActivity _$BookingUpdateActivityFromJson(
        Map<String, dynamic> json) =>
    BookingUpdateActivity(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      markedRead: json['markedRead'] as bool,
      bookingId: json['bookingId'] as String?,
      status: $enumDecodeNullable(_$BookingStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$BookingUpdateActivityToJson(
        BookingUpdateActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'markedRead': instance.markedRead,
      'bookingId': instance.bookingId,
      'status': _$BookingStatusEnumMap[instance.status],
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.canceled: 'canceled',
};

LoopMentionActivity _$LoopMentionActivityFromJson(Map<String, dynamic> json) =>
    LoopMentionActivity(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      markedRead: json['markedRead'] as bool,
      loopId: json['loopId'] as String?,
    );

Map<String, dynamic> _$LoopMentionActivityToJson(
        LoopMentionActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'markedRead': instance.markedRead,
      'loopId': instance.loopId,
    };

CommentMentionActivity _$CommentMentionActivityFromJson(
        Map<String, dynamic> json) =>
    CommentMentionActivity(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      markedRead: json['markedRead'] as bool,
      rootId: json['rootId'] as String?,
      commentId: json['commentId'] as String?,
    );

Map<String, dynamic> _$CommentMentionActivityToJson(
        CommentMentionActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'markedRead': instance.markedRead,
      'rootId': instance.rootId,
      'commentId': instance.commentId,
    };
