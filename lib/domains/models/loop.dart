import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'loop.g.dart';

@JsonSerializable()
class Loop extends Equatable {

  const Loop({
    required this.id,
    required this.userId,
    required this.title,
    required this.audio,
    required this.timestamp,
    required this.likes,
    required this.downloads,
    required this.comments,
    required this.shares,
    required this.tags,
    required this.deleted,
  });

  factory Loop.fromJson(Map<String, dynamic> json) => _$LoopFromJson(json);

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
      shares: doc.getOrElse('shares', 0),
      tags: List.from(
        doc.getOrElse('tags', []),
      ),
      deleted: doc.getOrElse('deleted', false),
    );
  }
  final String id;
  final String userId;
  final String title;
  final String audio;
  final DateTime timestamp;
  final int likes;
  final int downloads;
  final int comments;
  final int shares;
  final List<String> tags;
  final bool deleted;

  @override
  List<Object> get props => [
        id,
        userId,
        title,
        audio,
        likes,
        downloads,
        comments,
        shares,
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
        shares: 0,
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
    int? shares,
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
      shares: shares ?? this.shares,
      tags: tags ?? this.tags,
      deleted: deleted ?? this.deleted,
    );
  }
  Map<String, dynamic> toJson() => _$LoopToJson(this);
}
