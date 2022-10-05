import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'badge.g.dart';

@JsonSerializable()
class Badge extends Equatable {
  const Badge({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.timestamp,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);

  factory Badge.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final tmpTimestamp =
        doc.getOrElse('timestamp', Timestamp.now()) as Timestamp;
    return Badge(
      id: doc.id,
      senderId: doc.getOrElse('senderId', '') as String,
      receiverId: doc.getOrElse('receiverId', '') as String,
      imageUrl: doc.getOrElse('imageUrl', '') as String,
      name: doc.getOrElse('name', '') as String,
      description: doc.getOrElse('description', '') as String,
      timestamp: tmpTimestamp.toDate(),
    );
  }
  final String id;
  final String senderId;
  final String receiverId;
  final String imageUrl;
  final String name;
  final String description;
  final DateTime timestamp;

  @override
  List<Object> get props => [
        id,
        senderId,
        receiverId,
        imageUrl,
        name,
        description,
        timestamp,
      ];
  Map<String, dynamic> toJson() => _$BadgeToJson(this);

  Badge copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? imageUrl,
    String? name,
    String? description,
    DateTime? timestamp,
  }) {
    return Badge(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'imageUrl': imageUrl,
      'name': name,
      'description': description,
      'timestamp': timestamp.toIso8601String()
    };
  }
}
