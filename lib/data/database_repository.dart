import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/domains/models/comment.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/post.dart';
// import 'package:intheloopapp/domains/models/tag.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

enum EntityType {
  loop,
  post,
}

abstract class DatabaseRepository {
  // User related stuff
  Future<bool> userEmailExists(String email);
  Future<void> createUser(UserModel user);
  Future<UserModel?> getUserByUsername(String? username);
  Future<UserModel?> getUserById(String userId);
  Future<void> updateUserData(UserModel user);
  Future<bool> checkUsernameAvailability(String username, String userid);

  // Loop related stuff
  Future<Loop> getLoopById(String loopId);
  Future<void> addLoop(Loop loop);
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

  // Liking related stuff
  Future<void> addLike(
    String currentUserId,
    String entityId,
    EntityType entityType,
  );
  Future<void> deleteLike(
    String currentUserId,
    String entityId,
    EntityType entityType,
  );
  Future<bool> isLiked(
    String currentUserId,
    String entityId,
    EntityType entityType,
  );
  Future<List<UserModel>> getLikes(
    String entityId,
    EntityType entityType,
  );

  // Commenting related stuff
  Future<List<Comment>> getComments(
    String rootId,
    EntityType rootType, {
    int limit = 20,
  });
  Stream<Comment> commentsObserver(
    String rootId,
    EntityType rootType, {
    int limit = 20,
  });
  Future<Comment> getComment(
    String rootId,
    EntityType rootType,
    String commentId,
  );
  Future<void> addComment(
    Comment comment,
    EntityType rootType,
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

  // Badge related stuff
  Future<bool> isVerified(String userId);
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

  // Post related stuff
  Future<Post> getPostById(String postId);
  Future<void> addPost(Post post);
  Future<void> deletePost(Post post);
  Future<List<Post>> getUserPost(
    String userId, {
    int limit = 20,
    String? lastPostId,
  });
  Stream<Post> userPostsObserver(
    String userId, {
    int limit = 20,
  });
  Future<List<Post>> getFollowingPosts(
    String currentUserId, {
    int limit = 20,
    String? lastPostId,
  });
  Stream<Post> followingPostsObserver(
    String currentUserId, {
    int limit = 20,
  });
  Future<List<Post>> getAllPosts(
    String currentUserId, {
    int limit = 20,
    String? lastPostId,
  });
  Stream<Post> allPostsObserver(
    String currentUserId, {
    int limit = 20,
  });
}
