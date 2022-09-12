import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'badge.g.dart';

@JsonSerializable()
class Badge extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String imageUrl;
  final DateTime timestamp;

  Badge({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.imageUrl,
    required this.timestamp,
  });

  List<Object> get props => [
        this.id,
        this.senderId,
        this.receiverId,
        this.imageUrl,
        this.timestamp,
      ];

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
  Map<String, dynamic> toJson() => _$BadgeToJson(this);

  Badge copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? imageUrl,
    DateTime? timestamp,
  }) {
    return Badge(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory Badge.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Timestamp tmpTimestamp = doc.getOrElse('timestamp', Timestamp.now());
    return Badge(
      id: doc.id,
      senderId: doc.getOrElse('senderId', ''),
      receiverId: doc.getOrElse('receiverId', ''),
      imageUrl: doc.getOrElse('imageUrl', ''),
      timestamp: tmpTimestamp.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'senderId': this.senderId,
      'receiverId': this.receiverId,
      'imageUrl': this.imageUrl,
      'timestamp': this.timestamp.toUtc(),
    };
  }
}
