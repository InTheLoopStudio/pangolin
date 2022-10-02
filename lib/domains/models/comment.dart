import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intheloopapp/utils.dart';

class Comment {
  Comment({
    this.id = '',
    this.timestamp,
    this.content,
    this.userId,
    this.parentId,
    this.rootLoopId,
    this.children,
    this.deleted,
  });

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
      rootLoopId: doc.getOrElse('rootLoopId', '') as String,
      children:
          List.from(doc.getOrElse('children', <String>[]) as List<String>),
      deleted: doc.getOrElse('deleted', false) as bool,
    );
  }
  String id;
  Timestamp? timestamp;
  String? content;
  String? userId;
  String? parentId;
  String? rootLoopId;
  List<String>? children;
  bool? deleted;
}
