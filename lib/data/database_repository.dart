import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/comment.dart';
import 'package:intheloopapp/domains/models/loop.dart';
// import 'package:intheloopapp/domains/models/tag.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

abstract class DatabaseRepository {
  // User related stuff
  Future<bool> userEmailExists(String email);
  Future<void> createUser(UserModel user);
  Future<UserModel?> getUserByUsername(String? username);
  Future<UserModel?> getUserById(String userId);
  Future<List<UserModel>> searchUsersByLocation({
    required double lat,
    required double lng,
    int radiusInMeters = 50 * 1000, // 50km
    int limit = 100,
    String? lastUserId,
  });
  Future<void> updateUserData(UserModel user);
  Future<bool> checkUsernameAvailability(String username, String userid);

  // Loop related stuff
  Future<Loop> getLoopById(String loopId);
  Future<void> addLoop(Loop loop);
  Future<void> deleteLoop(Loop loop);
  Future<List<Loop>> getUserLoops(
    String userId, {
    int limit = 100,
    String? lastLoopId,
  });
  Stream<Loop> userLoopsObserver(
    String userId, {
    int limit = 100,
  });
  Future<List<Loop>> getFollowingLoops(
    String currentUserId, {
    int limit = 100,
    String? lastLoopId,
  });
  Stream<Loop> followingLoopsObserver(
    String currentUserId, {
    int limit = 100,
  });
  Future<List<Loop>> getAllLoops(
    String currentUserId, {
    int limit = 100,
    String? lastLoopId,
  });
  Stream<Loop> allLoopsObserver(
    String currentUserId, {
    int limit = 100,
  });

  // Liking related stuff
  Future<void> addLike(
    String currentUserId,
    String loopId,
  );
  Future<void> deleteLike(
    String currentUserId,
    String loopId,
  );
  Future<bool> isLiked(
    String currentUserId,
    String loopId,
  );
  Future<List<UserModel>> getLikes(
    String loopId,
  );

  // Commenting related stuff
  Future<List<Comment>> getComments(
    String rootId, {
    int limit = 100,
  });
  Stream<Comment> commentsObserver(
    String rootId, {
    int limit = 100,
  });
  Future<Comment> getComment(
    String rootId,
    String commentId,
  );
  Future<void> addComment(
    Comment comment,
  );
  // Future<void> deleteComment(Comment comment);

  // Future<List<Tag>> getTagSuggestions(String query);

  // Sharing related stuff
  Future<void> shareLoop(Loop loop);

  // Following related stuff
  Future<int> followersNum(String userid);
  Future<int> followingNum(String userid);
  Future<void> followUser(
    String currentUserId,
    String visitedUserId,
  );
  Future<void> unfollowUser(
    String currentUserId,
    String visitedUserId,
  );
  Future<bool> isFollowingUser(
    String currentUserId,
    String visitedUserId,
  );
  Future<List<UserModel>> getFollowing(String currentUserId);
  Future<List<UserModel>> getFollowers(String currentUserId);

  // Activity related stuff
  Future<List<Activity>> getActivities(
    String userId, {
    int limit = 100,
    String? lastActivityId,
  });
  Stream<Activity> activitiesObserver(
    String userId, {
    int limit = 100,
  });
  Future<void> addActivity({
    required String currentUserId,
    required String visitedUserId,
    required ActivityType type,
    Loop? loop,
  });
  Future<void> markActivityAsRead(Activity activity);

  // Badge related stuff
  Future<bool> isVerified(String userId);
  Future<void> createBadge(Badge badge);
  Future<void> sendBadge(String badgeId, String receiverId);
  Stream<Badge> userCreatedBadgesObserver(
    String userId, {
    int limit = 100,
  });
  Future<List<Badge>> getUserCreatedBadges(
    String userId, {
    int limit = 100,
    String? lastBadgeId,
  });
  Stream<Badge> userBadgesObserver(
    String userId, {
    int limit = 100,
  });
  Future<List<Badge>> getUserBadges(
    String userId, {
    int limit = 100,
    String? lastBadgeId,
  });

  // Booking related stuff
  Future<void> createBooking(
    Booking booking,
  );
  Future<Booking?> getBookingById(
    String bookRequestId,
  );
  Future<List<Booking>> getBookingsByRequesterRequestee(
    String requesterId,
    String requesteeId, {
    int limit = 20,
    String? lastBookingRequestId,
  });
  Future<List<Booking>> getBookingsByRequester(
    String userId, {
    int limit = 20,
    String? lastBookingRequestId,
  });
  Future<List<Booking>> getBookingsByRequestee(
    String userId, {
    int limit = 20,
    String? lastBookingRequestId,
  });
  Future<void> updateBooking(Booking booking);
}
