import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/comment.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

class LocalDatabaseImpl extends DatabaseRepository {
  Future<bool> userEmailExists(String email) async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  Future<UserModel> getUserByUsername(String? username) async {
    await Future.delayed(Duration(seconds: 2));
    return UserModel.empty;
  }

  Future<void> createUser(UserModel user) async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }

  Future<UserModel> getUser(String userId) async {
    await Future.delayed(Duration(seconds: 2));
    return UserModel.empty;
  }

  Future<Loop> getLoopById(String loopId) async {
    await Future.delayed(Duration(seconds: 2));
    return Loop.empty;
  }

  Future<int> followersNum(String userid) async {
    await Future.delayed(Duration(seconds: 2));
    return 42;
  }

  Future<int> followingNum(String userid) async {
    await Future.delayed(Duration(seconds: 2));
    return 42;
  }

  Future<void> updateUserData(UserModel user) async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }

  Future<void> followUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }

  Future<void> unfollowUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }

  Future<bool> isFollowingUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    await Future.delayed(Duration(seconds: 2));
    return false;
  }

  Future<List<UserModel>> getFollowing(String currentUserId) async {
    await Future.delayed(Duration(seconds: 2));
    return [];
  }

  Future<List<UserModel>> getFollowers(String currentUserId) async {
    await Future.delayed(Duration(seconds: 2));
    return [];
  }

  Future<void> uploadLoop(Loop loop) async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }

  Future<void> deleteLoop(Loop loop) async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }

  Future<List<Loop>> getUserLoops(
    String userId, {
    int limit = 0,
    String? lastLoopId,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return [];
  }

  Stream<Loop> userLoopsObserver(String userId, {int limit = 20}) async* {}

  Future<List<Loop>> getFollowingLoops(
    String currentUserId, {
    int limit = 0,
    String? lastLoopId,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return [];
  }

  Stream<Loop> followingLoopsObserver(
    String currentUserId, {
    int limit = 20,
  }) async* {}

  Future<List<Loop>> getAllLoops(
    String currentUserId, {
    int limit = 0,
    String? lastLoopId,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return [];
  }

  Stream<Loop> allLoopsObserver(
    String currentUserId, {
    int limit = 20,
  }) async* {}

  Future<void> likeLoop(String currentUserId, Loop loop) async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }

  Future<void> unlikeLoop(String currentUserId, Loop loop) async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }

  Future<bool> isLikeLoop(String currentUserId, Loop loop) async {
    await Future.delayed(Duration(seconds: 2));
    return false;
  }

  Future<List<UserModel>> getLikes(Loop loop) async {
    await Future.delayed(Duration(seconds: 2));
    return [];
  }

  Future<List<Activity>> getActivities(
    String userId, {
    int limit = 0,
    String? lastActivityId,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return [];
  }

  Stream<Activity> activitiesObserver(
    String userId, {
    int limit = 20,
  }) async* {}

  Future<void> addActivity({
    required String currentUserId,
    Loop? loop,
    required ActivityType type,
    String? visitedUserId,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }

  Future<void> markActivityAsRead(Activity activity) async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }

  Future<List<Comment>> getLoopComments(
    Loop loop, {
    int limit = 20,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return [];
  }

  loopCommentsObserver(Loop loop, {int limit = 20}) async* {}

  Future<Comment> getComment(Loop loop, String commentId) async {
    await Future.delayed(Duration(seconds: 2));
    return Comment(id: '', parentId: null, content: '');
  }

  Future<void> addComment(Comment comment, String visitedUserId) async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }

  // Future<List<Tag>> getTagSuggestions(String query) async {
  //   await Future.delayed(Duration(seconds: 2));
  //   return [];
  // }

  Future<void> shareLoop(Loop loop) async {
    await Future.delayed(Duration(seconds: 2));
    return;
  }
}
