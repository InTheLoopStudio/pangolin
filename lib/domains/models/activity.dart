import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:intheloopapp/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

/// Deserialize Firebase Timestamp data type from Firestore
Timestamp firestoreTimestampFromJson(dynamic value) {
  return value != null ? Timestamp.fromMicrosecondsSinceEpoch(value) : value;
}

/// This method only stores the "timestamp" data type back in the Firestore
dynamic firestoreTimestampToJson(Timestamp? value) =>
    value != null ? value.microsecondsSinceEpoch : null;

@JsonSerializable()
class Activity {
  String id;
  String fromUserId;
  String toUserId;

  @JsonKey(
    fromJson: firestoreTimestampFromJson,
    toJson: firestoreTimestampToJson,
  )
  Timestamp timestamp;

  ActivityType type;
  bool markedRead;

  Activity({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.timestamp,
    required this.type,
    required this.markedRead,
  });

  // Activity empty = Activity(
  //   id: '',
  //   fromUserId: '',
  //   toUserId: '',
  //   timestamp: Timestamp.fromMicrosecondsSinceEpoch(0),
  //   type: ActivityType.like,
  //   markedRead: false,
  // );

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  factory Activity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Activity(
      id: doc.id,
      fromUserId: doc.getOrElse('fromUserId', ''),
      toUserId: doc.getOrElse('toUserId', ''),
      timestamp: doc['timestamp'],
      type: EnumToString.fromString(ActivityType.values, doc['type']) ??
          ActivityType.like,
      markedRead: doc.getOrElse('markedRead', false),
    );
  }
}

enum ActivityType {
  follow,
  like,
  comment,
}
