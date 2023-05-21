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
          return Follow.fromDoc(doc);
        case ActivityType.like:
          return Like.fromDoc(doc);
        case ActivityType.comment:
          return CommentActivity.fromDoc(doc);
        case ActivityType.bookingRequest:
          return BookingRequest.fromDoc(doc);
        case ActivityType.bookingUpdate:
          return BookingUpdate.fromDoc(doc);
        case ActivityType.loopMention:
          return LoopMention.fromDoc(doc);
        case ActivityType.commentMention:
          return CommentMention.fromDoc(doc);
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

final class Follow extends Activity {
  const Follow({
    required super.id,
    required super.fromUserId,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
  });

  factory Follow.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return Follow(
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

  @override
  Follow copyAsRead() {
    return Follow(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      timestamp: timestamp,
      type: type,
      markedRead: true,
    );
  }
}

final class Like extends Activity {
  const Like({
    required super.id,
    required super.fromUserId,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.loopId,
  });

  factory Like.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return Like(
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
  Like copyAsRead() {
    return Like(
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

final class BookingRequest extends Activity {
  const BookingRequest({
    required super.id,
    required super.fromUserId,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.bookingId,
  });

  factory BookingRequest.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return BookingRequest(
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
  BookingRequest copyAsRead() {
    return BookingRequest(
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

final class BookingUpdate extends Activity {
  const BookingUpdate({
    required super.id,
    required super.fromUserId,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.bookingId,
    required this.status,
  });

  factory BookingUpdate.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return BookingUpdate(
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
        status: EnumToString.fromString(
          BookingStatus.values,
          doc.getOrElse('status', null) as String,
        ),
      );
    } catch (e, s) {
      logger.error('BookingUpdateActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String? bookingId;
  final BookingStatus? status;

  @override
  BookingUpdate copyAsRead() {
    return BookingUpdate(
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

final class LoopMention extends Activity {
  const LoopMention({
    required super.id,
    required super.fromUserId,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.loopId,
  });

  factory LoopMention.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return LoopMention(
        id: doc.id,
        fromUserId: doc.getOrElse('fromUserId', '') as String,
        toUserId: doc.getOrElse('toUserId', '') as String,
        timestamp: tmpTimestamp.toDate(),
        type: ActivityType.loopMention,
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
  LoopMention copyAsRead() {
    return LoopMention(
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

final class CommentMention extends Activity {
  const CommentMention({
    required super.id,
    required super.fromUserId,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.rootId,
    required this.commentId,
  });

  factory CommentMention.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return CommentMention(
        id: doc.id,
        fromUserId: doc.getOrElse('fromUserId', '') as String,
        toUserId: doc.getOrElse('toUserId', '') as String,
        timestamp: tmpTimestamp.toDate(),
        type: ActivityType.commentMention,
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
  CommentMention copyAsRead() {
    return CommentMention(
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

final class CommentLike extends Activity {
  const CommentLike({
    required super.id,
    required super.fromUserId,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.rootId,
    required this.commentId,
  });

  factory CommentLike.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return CommentLike(
        id: doc.id,
        fromUserId: doc.getOrElse('fromUserId', '') as String,
        toUserId: doc.getOrElse('toUserId', '') as String,
        timestamp: tmpTimestamp.toDate(),
        type: ActivityType.commentLike,
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
  CommentLike copyAsRead() {
    return CommentLike(
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
  commentLike,
}
