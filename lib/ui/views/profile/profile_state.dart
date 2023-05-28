part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  ProfileState({
    required this.currentUser,
    required this.visitedUser,
    this.isFollowing = false,
    this.isVerified = false,
    this.userLoops = const [],
    this.userBadges = const [],
    this.userBookings = const [],
    this.hasReachedMaxLoops = false,
    this.hasReachedMaxBadges = false,
    this.hasReachedMaxBookings = false,
    this.hasReachedMaxUserCreatedBadges = false,
    this.loopStatus = LoopsStatus.initial,
    this.badgeStatus = BadgesStatus.initial,
    this.bookingsStatus = BookingsStatus.initial,
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
  final bool isVerified;
  final List<Loop> userLoops;
  final List<Badge> userBadges;
  final List<Booking> userBookings;
  final bool hasReachedMaxLoops;
  final bool hasReachedMaxBadges;
  final bool hasReachedMaxBookings;
  final bool hasReachedMaxUserCreatedBadges;
  final LoopsStatus loopStatus;
  final BadgesStatus badgeStatus;
  final BookingsStatus bookingsStatus;
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
        userBookings,
        hasReachedMaxLoops,
        hasReachedMaxBadges,
        hasReachedMaxBookings,
        hasReachedMaxUserCreatedBadges,
        loopStatus,
        badgeStatus,
        bookingsStatus,
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
    List<Booking>? userBookings,
    bool? hasReachedMaxLoops,
    bool? hasReachedMaxBadges,
    bool? hasReachedMaxBookings,
    bool? hasReachedMaxUserCreatedBadges,
    LoopsStatus? loopStatus,
    BadgesStatus? badgeStatus,
    BookingsStatus? bookingsStatus,
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
      userBookings: userBookings ?? this.userBookings,
      hasReachedMaxLoops: hasReachedMaxLoops ?? this.hasReachedMaxLoops,
      hasReachedMaxBadges: hasReachedMaxBadges ?? this.hasReachedMaxBadges,
      hasReachedMaxBookings:
          hasReachedMaxBookings ?? this.hasReachedMaxBookings,
      hasReachedMaxUserCreatedBadges:
          hasReachedMaxUserCreatedBadges ?? this.hasReachedMaxUserCreatedBadges,
      loopStatus: loopStatus ?? this.loopStatus,
      badgeStatus: badgeStatus ?? this.badgeStatus,
      bookingsStatus: bookingsStatus ?? this.bookingsStatus,
      currentUser: currentUser ?? this.currentUser,
      visitedUser: visitedUser ?? this.visitedUser,
      place: place ?? this.place,
    );
  }
}

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

enum BookingsStatus {
  initial,
  success,
  failure,
}
