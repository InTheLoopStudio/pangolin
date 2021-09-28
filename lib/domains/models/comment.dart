import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intheloopapp/utils.dart';

class Comment {
  String id;
  Timestamp? timestamp;
  String? content;
  String? userId;
  String? parentId;
  String? rootLoopId;
  List<String>? children;
  bool? deleted;

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
    return Comment(
      id: doc.id,
      timestamp: doc['timestamp'],
      content: doc['content'],
      userId: doc['userId'],
      parentId: doc['parentId'],
      rootLoopId: doc['rootLoopId'],
      children: List.from(doc['children']),
      deleted: doc.getOrElse('deleted', false),
    );
  }
}
