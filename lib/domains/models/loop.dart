import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intheloopapp/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'loop.g.dart';

/// Deserialize Firebase Timestamp data type from Firestore
Timestamp firestoreTimestampFromJson(dynamic value) {
  return value != null ? Timestamp.fromMicrosecondsSinceEpoch(value) : value;
}

/// This method only stores the "timestamp" data type back in the Firestore
dynamic firestoreTimestampToJson(Timestamp? value) =>
    value != null ? value.microsecondsSinceEpoch : null;

@JsonSerializable()
class Loop {
  String id;
  String? userId;
  String? title;
  String? audio;

  @JsonKey(
    fromJson: firestoreTimestampFromJson,
    toJson: firestoreTimestampToJson,
  )
  Timestamp? timestamp;

  int? likes;
  int? downloads;
  int? comments;
  List<String>? tags;
  bool? deleted;

  Loop({
    this.id = '',
    this.userId = '',
    this.title = '',
    this.audio = '',
    this.timestamp,
    this.likes = 0,
    this.downloads = 0,
    this.comments = 0,
    this.tags = const [],
    this.deleted = false,
  });

  factory Loop.fromJson(Map<String, dynamic> json) => _$LoopFromJson(json);
  Map<String, dynamic> toJson() => _$LoopToJson(this);

  factory Loop.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Loop(
      id: doc.id,
      userId: doc['userId'] ?? '',
      title: doc['title'] ?? '',
      audio: doc['audio'] ?? '',
      timestamp: doc['timestamp'] ?? null,
      likes: doc['likes'] ?? 0,
      downloads: doc['downloads'] ?? 0,
      comments: doc.getOrElse('comments', 0),
      tags: List.from(
        doc.getOrElse('tags', []),
      ),
      deleted: doc.getOrElse('deleted', false),
    );
  }
}
