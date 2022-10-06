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

class ProfileState extends Equatable {
  const ProfileState({
    this.followerCount = 0,
    this.followingCount = 0,
    this.isFollowing = false,
    this.userLoops = const [],
    this.userBadges = const [],
    this.hasReachedMaxLoops = false,
    this.hasReachedMaxBadges = false,
    this.loopStatus = LoopsStatus.initial,
    this.badgeStatus = BadgesStatus.initial,
    required this.visitedUser,
    required this.currentUser,
  });

  final int followerCount;
  final int followingCount;
  final bool isFollowing;
  final List<Loop> userLoops;
  final List<Badge> userBadges;
  final bool hasReachedMaxLoops;
  final bool hasReachedMaxBadges;
  final LoopsStatus loopStatus;
  final BadgesStatus badgeStatus;
  final UserModel visitedUser;
  final UserModel currentUser;

  @override
  List<Object> get props => [
        followingCount,
        followerCount,
        isFollowing,
        userLoops,
        userBadges,
        hasReachedMaxLoops,
        hasReachedMaxBadges,
        loopStatus,
        badgeStatus,
        visitedUser,
        currentUser
      ];

  ProfileState copyWith({
    int? followerCount,
    int? followingCount,
    bool? isFollowing,
    List<Loop>? userLoops,
    List<Badge>? userBadges,
    bool? hasReachedMaxLoops,
    bool? hasReachedMaxBadges,
    LoopsStatus? loopStatus,
    BadgesStatus? badgeStatus,
    UserModel? currentUser,
    UserModel? visitedUser,
  }) {
    print('hasReachedMaxBadges: ${this.hasReachedMaxBadges}');
    print('badgeStatus: ${this.badgeStatus}');
    return ProfileState(
      followingCount: followingCount ?? this.followingCount,
      followerCount: followerCount ?? this.followerCount,
      isFollowing: isFollowing ?? this.isFollowing,
      userLoops: userLoops ?? this.userLoops,
      userBadges: userBadges ?? this.userBadges,
      hasReachedMaxLoops: hasReachedMaxLoops ?? this.hasReachedMaxLoops,
      hasReachedMaxBadges: hasReachedMaxBadges ?? this.hasReachedMaxBadges,
      loopStatus: loopStatus ?? this.loopStatus,
      badgeStatus: badgeStatus ?? this.badgeStatus,
      currentUser: currentUser ?? this.currentUser,
      visitedUser: visitedUser ?? this.visitedUser,
    );
  }
}
