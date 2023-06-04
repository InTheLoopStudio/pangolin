import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/app_logger.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/utils.dart';

sealed class Activity extends Equatable {
  const Activity({
    required this.id,
    required this.toUserId,
    required this.type,
    required this.markedRead,
    required this.timestamp,
  });

  factory Activity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final rawType = doc.getOrElse('type', null) as String?;
      if (rawType == null) {
        throw Exception('Activity.fromDoc: type is null');
      }

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
        case ActivityType.commentLike:
          return CommentLike.fromDoc(doc);
        case ActivityType.opportunityInterest:
          return OpportunityInterest.fromDoc(doc);
        case ActivityType.bookingReminder:
          return BookingReminder.fromDoc(doc);
        case ActivityType.searchAppearance:
          return SearchAppearance.fromDoc(doc);
        case null:
          throw Exception('Activity.fromDoc: unknown type: $rawType');
      }
    } catch (e, s) {
      logger.error('Activity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String id;
  final String toUserId;
  final DateTime timestamp;
  final ActivityType type;
  final bool markedRead;

  @override
  List<Object> get props => [
        id,
        toUserId,
        timestamp,
        type,
        markedRead,
      ];

  Activity copyAsRead();
}

final class Follow extends Activity {
  const Follow({
    required super.id,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.fromUserId,
  });

  factory Follow.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return Follow(
        id: doc.id,
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: EnumToString.fromString(
              ActivityType.values,
              doc.getOrElse('type', 'free') as String,
            ) ??
            ActivityType.like,
        fromUserId: doc.get(
          'fromUserId',
        ) as String,
        markedRead: doc.getOrElse('markedRead', false) as bool,
      );
    } catch (e, s) {
      logger.error('FollowActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String fromUserId;

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
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.fromUserId,
    required this.loopId,
  });

  factory Like.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return Like(
        id: doc.id,
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: EnumToString.fromString(
              ActivityType.values,
              doc.getOrElse('type', 'free') as String,
            ) ??
            ActivityType.like,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        fromUserId: doc.get(
          'fromUserId',
        ) as String,
        loopId: doc.get(
          'loopId',
        ) as String,
      );
    } catch (e, s) {
      logger.error('LikeActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String loopId;
  final String fromUserId;

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
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.fromUserId,
    required this.rootId,
    required this.commentId,
  });

  factory CommentActivity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return CommentActivity(
        id: doc.id,
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: EnumToString.fromString(
              ActivityType.values,
              doc.getOrElse('type', 'free') as String,
            ) ??
            ActivityType.like,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        fromUserId: doc.get(
          'fromUserId',
        ) as String,
        rootId: doc.get(
          'rootId',
        ) as String,
        commentId: doc.get(
          'commentId',
        ) as String,
      );
    } catch (e, s) {
      logger.error('CommentActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String fromUserId;
  final String rootId;
  final String commentId;

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
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.fromUserId,
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
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: EnumToString.fromString(
              ActivityType.values,
              doc.getOrElse('type', 'free') as String,
            ) ??
            ActivityType.like,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        fromUserId: doc.getOrElse(
          'fromUserId',
          null,
        ) as String,
        bookingId: doc.getOrElse(
          'bookingId',
          null,
        ) as String,
      );
    } catch (e, s) {
      logger.error('BookingRequestActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String fromUserId;
  final String bookingId;

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
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.fromUserId,
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
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: EnumToString.fromString(
              ActivityType.values,
              doc.getOrElse('type', 'free') as String,
            ) ??
            ActivityType.like,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        fromUserId: doc.get(
          'fromUserId',
        ) as String,
        bookingId: doc.get(
          'bookingId',
        ) as String,
        status: EnumToString.fromString(
          BookingStatus.values,
          doc.get('status') as String,
        ),
      );
    } catch (e, s) {
      logger.error('BookingUpdateActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String fromUserId;
  final String bookingId;
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
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.fromUserId,
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
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: ActivityType.loopMention,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        fromUserId: doc.get(
          'fromUserId',
        ) as String,
        loopId: doc.get(
          'rootId',
        ) as String,
      );
    } catch (e, s) {
      logger.error('LoopMentionActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String fromUserId;
  final String loopId;

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
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.fromUserId,
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
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: ActivityType.commentMention,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        rootId: doc.get(
          'rootId',
        ) as String,
        fromUserId: doc.get(
          'fromUserId',
        ) as String,
        commentId: doc.get(
          'commentId',
        ) as String,
      );
    } catch (e, s) {
      logger.error('CommentMentionActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String fromUserId;
  final String rootId;
  final String commentId;

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
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.fromUserId,
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
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: ActivityType.commentLike,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        rootId: doc.get(
          'rootId',
        ) as String,
        fromUserId: doc.get(
          'fromUserId',
        ) as String,
        commentId: doc.get(
          'commentId',
        ) as String,
      );
    } catch (e, s) {
      logger.error('CommentActivity.fromDoc', error: e, stackTrace: s);
      rethrow;
    }
  }

  final String fromUserId;
  final String rootId;
  final String commentId;

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

final class OpportunityInterest extends Activity {
  const OpportunityInterest({
    required super.id,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.fromUserId,
    required this.loopId,
  });

  factory OpportunityInterest.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return OpportunityInterest(
        id: doc.id,
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: ActivityType.opportunityInterest,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        fromUserId: doc.get(
          'fromUserId',
        ) as String,
        loopId: doc.get(
          'loopId',
        ) as String,
      );
    } catch (e, s) {
      logger.error(
        'OpportunityInterestActivity.fromDoc',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  final String fromUserId;
  final String loopId;

  @override
  OpportunityInterest copyAsRead() {
    return OpportunityInterest(
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

final class BookingReminder extends Activity {
  const BookingReminder({
    required super.id,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.fromUserId,
    required this.bookingId,
  });

  factory BookingReminder.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return BookingReminder(
        id: doc.id,
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: ActivityType.bookingReminder,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        fromUserId: doc.get(
          'fromUserId',
        ) as String,
        bookingId: doc.get(
          'bookingId',
        ) as String,
      );
    } catch (e, s) {
      logger.error(
        'BookingReminder.fromDoc',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  final String fromUserId;
  final String bookingId;

  @override
  BookingReminder copyAsRead() {
    return BookingReminder(
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

final class SearchAppearance extends Activity {
  const SearchAppearance({
    required super.id,
    required super.toUserId,
    required super.timestamp,
    required super.type,
    required super.markedRead,
    required this.count,
  });

  factory SearchAppearance.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      final tmpTimestamp =
          doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
      return SearchAppearance(
        id: doc.id,
        toUserId: doc.get('toUserId') as String,
        timestamp: tmpTimestamp.toDate(),
        type: ActivityType.opportunityInterest,
        markedRead: doc.getOrElse('markedRead', false) as bool,
        count: doc.get('count') as int,
      );
    } catch (e, s) {
      logger.error(
        'SearchAppearanceNotification.fromDoc',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  final int count;

  @override
  SearchAppearance copyAsRead() {
    return SearchAppearance(
      id: id,
      toUserId: toUserId,
      timestamp: timestamp,
      type: type,
      markedRead: true,
      count: count,
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
  opportunityInterest,
  bookingReminder,
  searchAppearance,
}
