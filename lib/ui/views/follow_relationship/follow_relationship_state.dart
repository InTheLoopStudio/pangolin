part of 'follow_relationship_cubit.dart';

@immutable
class FollowRelationshipState extends Equatable {
  const FollowRelationshipState({
    this.followers = const [],
    this.following = const [],
  });

  final List<UserModel> followers;
  final List<UserModel> following;

  @override
  List<Object> get props => [
        followers,
        following,
      ];

  FollowRelationshipState copyWith({
    List<UserModel>? followers,
    List<UserModel>? following,
  }) {
    return FollowRelationshipState(
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}
