import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/domains/models/comment.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

class LocalDatabaseImpl extends DatabaseRepository {
  @override
  Future<bool> userEmailExists(String email) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return true;
  }

  @override
  Future<UserModel> getUserByUsername(String? username) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return UserModel.empty();
  }

  @override
  Future<void> createUser(UserModel user) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Future<UserModel> getUser(String userId) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return UserModel.empty();
  }

  @override
  Future<Loop> getLoopById(String loopId) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return Loop.empty();
  }

  @override
  Future<int> followersNum(String userid) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return 42;
  }

  @override
  Future<int> followingNum(String userid) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return 42;
  }

  @override
  Future<void> updateUserData(UserModel user) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Future<void> followUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Future<void> unfollowUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Future<bool> isFollowingUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return false;
  }

  @override
  Future<List<UserModel>> getFollowing(String currentUserId) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return [];
  }

  @override
  Future<List<UserModel>> getFollowers(String currentUserId) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return [];
  }

  @override
  Future<void> uploadLoop(Loop loop) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Future<void> deleteLoop(Loop loop) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Future<List<Loop>> getUserLoops(
    String userId, {
    int limit = 0,
    String? lastLoopId,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
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
    await Future<void>.delayed(const Duration(seconds: 2));
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
    await Future<void>.delayed(const Duration(seconds: 2));
    return [];
  }

  @override
  Stream<Loop> allLoopsObserver(
    String currentUserId, {
    int limit = 20,
  }) async* {}

  @override
  Future<void> likeLoop(String currentUserId, Loop loop) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Future<void> unlikeLoop(String currentUserId, Loop loop) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Future<bool> isLikeLoop(String currentUserId, Loop loop) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return false;
  }

  @override
  Future<List<UserModel>> getLikes(Loop loop) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return [];
  }

  @override
  Future<List<Activity>> getActivities(
    String userId, {
    int limit = 0,
    String? lastActivityId,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
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
    await Future<void>.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Future<void> markActivityAsRead(Activity activity) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Future<List<Comment>> getLoopComments(
    Loop loop, {
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return [];
  }

  @override
  Stream<Comment> loopCommentsObserver(Loop loop, {int limit = 20}) async* {}

  @override
  Future<Comment> getComment(Loop loop, String commentId) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return Comment(content: '');
  }

  @override
  Future<void> addComment(Comment comment, String visitedUserId) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return;
  }

  // Future<List<Tag>> getTagSuggestions(String query) async {
  //   await Future<void>.delayed(Duration(seconds: 2));
  //   return [];
  // }

  @override
  Future<void> shareLoop(Loop loop) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Future<bool> checkUsernameAvailability(String username, String userid) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return true;
  }

  @override
  Future<void> createBadge(Badge badge) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Stream<Badge> userBadgesObserver(String userId, {int limit = 20}) async* {}
  @override
  Future<List<Badge>> getUserBadges(
    String userId, {
    String? lastBadgeId,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return [];
  }
}
