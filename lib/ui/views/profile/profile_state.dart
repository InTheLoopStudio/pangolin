part of 'profile_cubit.dart';

enum LoopsStatus {
  initial,
  success,
  failure,
}

enum BadgesStatus {
  initial,
  success,
  failure,
}

enum UserCreatedBadgesStatus {
  initial,
  success,
  failure,
}

class ProfileState extends Equatable {
  const ProfileState({
    this.followerCount = 0,
    this.followingCount = 0,
    this.isFollowing = false,
    this.userLoops = const [],
    this.userBadges = const [],
    this.userCreatedBadges = const [],
    this.hasReachedMaxLoops = false,
    this.hasReachedMaxBadges = false,
    this.hasReachedMaxUserCreatedBadges = false,
    this.loopStatus = LoopsStatus.initial,
    this.badgeStatus = BadgesStatus.initial,
    this.userCreatedBadgeStatus = UserCreatedBadgesStatus.initial,
    required this.visitedUser,
    required this.currentUser,
  });

  final int followerCount;
  final int followingCount;
  final bool isFollowing;
  final List<Loop> userLoops;
  final List<Badge> userBadges;
  final List<Badge> userCreatedBadges;
  final bool hasReachedMaxLoops;
  final bool hasReachedMaxBadges;
  final bool hasReachedMaxUserCreatedBadges;
  final LoopsStatus loopStatus;
  final BadgesStatus badgeStatus;
  final UserCreatedBadgesStatus userCreatedBadgeStatus;
  final UserModel visitedUser;
  final UserModel currentUser;

  @override
  List<Object> get props => [
        followingCount,
        followerCount,
        isFollowing,
        userLoops,
        userBadges,
        userCreatedBadges,
        hasReachedMaxLoops,
        hasReachedMaxBadges,
        hasReachedMaxUserCreatedBadges,
        loopStatus,
        badgeStatus,
        userCreatedBadgeStatus,
        visitedUser,
        currentUser
      ];

  ProfileState copyWith({
    int? followerCount,
    int? followingCount,
    bool? isFollowing,
    List<Loop>? userLoops,
    List<Badge>? userBadges,
    List<Badge>? userCreatedBadges,
    bool? hasReachedMaxLoops,
    bool? hasReachedMaxBadges,
    bool? hasReachedMaxUserCreatedBadges,
    LoopsStatus? loopStatus,
    BadgesStatus? badgeStatus,
    UserCreatedBadgesStatus? userCreatedBadgeStatus,
    UserModel? currentUser,
    UserModel? visitedUser,
  }) {
    return ProfileState(
      followingCount: followingCount ?? this.followingCount,
      followerCount: followerCount ?? this.followerCount,
      isFollowing: isFollowing ?? this.isFollowing,
      userLoops: userLoops ?? this.userLoops,
      userBadges: userBadges ?? this.userBadges,
      userCreatedBadges: userCreatedBadges ?? this.userCreatedBadges,
      hasReachedMaxLoops: hasReachedMaxLoops ?? this.hasReachedMaxLoops,
      hasReachedMaxBadges: hasReachedMaxBadges ?? this.hasReachedMaxBadges,
      hasReachedMaxUserCreatedBadges:
          hasReachedMaxUserCreatedBadges ?? this.hasReachedMaxUserCreatedBadges,
      loopStatus: loopStatus ?? this.loopStatus,
      badgeStatus: badgeStatus ?? this.badgeStatus,
      userCreatedBadgeStatus:
          userCreatedBadgeStatus ?? this.userCreatedBadgeStatus,
      currentUser: currentUser ?? this.currentUser,
      visitedUser: visitedUser ?? this.visitedUser,
    );
  }
}
