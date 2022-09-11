part of 'profile_cubit.dart';

enum ProfileStatus { initial, success, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.followerCount = 0,
    this.followingCount = 0,
    this.isFollowing = false,
    this.userLoops = const [],
    this.userBadges = const [],
    this.hasReachedMax = false,
    this.status = ProfileStatus.initial,
    required this.visitedUser,
    required this.currentUser,
  });

  final int followerCount;
  final int followingCount;
  final bool isFollowing;
  final List<Loop> userLoops;
  final List<Badge> userBadges;
  final bool hasReachedMax;
  final ProfileStatus status;
  final UserModel visitedUser;
  final UserModel currentUser;

  @override
  List<Object> get props => [
        followingCount,
        followerCount,
        isFollowing,
        userLoops,
        userBadges,
        hasReachedMax,
        status,
        visitedUser,
        currentUser
      ];

  ProfileState copyWith({
    int? followerCount,
    int? followingCount,
    bool? isFollowing,
    List<Loop>? userLoops,
    List<Badge>? userBadges,
    bool? hasReachedMax,
    ProfileStatus? status,
    UserModel? currentUser,
    UserModel? visitedUser,
  }) {
    return ProfileState(
      followingCount: followingCount ?? this.followingCount,
      followerCount: followerCount ?? this.followerCount,
      isFollowing: isFollowing ?? this.isFollowing,
      userLoops: userLoops ?? this.userLoops,
      userBadges: userBadges ?? this.userBadges,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
      currentUser: currentUser ?? this.currentUser,
      visitedUser: visitedUser ?? this.visitedUser,
    );
  }
}
