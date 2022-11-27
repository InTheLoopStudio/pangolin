import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intheloopapp/utils.dart';

class Comment {
  Comment({
    this.id = '',
    required this.timestamp,
    required this.content,
    required this.userId,
    required this.rootId,
    this.parentId,
    this.children = const [],
    this.deleted = false,
  });

  factory Comment.empty() => Comment(
        timestamp: Timestamp.now(),
        content: '',
        userId: '',
        parentId: '',
        rootId: '',
      );

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
      parentId: doc.getOrElse('parentId', '') as String,
      rootId: doc.getOrElse('rootId', '') as String,
      children: List.from(
        doc.getOrElse('children', <dynamic>[]) as Iterable<dynamic>,
      ),
      deleted: doc.getOrElse('deleted', false) as bool,
    );
  }
  String id;
  Timestamp timestamp;
  String content;
  String userId;
  String? parentId;
  String rootId;
  List<String> children;
  bool deleted;

  // TODO(nit): Add `toMap()` function
}
