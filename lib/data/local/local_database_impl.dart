import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/comment.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/post.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

class LocalDatabaseImpl extends DatabaseRepository {
  @override
  Future<bool> userEmailExists(String email) async {
    await Future<void>.delayed(Duration.zero);
    return true;
  }

  @override
  Future<UserModel> getUserByUsername(String? username) async {
    await Future<void>.delayed(Duration.zero);
    return UserModel.empty();
  }

  @override
  Future<void> createUser(UserModel user) async {
    await Future<void>.delayed(Duration.zero);
    return;
  }

  @override
  Future<UserModel> getUserById(String userId) async {
    await Future<void>.delayed(Duration.zero);
    return UserModel.empty();
  }

  @override
  Future<Loop> getLoopById(String loopId) async {
    await Future<void>.delayed(Duration.zero);
    return Loop.empty();
  }

  @override
  Future<int> followersNum(String userid) async {
    await Future<void>.delayed(Duration.zero);
    return 42;
  }

  @override
  Future<int> followingNum(String userid) async {
    await Future<void>.delayed(Duration.zero);
    return 42;
  }

  @override
  Future<void> updateUserData(UserModel user) async {
    await Future<void>.delayed(Duration.zero);
    return;
  }

  @override
  Future<void> followUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    await Future<void>.delayed(Duration.zero);
    return;
  }

  @override
  Future<void> unfollowUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    await Future<void>.delayed(Duration.zero);
    return;
  }

  @override
  Future<bool> isFollowingUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    await Future<void>.delayed(Duration.zero);
    return false;
  }

  @override
  Future<List<UserModel>> getFollowing(String currentUserId) async {
    await Future<void>.delayed(Duration.zero);
    return [];
  }

  @override
  Future<List<UserModel>> getFollowers(String currentUserId) async {
    await Future<void>.delayed(Duration.zero);
    return [];
  }

  @override
  Future<void> addLoop(Loop loop) async {
    await Future<void>.delayed(Duration.zero);
    return;
  }

  @override
  Future<void> deleteLoop(Loop loop) async {
    await Future<void>.delayed(Duration.zero);
    return;
  }

  @override
  Future<List<Loop>> getUserLoops(
    String userId, {
    int limit = 0,
    String? lastLoopId,
  }) async {
    await Future<void>.delayed(Duration.zero);
    return [];
  }

  @override
  Stream<Loop> userLoopsObserver(String userId, {int limit = 20}) async* {}

  @override
  Future<List<Loop>> getFollowingLoops(
    String currentUserId, {
    int limit = 0,
    String? lastLoopId,
  }) async {
    await Future<void>.delayed(Duration.zero);
    return [];
  }

  @override
  Stream<Loop> followingLoopsObserver(
    String currentUserId, {
    int limit = 20,
  }) async* {}

  @override
  Future<List<Loop>> getAllLoops(
    String currentUserId, {
    int limit = 0,
    String? lastLoopId,
  }) async {
    await Future<void>.delayed(Duration.zero);
    return [];
  }

  @override
  Stream<Loop> allLoopsObserver(
    String currentUserId, {
    int limit = 20,
  }) async* {}

  @override
  Future<void> addLike(
    String currentUserId,
    String entityId,
    EntityType entityType,
  ) async {
    await Future<void>.delayed(Duration.zero);
    return;
  }

  @override
  Future<void> deleteLike(
    String currentUserId,
    String entityId,
    EntityType entityType,
  ) async {
    await Future<void>.delayed(Duration.zero);
    return;
  }

  @override
  Future<bool> isLiked(
    String currentUserId,
    String entityId,
    EntityType entityType,
  ) async {
    await Future<void>.delayed(Duration.zero);
    return false;
  }

  @override
  Future<List<UserModel>> getLikes(
    String entityId,
    EntityType entityType,
  ) async {
    await Future<void>.delayed(Duration.zero);
    return [];
  }

  @override
  Future<List<Activity>> getActivities(
    String userId, {
    int limit = 0,
    String? lastActivityId,
  }) async {
    await Future<void>.delayed(Duration.zero);
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
    Loop? loop,
    required ActivityType type,
    String? visitedUserId,
  }) async {
    await Future<void>.delayed(Duration.zero);
    return;
  }

  @override
  Future<void> markActivityAsRead(Activity activity) async {
    await Future<void>.delayed(Duration.zero);
    return;
  }

  @override
  Future<List<Comment>> getComments(
    String rootId,
    EntityType rootType, {
    int limit = 20,
  }) async {
    await Future<void>.delayed(Duration.zero);
    return [];
  }

  @override
  Stream<Comment> commentsObserver(
    String rootId,
    EntityType rootType, {
    int limit = 20,
  }) async* {}

  @override
  Future<Comment> getComment(
    String rootId,
    EntityType rootType,
    String commentId,
  ) async {
    await Future<void>.delayed(Duration.zero);
    return Comment.empty();
  }

  @override
  Future<void> addComment(
    Comment comment,
    EntityType rootType,
  ) async {
    await Future<void>.delayed(Duration.zero);
    return;
  }

  // Future<List<Tag>> getTagSuggestions(String query) async {
  //   await Future<void>.delayed(Duration(seconds: 2));
  //   return [];
  // }

  @override
  Future<void> shareLoop(Loop loop) async {
    await Future<void>.delayed(Duration.zero);
    return;
  }

  @override
  Future<bool> checkUsernameAvailability(String username, String userid) async {
    await Future<void>.delayed(Duration.zero);
    return true;
  }

  @override
  Future<bool> isVerified(String userId) async {
    await Future<void>.delayed(Duration.zero);
    return false;
  }

  @override
  Future<void> createBadge(Badge badge) async {
    await Future<void>.delayed(Duration.zero);
    return;
  }

  @override
  Future<void> sendBadge(String badgeId, String receiverId) async {
    await Future<void>.delayed(Duration.zero);
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
    await Future<void>.delayed(Duration.zero);
    return [];
  }

  @override
  Future<List<Badge>> getUserCreatedBadges(
    String userId, {
    String? lastBadgeId,
    int limit = 20,
  }) async {
    await Future<void>.delayed(Duration.zero);
    return [];
  }

  // Post related stuff
  @override
  Future<Post> getPostById(String postId) async {
    await Future<void>.delayed(Duration.zero);
    return Post.empty();
  }

  @override
  Future<void> addPost(Post post) async {}
  @override
  Future<void> deletePost(Post post) async {}
  @override
  Future<List<Post>> getUserPosts(
    String userId, {
    int limit = 20,
    String? lastPostId,
  }) async {
    await Future<void>.delayed(Duration.zero);
    return [];
  }

  @override
  Stream<Post> userPostsObserver(
    String userId, {
    int limit = 20,
  }) async* {}
  @override
  Future<List<Post>> getFollowingPosts(
    String currentUserId, {
    int limit = 20,
    String? lastPostId,
  }) async {
    await Future<void>.delayed(Duration.zero);
    return [];
  }

  @override
  Stream<Post> followingPostsObserver(
    String currentUserId, {
    int limit = 20,
  }) async* {}
  @override
  Future<List<Post>> getAllPosts(
    String currentUserId, {
    int limit = 20,
    String? lastPostId,
  }) async {
    await Future<void>.delayed(Duration.zero);
    return [];
  }

  @override
  Stream<Post> allPostsObserver(
    String currentUserId, {
    int limit = 20,
  }) async* {}

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
}
