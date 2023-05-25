// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Loop _$LoopFromJson(Map<String, dynamic> json) => Loop(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: const OptionalStringConverter().fromJson(json['title'] as String?),
      description: json['description'] as String,
      audioPath: const OptionalStringConverter()
          .fromJson(json['audioPath'] as String?),
      imagePaths: (json['imagePaths'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      likeCount: json['likeCount'] as int,
      commentCount: json['commentCount'] as int,
      shareCount: json['shareCount'] as int,
      isOpportunity: json['isOpportunity'] as bool,
      deleted: json['deleted'] as bool,
    );

Map<String, dynamic> _$LoopToJson(Loop instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': const OptionalStringConverter().toJson(instance.title),
      'description': instance.description,
      'audioPath': const OptionalStringConverter().toJson(instance.audioPath),
      'imagePaths': instance.imagePaths,
      'timestamp': instance.timestamp.toIso8601String(),
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'shareCount': instance.shareCount,
      'isOpportunity': instance.isOpportunity,
      'deleted': instance.deleted,
    };
