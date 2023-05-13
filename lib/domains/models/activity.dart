import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/app_logger.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

sealed class Activity extends Equatable {
  const Activity({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.type,
    required this.markedRead,
    required this.timestamp,
  });

  factory Activity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final rawType = doc.getOrElse('type', 'like') as String;
      final type = EnumToString.fromString(
        ActivityType.values,
        rawType,
      );

      switch (type) {
        case ActivityType.follow:
          return FollowActivity.fromDoc(doc);
        case ActivityType.like:
          return LikeActivity.fromDoc(doc);
        case ActivityType.comment:
          return CommentActivity.fromDoc(doc);
        case ActivityType.bookingRequest:
          return BookingRequestActivity.fromDoc(doc);
        case ActivityType.bookingUpdate:
          return BookingUpdateActivity.fromDoc(doc);
        case ActivityType.loopMention:
          return LoopMentionActivity.fromDoc(doc);
        case ActivityType.commentMention:
          return CommentMentionActivity.fromDoc(doc);
        default:
          throw Exception('Activity.fromDoc: unknown type: $rawType');
      }
    } catch (e, s) {
      logger.error('Activity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String id;
  final String fromUserId;
  final String toUserId;
  final DateTime timestamp;
  final ActivityType type;
  final bool markedRead;

  @override
  List<Object> get props => [
        id,
      ];

  Activity copyAsRead();
}

@JsonSerializable()
final class FollowActivity extends Activity {
  const FollowActivity({
    required super.id,
    required super.fromUserId,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
  });

  factory FollowActivity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return FollowActivity(
        id: doc.id,
        fromUserId: doc.getOrElse('fromUserId', '') as String,
        toUserId: doc.getOrElse('toUserId', '') as String,
        timestamp: tmpTimestamp.toDate(),
        type: EnumToString.fromString(
              ActivityType.values,
              doc.getOrElse('type', 'free') as String,
            ) ??
            ActivityType.like,
        markedRead: doc.getOrElse('markedRead', false) as bool,
      );
    } catch (e, s) {
      logger.error('FollowActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  factory FollowActivity.fromJson(Map<String, dynamic> json) =>
      _$FollowActivityFromJson(json);

  Map<String, dynamic> toJson() => _$FollowActivityToJson(this);

  @override
  FollowActivity copyAsRead() {
    return FollowActivity(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      timestamp: timestamp,
      type: type,
      markedRead: true,
    );
  }
}

@JsonSerializable()
final class LikeActivity extends Activity {
  const LikeActivity({
    required super.id,
    required super.fromUserId,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.loopId,
  });

  factory LikeActivity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return LikeActivity(
        id: doc.id,
        fromUserId: doc.getOrElse('fromUserId', '') as String,
        toUserId: doc.getOrElse('toUserId', '') as String,
        timestamp: tmpTimestamp.toDate(),
        type: EnumToString.fromString(
              ActivityType.values,
              doc.getOrElse('type', 'free') as String,
            ) ??
            ActivityType.like,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        loopId: doc.getOrElse('loopId', null) as String?,
      );
    } catch (e, s) {
      logger.error('LikeActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String? loopId;

  @override 
  LikeActivity copyAsRead() {
    return LikeActivity(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      timestamp: timestamp,
      type: type,
      markedRead: true,
      loopId: loopId,
    );
  }
}

@JsonSerializable()
final class CommentActivity extends Activity {
  const CommentActivity({
    required super.id,
    required super.fromUserId,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.rootId,
    required this.commentId,
  });

  factory CommentActivity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return CommentActivity(
        id: doc.id,
        fromUserId: doc.getOrElse('fromUserId', '') as String,
        toUserId: doc.getOrElse('toUserId', '') as String,
        timestamp: tmpTimestamp.toDate(),
        type: EnumToString.fromString(
              ActivityType.values,
              doc.getOrElse('type', 'free') as String,
            ) ??
            ActivityType.like,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        rootId: doc.getOrElse('rootId', null) as String?,
        commentId: doc.getOrElse('commentId', null) as String?,
      );
    } catch (e, s) {
      logger.error('CommentActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String? rootId;
  final String? commentId;

  @override
  CommentActivity copyAsRead() {
    return CommentActivity(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      timestamp: timestamp,
      type: type,
      markedRead: true,
      rootId: rootId,
      commentId: commentId,
    );
  }
}

@JsonSerializable()
final class BookingRequestActivity extends Activity {
  const BookingRequestActivity({
    required super.id,
    required super.fromUserId,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.bookingId,
  });

  factory BookingRequestActivity.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return BookingRequestActivity(
        id: doc.id,
        fromUserId: doc.getOrElse('fromUserId', '') as String,
        toUserId: doc.getOrElse('toUserId', '') as String,
        timestamp: tmpTimestamp.toDate(),
        type: EnumToString.fromString(
              ActivityType.values,
              doc.getOrElse('type', 'free') as String,
            ) ??
            ActivityType.like,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        bookingId: doc.getOrElse('bookingId', null) as String?,
      );
    } catch (e, s) {
      logger.error('BookingRequestActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String? bookingId;

  @override
  BookingRequestActivity copyAsRead() {
    return BookingRequestActivity(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      timestamp: timestamp,
      type: type,
      markedRead: true,
      bookingId: bookingId,
    );
  }
}

@JsonSerializable()
final class BookingUpdateActivity extends Activity {
  const BookingUpdateActivity({
    required super.id,
    required super.fromUserId,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.bookingId,
    required this.status,
  });

  factory BookingUpdateActivity.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return BookingUpdateActivity(
        id: doc.id,
        fromUserId: doc.getOrElse('fromUserId', '') as String,
        toUserId: doc.getOrElse('toUserId', '') as String,
        timestamp: tmpTimestamp.toDate(),
        type: EnumToString.fromString(
              ActivityType.values,
              doc.getOrElse('type', 'free') as String,
            ) ??
            ActivityType.like,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        bookingId: doc.getOrElse('bookingId', null) as String?,
        status: doc.getOrElse('status', null) as BookingStatus?,
      );
    } catch (e, s) {
      logger.error('BookingUpdateActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String? bookingId;
  final BookingStatus? status;

  @override
  BookingUpdateActivity copyAsRead() {
    return BookingUpdateActivity(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      timestamp: timestamp,
      type: type,
      markedRead: true,
      bookingId: bookingId,
      status: status,
    );
  }
}

@JsonSerializable()
final class LoopMentionActivity extends Activity {
  const LoopMentionActivity({
    required super.id,
    required super.fromUserId,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.loopId,
  });

  factory LoopMentionActivity.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return LoopMentionActivity(
        id: doc.id,
        fromUserId: doc.getOrElse('fromUserId', '') as String,
        toUserId: doc.getOrElse('toUserId', '') as String,
        timestamp: tmpTimestamp.toDate(),
        type: EnumToString.fromString(
              ActivityType.values,
              doc.getOrElse('type', 'free') as String,
            ) ??
            ActivityType.like,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        loopId: doc.getOrElse('rootId', null) as String?,
      );
    } catch (e, s) {
      logger.error('LoopMentionActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String? loopId;

  @override
  LoopMentionActivity copyAsRead() {
    return LoopMentionActivity(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      timestamp: timestamp,
      type: type,
      markedRead: true,
      loopId: loopId,
    );
  }
}

@JsonSerializable()
final class CommentMentionActivity extends Activity {
  const CommentMentionActivity({
    required super.id,
    required super.fromUserId,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.rootId,
    required this.commentId,
  });

  factory CommentMentionActivity.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return CommentMentionActivity(
        id: doc.id,
        fromUserId: doc.getOrElse('fromUserId', '') as String,
        toUserId: doc.getOrElse('toUserId', '') as String,
        timestamp: tmpTimestamp.toDate(),
        type: EnumToString.fromString(
              ActivityType.values,
              doc.getOrElse('type', 'free') as String,
            ) ??
            ActivityType.like,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        rootId: doc.getOrElse('rootId', null) as String?,
        commentId: doc.getOrElse('commentId', null) as String?,
      );
    } catch (e, s) {
      logger.error('CommentMentionActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String? rootId;
  final String? commentId;

  @override
  CommentMentionActivity copyAsRead() {
    return CommentMentionActivity(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      timestamp: timestamp,
      type: type,
      markedRead: true,
      rootId: rootId,
      commentId: commentId,
    );
  }
}

enum ActivityType {
  follow,
  like,
  comment,
  bookingRequest,
  bookingUpdate,
  loopMention,
  commentMention,
}
