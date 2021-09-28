// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Loop _$LoopFromJson(Map<String, dynamic> json) => Loop(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      audio: json['audio'] as String? ?? '',
      timestamp: firestoreTimestampFromJson(json['timestamp']),
      likes: json['likes'] as int? ?? 0,
      downloads: json['downloads'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      deleted: json['deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$LoopToJson(Loop instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'audio': instance.audio,
      'timestamp': firestoreTimestampToJson(instance.timestamp),
      'likes': instance.likes,
      'downloads': instance.downloads,
      'comments': instance.comments,
      'tags': instance.tags,
      'deleted': instance.deleted,
    };
