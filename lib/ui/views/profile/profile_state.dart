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
  ProfileState({
    required this.currentUser,
    required this.visitedUser,
    this.followerCount = 0,
    this.followingCount = 0,
    this.isFollowing = false,
    this.isVerified = false,
    this.userLoops = const [],
    this.userBadges = const [],
    this.userCreatedBadges = const [],
    this.hasReachedMaxLoops = false,
    this.hasReachedMaxBadges = false,
    this.hasReachedMaxPosts = false,
    this.hasReachedMaxUserCreatedBadges = false,
    this.loopStatus = LoopsStatus.initial,
    this.badgeStatus = BadgesStatus.initial,
    this.userCreatedBadgeStatus = UserCreatedBadgesStatus.initial,
    Place? place,
  }) {

    this.place = place ?? const Place();
  }

  final int followerCount;
  final int followingCount;
  final bool isFollowing;
  final bool isVerified;
  final List<Loop> userLoops;
  final List<Badge> userBadges;
  final List<Badge> userCreatedBadges;
  final bool hasReachedMaxLoops;
  final bool hasReachedMaxBadges;
  final bool hasReachedMaxPosts;
  final bool hasReachedMaxUserCreatedBadges;
  final LoopsStatus loopStatus;
  final BadgesStatus badgeStatus;
  final UserCreatedBadgesStatus userCreatedBadgeStatus;
  final UserModel visitedUser;
  final UserModel currentUser;
  late final Place place;

  @override
  List<Object> get props => [
        followingCount,
        followerCount,
        isFollowing,
        isVerified,
        userLoops,
        userBadges,
        userCreatedBadges,
        hasReachedMaxLoops,
        hasReachedMaxBadges,
        hasReachedMaxPosts,
        hasReachedMaxUserCreatedBadges,
        loopStatus,
        badgeStatus,
        userCreatedBadgeStatus,
        visitedUser,
        currentUser,
        place,
      ];

  ProfileState copyWith({
    int? followerCount,
    int? followingCount,
    bool? isFollowing,
    bool? isVerified,
    List<Loop>? userLoops,
    List<Badge>? userBadges,
    List<Badge>? userCreatedBadges,
    bool? hasReachedMaxLoops,
    bool? hasReachedMaxBadges,
    bool? hasReachedMaxPosts,
    bool? hasReachedMaxUserCreatedBadges,
    LoopsStatus? loopStatus,
    BadgesStatus? badgeStatus,
    UserCreatedBadgesStatus? userCreatedBadgeStatus,
    UserModel? currentUser,
    UserModel? visitedUser,
    Place? place,
  }) {
    return ProfileState(
      followingCount: followingCount ?? this.followingCount,
      followerCount: followerCount ?? this.followerCount,
      isFollowing: isFollowing ?? this.isFollowing,
      isVerified: isVerified ?? this.isVerified,
      userLoops: userLoops ?? this.userLoops,
      userBadges: userBadges ?? this.userBadges,
      userCreatedBadges: userCreatedBadges ?? this.userCreatedBadges,
      hasReachedMaxLoops: hasReachedMaxLoops ?? this.hasReachedMaxLoops,
      hasReachedMaxBadges: hasReachedMaxBadges ?? this.hasReachedMaxBadges,
      hasReachedMaxPosts: hasReachedMaxPosts ?? this.hasReachedMaxPosts,
      hasReachedMaxUserCreatedBadges:
          hasReachedMaxUserCreatedBadges ?? this.hasReachedMaxUserCreatedBadges,
      loopStatus: loopStatus ?? this.loopStatus,
      badgeStatus: badgeStatus ?? this.badgeStatus,
      userCreatedBadgeStatus:
          userCreatedBadgeStatus ?? this.userCreatedBadgeStatus,
      currentUser: currentUser ?? this.currentUser,
      visitedUser: visitedUser ?? this.visitedUser,
      place: place ?? this.place,
    );
  }
}
