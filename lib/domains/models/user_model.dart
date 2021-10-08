import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String username;
  final String profilePicture;
  final String bio;
  final String location;
  final bool onboarded;
  final int loopsCount;
  final bool deleted;
  final bool shadowBanned;
  final String youtubeChannelId;
  final String soundcloudHandle;
  final String tiktokHandle;
  final String instagramHandle;
  final String twitterHandle;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.profilePicture,
    required this.bio,
    required this.location,
    required this.onboarded,
    required this.loopsCount,
    required this.deleted,
    required this.shadowBanned,
    required this.youtubeChannelId,
    required this.soundcloudHandle,
    required this.tiktokHandle,
    required this.instagramHandle,
    required this.twitterHandle,
  });

  List<Object> get props => [
        this.id,
        this.email,
        this.username,
        this.profilePicture,
        this.bio,
        this.location,
        this.onboarded,
        this.loopsCount,
        this.deleted,
        this.shadowBanned,
        this.youtubeChannelId,
        this.soundcloudHandle,
        this.tiktokHandle,
        this.instagramHandle,
        this.twitterHandle,
      ];

  static UserModel get empty => UserModel(
        id: '',
        email: '',
        username: 'anonymous',
        profilePicture: '',
        bio: '',
        location: 'Global',
        onboarded: false,
        loopsCount: 0,
        deleted: false,
        shadowBanned: false,
        youtubeChannelId: '',
        soundcloudHandle: '',
        tiktokHandle: '',
        instagramHandle: '',
        twitterHandle: '',
      );
  bool get isEmpty => this == UserModel.empty;
  bool get isNotEmpty => this != UserModel.empty;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? profilePicture,
    String? bio,
    String? location,
    bool? onboarded,
    int? loopsCount,
    bool? deleted,
    bool? shadowBanned,
    String? youtubeChannelId,
    String? soundcloudHandle,
    String? tiktokHandle,
    String? instagramHandle,
    String? twitterHandle,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      onboarded: onboarded ?? this.onboarded,
      loopsCount: loopsCount ?? this.loopsCount,
      deleted: deleted ?? this.deleted,
      shadowBanned: shadowBanned ?? this.shadowBanned,
      youtubeChannelId: youtubeChannelId ?? this.youtubeChannelId,
      soundcloudHandle: soundcloudHandle ?? this.soundcloudHandle,
      tiktokHandle: tiktokHandle ?? this.tiktokHandle,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      twitterHandle: twitterHandle ?? this.twitterHandle,
    );
  }

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserModel(
      id: doc.id,
      email: doc.getOrElse('email', ''),
      username: doc.getOrElse('username', 'anonymous'),
      profilePicture: doc.getOrElse('profilePicture', ''),
      bio: doc.getOrElse('bio', ''),
      location: doc.getOrElse('location', 'Global'),
      onboarded: doc.getOrElse('onboarded', false),
      loopsCount: doc.getOrElse('loopsCount', 0),
      deleted: doc.getOrElse('deleted', false),
      shadowBanned: doc.getOrElse('shadowBanned', false),
      youtubeChannelId: doc.getOrElse('youtubeChannelId', ""),
      soundcloudHandle: doc.getOrElse('soundcloudHandle', ""),
      tiktokHandle: doc.getOrElse('tiktokHandle', ""),
      instagramHandle: doc.getOrElse('instagramHandle', ""),
      twitterHandle: doc.getOrElse('twitterHandle', ""),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'email': this.email,
      'username': this.username,
      'bio': this.bio,
      'profilePicture': this.profilePicture,
      'location': this.location,
      'onboarded': this.onboarded,
      'loopsCount': this.loopsCount,
      'deleted': this.deleted,
      'shadowBanned': this.shadowBanned,
      'youtubeChannelId': this.youtubeChannelId,
      'soundcloudHandle': this.soundcloudHandle,
      'tiktokHandle': this.tiktokHandle,
      'instagramHandle': this.instagramHandle,
      'twitterHandle': this.twitterHandle
    };
  }
}
