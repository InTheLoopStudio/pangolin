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

  Badge({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.imageUrl,
  });

  List<Object> get props => [
        this.id,
        this.senderId,
        this.receiverId,
        this.imageUrl,
      ];

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
  Map<String, dynamic> toJson() => _$BadgeToJson(this);

  Badge copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? imageUrl,
  }) {
    return Badge(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory Badge.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Badge(
      id: doc.id,
      senderId: doc.getOrElse('senderId', ''),
      receiverId: doc.getOrElse('receiverId', ''),
      imageUrl: doc.getOrElse('imageUrl', ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'senderId': this.senderId,
      'receiverId': this.receiverId,
      'imageUrl': this.imageUrl,
    };
  }
}
