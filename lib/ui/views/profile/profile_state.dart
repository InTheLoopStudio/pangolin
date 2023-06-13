part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  ProfileState({
    required this.currentUser,
    required this.visitedUser,
    this.isFollowing = false,
    this.isBlocked = false,
    this.isVerified = false,
    this.latestLoop = const None(),
    this.latestOpportunity = const None(),
    this.latestBooking = const None(),
    this.userBadges = const [],
    this.hasReachedMaxBadges = false,
    this.badgeStatus = BadgesStatus.initial,
    this.isCollapsed = false,
    this.didAddFeedback = false,
    int? followerCount,
    int? followingCount,
    Place? place,
  }) {
    this.followerCount = followerCount ?? visitedUser.followerCount;
    this.followingCount = followingCount ?? visitedUser.followingCount;
    this.place = place ?? const Place();
  }

  late final int followerCount;
  late final int followingCount;
  final bool isFollowing;
  final bool isBlocked;
  final bool isVerified;
  final List<badge.Badge> userBadges;

  final Option<Loop> latestLoop;
  final Option<Loop> latestOpportunity;
  final Option<Booking> latestBooking;

  final bool hasReachedMaxBadges;
  final BadgesStatus badgeStatus;
  final UserModel visitedUser;
  final UserModel currentUser;
  late final Place place;

  final bool isCollapsed;
  final bool didAddFeedback;

  @override
  List<Object> get props => [
        followingCount,
        followerCount,
        isFollowing,
        isBlocked,
        isVerified,
        latestLoop,
        latestOpportunity,
        latestBooking,
        userBadges,
        hasReachedMaxBadges,
        badgeStatus,
        visitedUser,
        currentUser,
        place,
      ];

  ProfileState copyWith({
    int? followerCount,
    int? followingCount,
    bool? isFollowing,
    bool? isBlocked,
    bool? isVerified,
    Option<Loop>? latestLoop,
    Option<Loop>? latestOpportunity,
    Option<Booking>? latestBooking,
    List<badge.Badge>? userBadges,
    bool? hasReachedMaxBadges,
    BadgesStatus? badgeStatus,
    UserModel? currentUser,
    UserModel? visitedUser,
    Place? place,
    bool? isCollapsed,
    bool? didAddFeedback,
  }) {
    return ProfileState(
      followingCount: followingCount ?? this.followingCount,
      followerCount: followerCount ?? this.followerCount,
      isFollowing: isFollowing ?? this.isFollowing,
      isBlocked: isBlocked ?? this.isBlocked,
      isVerified: isVerified ?? this.isVerified,
      latestLoop: latestLoop ?? this.latestLoop,
      latestOpportunity: latestOpportunity ?? this.latestOpportunity,
      latestBooking: latestBooking ?? this.latestBooking,
      userBadges: userBadges ?? this.userBadges,
      hasReachedMaxBadges: hasReachedMaxBadges ?? this.hasReachedMaxBadges,
      badgeStatus: badgeStatus ?? this.badgeStatus,
      currentUser: currentUser ?? this.currentUser,
      visitedUser: visitedUser ?? this.visitedUser,
      place: place ?? this.place,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      didAddFeedback: didAddFeedback ?? this.didAddFeedback,
    );
  }
}

enum BadgesStatus {
  initial,
  success,
  failure,
}
