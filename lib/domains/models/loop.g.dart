// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Loop _$LoopFromJson(Map<String, dynamic> json) => Loop(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      audio: json['audio'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      likes: json['likes'] as int,
      downloads: json['downloads'] as int,
      comments: json['comments'] as int,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      deleted: json['deleted'] as bool,
    );

Map<String, dynamic> _$LoopToJson(Loop instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'audio': instance.audio,
      'timestamp': instance.timestamp.toIso8601String(),
      'likes': instance.likes,
      'downloads': instance.downloads,
      'comments': instance.comments,
      'tags': instance.tags,
      'deleted': instance.deleted,
    };
