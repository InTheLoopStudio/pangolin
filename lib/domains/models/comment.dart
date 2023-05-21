import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/utils.dart';
import 'package:uuid/uuid.dart';

class Comment {
  Comment({
    required this.content,
    required this.userId,
    required this.rootId,
    this.parentId = const Option.none(),
    this.children = const [],
    this.deleted = false,
    this.likeCount = 0,
    Timestamp? timestamp,
    String? id,
  }) {
    this.id = id ?? const Uuid().v4();
    this.timestamp = timestamp ?? Timestamp.now();
  }

  factory Comment.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final tmpTimestamp = doc.getOrElse(
      'timestamp',
      Timestamp.now(),
    ) as Timestamp;

    return Comment(
      id: doc.id,
      timestamp: tmpTimestamp,
      content: doc.getOrElse('content', '') as String,
      userId: doc.getOrElse('userId', '') as String,
      parentId: Option.fromNullable(doc.getOrElse('parentId', null) as String?),
      rootId: doc.getOrElse('rootId', '') as String,
      children: List.from(
        doc.getOrElse('children', <dynamic>[]) as Iterable<dynamic>,
      ),
      deleted: doc.getOrElse('deleted', false) as bool,
      likeCount: doc.getOrElse('likeCount', 0) as int,
    );
  }

  late final String id;
  late final Timestamp timestamp;
  final String content;
  final String userId;
  final Option<String> parentId;
  final String rootId;
  final List<String> children;
  final bool deleted;
  final int likeCount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'content': content,
      'userId': userId,
      'parentId': parentId,
      'rootId': rootId,
      'children': children,
      'deleted': deleted,
      'likeCount': likeCount,
    };
  }

  Comment copyWith({
    String? id,
    Timestamp? timestamp,
    String? content,
    String? userId,
    Option<String>? parentId,
    String? rootId,
    List<String>? children,
    bool? deleted,
    int? likeCount,
  }) {
    return Comment(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      parentId: parentId ?? this.parentId,
      rootId: rootId ?? this.rootId,
      children: children ?? this.children,
      deleted: deleted ?? this.deleted,
      likeCount: likeCount ?? this.likeCount,
    );
  }
}
