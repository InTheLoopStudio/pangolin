import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/comment.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/review.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

class LocalDatabaseImpl extends DatabaseRepository {
  @override
  Future<bool> userEmailExists(String email) async {
    return true;
  }

  @override
  Future<UserModel> getUserByUsername(String? username) async {
    return UserModel.empty();
  }

  @override
  Future<void> createUser(UserModel user) async {
    return;
  }

  @override
  Future<UserModel> getUserById(
    String userId, {
    bool ignoreCache = false,
  }) async {
    return UserModel.empty();
  }

  @override
  Future<Loop> getLoopById(
    String loopId, {
    bool ignoreCache = false,
  }) async {
    return Loop.empty();
  }

  @override
  Future<int> followersNum(String userid) async {
    return 42;
  }

  @override
  Future<int> followingNum(String userid) async {
    return 42;
  }

  @override
  Future<void> updateUserData(UserModel user) async {
    return;
  }

  @override
  Future<void> followUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    return;
  }

  @override
  Future<void> unfollowUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    return;
  }

  @override
  Future<bool> isFollowingUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    return false;
  }

  @override
  Future<List<UserModel>> getFollowing(String currentUserId) async {
    return [];
  }

  @override
  Future<List<UserModel>> getFollowers(String currentUserId) async {
    return [];
  }

  @override
  Future<void> addLoop(Loop loop) async {
    return;
  }

  @override
  Future<void> deleteLoop(Loop loop) async {
    return;
  }

  @override
  Future<List<Loop>> getUserLoops(
    String userId, {
    int limit = 0,
    String? lastLoopId,
  }) async {
    return [];
  }

  @override
  Stream<Loop> userLoopsObserver(String userId, {int limit = 20}) async* {}

  @override
  Future<List<Loop>> getFollowingLoops(
    String currentUserId, {
    int limit = 0,
    String? lastLoopId,
    bool ignoreCache = false,
  }) async {
    return [];
  }

  @override
  Stream<Loop> followingLoopsObserver(
    String currentUserId, {
    int limit = 20,
    bool ignoreCache = false,
  }) async* {}

  @override
  Future<List<Loop>> getAllLoops(
    String currentUserId, {
    int limit = 0,
    String? lastLoopId,
    bool ignoreCache = false,
  }) async {
    return [];
  }

  @override
  Stream<Loop> allLoopsObserver(
    String currentUserId, {
    int limit = 20,
    bool ignoreCache = false,
  }) async* {}

  @override
  Future<void> addLike(
    String currentUserId,
    String loopId,
  ) async {
    return;
  }

  @override
  Future<void> deleteLike(
    String currentUserId,
    String loopId,
  ) async {
    return;
  }

  @override
  Future<bool> isLiked(
    String currentUserId,
    String loopId,
  ) async {
    return false;
  }

  @override
  Future<List<UserModel>> getLikes(
    String loopId,
  ) async {
    return [];
  }

  @override
  Future<List<Activity>> getActivities(
    String userId, {
    int limit = 0,
    String? lastActivityId,
  }) async {
    return [];
  }

  @override
  Stream<Activity> activitiesObserver(
    String userId, {
    int limit = 20,
  }) async* {}

  @override
  Future<void> addActivity({
    required String currentUserId,
    required ActivityType type,
    Loop? loop,
    String? visitedUserId,
  }) async {
    return;
  }

  @override
  Future<void> markActivityAsRead(Activity activity) async {
    return;
  }

  @override
  Future<List<Comment>> getComments(
    String rootId, {
    int limit = 20,
  }) async {
    return [];
  }

  @override
  Stream<Comment> commentsObserver(
    String rootId, {
    int limit = 20,
  }) async* {}

  @override
  Future<Comment> getComment(
    String rootId,
    String commentId,
  ) async {
    return Comment.empty();
  }

  @override
  Future<void> addComment(
    Comment comment,
  ) async {
    return;
  }

  // Future<List<Tag>> getTagSuggestions(String query) async {
  //   await Future<void>.delayed(Duration(seconds: 2));
  //   return [];
  // }

  @override
  Future<void> shareLoop(Loop loop) async {
    return;
  }

  @override
  Future<bool> checkUsernameAvailability(String username, String userid) async {
    return true;
  }

  @override
  Future<bool> isVerified(String userId) async {
    return false;
  }

  @override
  Future<void> createBadge(Badge badge) async {
    return;
  }

  @override
  Future<void> sendBadge(String badgeId, String receiverId) async {
    return;
  }

  @override
  Stream<Badge> userBadgesObserver(String userId, {int limit = 20}) async* {}

  @override
  Stream<Badge> userCreatedBadgesObserver(
    String userId, {
    int limit = 20,
  }) async* {}

  @override
  Future<List<Badge>> getUserBadges(
    String userId, {
    String? lastBadgeId,
    int limit = 20,
  }) async {
    return [];
  }

  @override
  Future<List<Badge>> getUserCreatedBadges(
    String userId, {
    String? lastBadgeId,
    int limit = 20,
  }) async {
    return [];
  }

  // booking related stuff
  @override
  Future<void> createBooking(
    Booking booking,
  ) {
    return Future(() => null);
  }

  @override
  Future<Booking?> getBookingById(
    String bookRequestId,
  ) {
    return Future(() => null);
  }

  @override
  Future<List<Booking>> getBookingsByRequesterRequestee(
    String requesterId,
    String requesteeId, {
    int limit = 20,
    String? lastBookingRequestId,
  }) {
    return Future(() => []);
  }

  @override
  Future<List<Booking>> getBookingsByRequester(
    String userId, {
    int limit = 20,
    String? lastBookingRequestId,
  }) {
    return Future(() => []);
  }

  @override
  Future<List<Booking>> getBookingsByRequestee(
    String userId, {
    int limit = 20,
    String? lastBookingRequestId,
  }) {
    return Future(() => []);
  }

  @override
  Future<void> updateBooking(Booking booking) {
    return Future(() => []);
  }

  @override
  Future<List<UserModel>> searchUsersByLocation({
    required double lat,
    required double lng,
    int radiusInMeters = 50 * 1000,
    int limit = 20,
    String? lastUserId,
  }) async {
    return [];
  }

  @override
  Future<void> createReview(Review review) async {}

  @override
  Future<List<Review>> getReviewsByReviewee(
    String revieweeId, {
    int limit = 100,
    String? lastReviewId,
  }) async {
    return [];
  }

  @override
  Future<List<Review>> getReviewsByReviewer(
    String reviewerId, {
    int limit = 100,
    String? lastReviewId,
  }) async {
    return [];
  }

  @override
  Future<List<Review>> getReviewsForBooking(
    Booking booking,
  ) async {
    return [];
  }

  @override
  Future<bool> hasUserReviewedBooking(
    String userId,
    Booking booking,
  ) async {
    return false;
  }
}
