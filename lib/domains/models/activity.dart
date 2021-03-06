import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

@JsonSerializable()
class Activity extends Equatable {
  final String id;
  final String fromUserId;
  final String toUserId;
  final DateTime timestamp;
  final ActivityType type;
  final bool markedRead;

  Activity({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.timestamp,
    required this.type,
    required this.markedRead,
  });

  @override
  List<Object> get props => [
        id,
        fromUserId,
        toUserId,
        type,
        markedRead,
      ];

  static Activity get empty => Activity(
        id: '',
        fromUserId: '',
        toUserId: '',
        timestamp: DateTime.now(),
        type: ActivityType.like,
        markedRead: false,
      );

  bool get isEmpty => this == Activity.empty;
  bool get isNotEmpty => this != Activity.empty;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  Activity copyWith({
    String? id,
    String? fromUserId,
    String? toUserId,
    DateTime? timestamp,
    ActivityType? type,
    bool? markedRead,
  }) {
    return Activity(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      markedRead: markedRead ?? this.markedRead,
    );
  }

  factory Activity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Timestamp tmpTimestamp = doc.getOrElse('timestamp', Timestamp.now());
    return Activity(
      id: doc.id,
      fromUserId: doc.getOrElse('fromUserId', ''),
      toUserId: doc.getOrElse('toUserId', ''),
      timestamp: tmpTimestamp.toDate(),
      type: EnumToString.fromString(ActivityType.values, doc['type']) ??
          ActivityType.like,
      markedRead: doc.getOrElse('markedRead', true),
    );
  }
}

enum ActivityType {
  follow,
  like,
  comment,
}
