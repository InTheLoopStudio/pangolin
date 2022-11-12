import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/domains/models/comment.dart';
import 'package:intheloopapp/domains/models/loop.dart';
// import 'package:intheloopapp/domains/models/tag.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

abstract class DatabaseRepository {
  Future<bool> userEmailExists(String email);
  Future<void> createUser(UserModel user);
  Future<UserModel?> getUserByUsername(String? username);
  Future<UserModel> getUser(String userId);
  Future<Loop> getLoopById(String loopId);
  Future<int> followersNum(String userid);
  Future<int> followingNum(String userid);
  Future<void> updateUserData(UserModel user);
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
  Future<void> uploadLoop(Loop loop);
  Future<void> deleteLoop(Loop loop);
  Future<List<Loop>> getUserLoops(
    String userId, {
    int limit = 20,
    String? lastLoopId,
  });
  Stream<Loop> userLoopsObserver(
    String userId, {
    int limit = 20,
  });
  Future<List<Loop>> getFollowingLoops(
    String currentUserId, {
    int limit = 20,
    String? lastLoopId,
  });
  Stream<Loop> followingLoopsObserver(
    String currentUserId, {
    int limit = 20,
  });
  Future<List<Loop>> getAllLoops(
    String currentUserId, {
    int limit = 20,
    String? lastLoopId,
  });
  Stream<Loop> allLoopsObserver(
    String currentUserId, {
    int limit = 20,
  });
  Future<void> likeLoop(String currentUserId, Loop loop);
  Future<void> unlikeLoop(String currentUserId, Loop loop);
  Future<bool> isLikeLoop(String currentUserId, Loop loop);
  Future<List<UserModel>> getLikes(Loop loop);
  Future<List<Activity>> getActivities(
    String userId, {
    int limit = 20,
    String? lastActivityId,
  });
  Stream<Activity> activitiesObserver(
    String userId, {
    int limit = 20,
  });
  Future<void> addActivity({
    required String currentUserId,
    required String visitedUserId,
    required ActivityType type,
    Loop? loop,
  });
  Future<void> markActivityAsRead(Activity activity);
  Future<List<Comment>> getLoopComments(
    Loop loop, {
    int limit = 20,
  });
  Stream<Comment> loopCommentsObserver(
    Loop loop, {
    int limit = 20,
  });
  Future<Comment> getComment(Loop loop, String commentId);
  Future<void> addComment(Comment comment, String visitedUserId);
  // Future<void> deleteComment(Comment comment);
  // Future<List<Tag>> getTagSuggestions(String query);
  Future<void> shareLoop(Loop loop);
  Future<bool> checkUsernameAvailability(String username, String userid);
  Future<void> createBadge(Badge badge);
  Future<void> sendBadge(String badgeId, String receiverId);
  Stream<Badge> userCreatedBadgesObserver(
    String userId, {
    int limit = 20,
  });
  Future<List<Badge>> getUserCreatedBadges(
    String userId, {
    int limit = 20,
    String? lastBadgeId,
  });
    Stream<Badge> userBadgesObserver(
    String userId, {
    int limit = 20,
  });
  Future<List<Badge>> getUserBadges(
    String userId, {
    int limit = 20,
    String? lastBadgeId,
  });
}
