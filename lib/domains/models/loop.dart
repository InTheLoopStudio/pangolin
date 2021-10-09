import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'loop.g.dart';

@JsonSerializable()
class Loop extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String audio;
  final DateTime timestamp;
  final int likes;
  final int downloads;
  final int comments;
  final List<String> tags;
  final bool deleted;

  Loop({
    required this.id,
    required this.userId,
    required this.title,
    required this.audio,
    required this.timestamp,
    required this.likes,
    required this.downloads,
    required this.comments,
    required this.tags,
    required this.deleted,
  });

  @override
  List<Object> get props => [
        id,
        userId,
        title,
        audio,
        likes,
        downloads,
        comments,
        tags,
        deleted,
      ];

  static Loop get empty => Loop(
        id: '',
        userId: '',
        title: '',
        audio: '',
        timestamp: DateTime.now(),
        likes: 0,
        downloads: 0,
        comments: 0,
        tags: const [],
        deleted: false,
      );

  bool get isEmpty => this == Loop.empty;
  bool get isNotEmpty => this != Loop.empty;

  Loop copyWith({
    String? id,
    String? userId,
    String? title,
    String? audio,
    DateTime? timestamp,
    int? likes,
    int? downloads,
    int? comments,
    List<String>? tags,
    bool? deleted,
  }) {
    return Loop(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      audio: audio ?? this.audio,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      downloads: downloads ?? this.downloads,
      comments: comments ?? this.comments,
      tags: tags ?? this.tags,
      deleted: deleted ?? this.deleted,
    );
  }

  factory Loop.fromJson(Map<String, dynamic> json) => _$LoopFromJson(json);
  Map<String, dynamic> toJson() => _$LoopToJson(this);

  factory Loop.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Timestamp tmpTimestamp = doc.getOrElse('timestamp', Timestamp.now());

    return Loop(
      id: doc.id,
      userId: doc.getOrElse('userId', ''),
      title: doc.getOrElse('title', ''),
      audio: doc.getOrElse('audio', ''),
      timestamp: tmpTimestamp.toDate(),
      likes: doc.getOrElse('likes', 0),
      downloads: doc.getOrElse('downloads', 0),
      comments: doc.getOrElse('comments', 0),
      tags: List.from(
        doc.getOrElse('tags', []),
      ),
      deleted: doc.getOrElse('deleted', false),
    );
  }
}
