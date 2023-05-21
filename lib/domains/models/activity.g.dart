// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Follow _$FollowFromJson(Map<String, dynamic> json) => Follow(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      markedRead: json['markedRead'] as bool,
    );

Map<String, dynamic> _$FollowToJson(Follow instance) => <String, dynamic>{
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
  ActivityType.commentLike: 'commentLike',
};

Like _$LikeFromJson(Map<String, dynamic> json) => Like(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      markedRead: json['markedRead'] as bool,
      loopId: json['loopId'] as String?,
    );

Map<String, dynamic> _$LikeToJson(Like instance) => <String, dynamic>{
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

BookingRequest _$BookingRequestFromJson(Map<String, dynamic> json) =>
    BookingRequest(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      markedRead: json['markedRead'] as bool,
      bookingId: json['bookingId'] as String?,
    );

Map<String, dynamic> _$BookingRequestToJson(BookingRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'markedRead': instance.markedRead,
      'bookingId': instance.bookingId,
    };

BookingUpdate _$BookingUpdateFromJson(Map<String, dynamic> json) =>
    BookingUpdate(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      markedRead: json['markedRead'] as bool,
      bookingId: json['bookingId'] as String?,
      status: $enumDecodeNullable(_$BookingStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$BookingUpdateToJson(BookingUpdate instance) =>
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

LoopMention _$LoopMentionFromJson(Map<String, dynamic> json) => LoopMention(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      markedRead: json['markedRead'] as bool,
      loopId: json['loopId'] as String?,
    );

Map<String, dynamic> _$LoopMentionToJson(LoopMention instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'markedRead': instance.markedRead,
      'loopId': instance.loopId,
    };

CommentMention _$CommentMentionFromJson(Map<String, dynamic> json) =>
    CommentMention(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      markedRead: json['markedRead'] as bool,
      rootId: json['rootId'] as String?,
      commentId: json['commentId'] as String?,
    );

Map<String, dynamic> _$CommentMentionToJson(CommentMention instance) =>
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

CommentLike _$CommentLikeFromJson(Map<String, dynamic> json) => CommentLike(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      markedRead: json['markedRead'] as bool,
      rootId: json['rootId'] as String?,
      commentId: json['commentId'] as String?,
    );

Map<String, dynamic> _$CommentLikeToJson(CommentLike instance) =>
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
