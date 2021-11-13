import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/comment.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

final _functions = FirebaseFunctions.instance;
final _firestore = FirebaseFirestore.instance;

final usersRef = _firestore.collection('users');
final followersRef = _firestore.collection('followers');
final followingRef = _firestore.collection('following');
final loopsRef = _firestore.collection('loops');
final feedRefs = _firestore.collection('feeds');
final likesRef = _firestore.collection('likes');
final activitiesRef = _firestore.collection('activities');
final commentsRef = _firestore.collection('comments');

class FirestoreDatabaseImpl extends DatabaseRepository {
  Future<bool> userEmailExists(String email) async {
    QuerySnapshot userSnapshot =
        await usersRef.where('email', isEqualTo: email).get();

    return userSnapshot.docs.length != 0;
  }

  Future<void> createUser(UserModel user) async {
    HttpsCallable callable = _functions.httpsCallable('createUser');
    final results = await callable(user.toMap());

    print(results.data.toString());
  }

  Future<UserModel?> getUserByUsername(String? username) async {
    if (username == null) return null;

    QuerySnapshot<Map<String, dynamic>> userSnapshots =
        await usersRef.where('username', isEqualTo: username).get();

    if (userSnapshots.docs.length > 0) {
      return UserModel.fromDoc(userSnapshots.docs.first);
    }

    return null;
  }

  Future<UserModel> getUser(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await usersRef.doc(userId).get();
    UserModel user = UserModel.fromDoc(userSnapshot);

    return user;
  }

  Future<Loop> getLoopById(String loopId) async {
    DocumentSnapshot<Map<String, dynamic>> loopSnapshot =
        await loopsRef.doc(loopId).get();

    Loop loop = Loop.fromDoc(loopSnapshot);

    return loop;
  }

  Future<int> followersNum(String userid) async {
    QuerySnapshot followersSnapshot =
        await followersRef.doc(userid).collection('Followers').get();

    return followersSnapshot.docs.length;
  }

  Future<int> followingNum(String userid) async {
    QuerySnapshot followingSnapshot =
        await followingRef.doc(userid).collection('Following').get();

    return followingSnapshot.docs.length;
  }

  Future<void> updateUserData(UserModel user) async {
    HttpsCallable callable = _functions.httpsCallable('updateUserData');
    final results = await callable(user.toMap());

    print(results.data.toString());
  }

  Future<void> followUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    HttpsCallable callable = _functions.httpsCallable('followUser');
    final results = await callable({
      'follower': currentUserId,
      'followed': visitedUserId,
    });

    print(results.data.toString());
  }

  Future<void> unfollowUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    HttpsCallable callable = _functions.httpsCallable('unfollowUser');
    final results = await callable({
      'follower': currentUserId,
      'followed': visitedUserId,
    });

    print(results.data.toString());
  }

  Future<bool> isFollowingUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    try {
      DocumentSnapshot followingDoc = await followersRef
          .doc(visitedUserId)
          .collection('Followers')
          .doc(currentUserId)
          .get();
      return followingDoc.exists;
    } on Exception catch (e) {
      print("[ERROR] isFollowingUser - canceled");
      print(e);

      return false;
    }
  }

  Future<List<UserModel>> getFollowing(String currentUserId) async {
    QuerySnapshot userFollowingSnapshot =
        await followingRef.doc(currentUserId).collection('Following').get();

    List<Future<UserModel>> followingFutures = userFollowingSnapshot.docs.map(
      (doc) async {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await usersRef.doc(doc.id).get();
        return UserModel.fromDoc(userDoc);
      },
    ).toList();

    List<UserModel> following = await Future.wait(followingFutures);

    return following;
  }

  Future<List<UserModel>> getFollowers(String currentUserId) async {
    QuerySnapshot userFollowerSnapshot =
        await followersRef.doc(currentUserId).collection('Followers').get();

    List<Future<UserModel>> followerFutures = userFollowerSnapshot.docs.map(
      (doc) async {
        print(doc);
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await usersRef.doc(doc.id).get();
        return UserModel.fromDoc(userDoc);
      },
    ).toList();

    List<UserModel> followers = await Future.wait(followerFutures);

    return followers;
  }

  Future<void> uploadLoop(Loop loop) async {
    HttpsCallable callable = _functions.httpsCallable('uploadLoop');
    final results = await callable({
      'loopTitle': loop.title,
      'loopAudio': loop.audio,
      'loopUserId': loop.userId,
      'loopLikes': loop.likes,
      'loopDownloads': loop.downloads,
      'loopComments': loop.comments,
      'loopTags': loop.tags,
    });

    print(results.data.toString());
  }

  Future<void> deleteLoop(Loop loop) async {
    HttpsCallable callable = _functions.httpsCallable('deleteLoop');
    final results = await callable({
      'id': loop.id,
      'userId': loop.userId,
    });

    print(results.data.toString());
  }

  Future<List<Loop>> getUserLoops(
    String userId, {
    int limit = 20,
    String? lastLoopId,
  }) async {
    if (lastLoopId != null) {
      DocumentSnapshot documentSnapshot = await loopsRef.doc(lastLoopId).get();

      QuerySnapshot<Map<String, dynamic>> userLoopsSnapshot = await loopsRef
          .orderBy('timestamp', descending: true)
          .where('userId', isEqualTo: userId)
          // .where('deleted', isNotEqualTo: true)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      List<Loop> userLoops =
          userLoopsSnapshot.docs.map((doc) => Loop.fromDoc(doc)).toList();

      userLoops = userLoops.where((loop) => loop.deleted != true).toList();

      return userLoops;
    } else {
      QuerySnapshot<Map<String, dynamic>> userLoopsSnapshot = await loopsRef
          .orderBy('timestamp', descending: true)
          .where('userId', isEqualTo: userId)
          .limit(limit)
          .get();

      List<Loop> userLoops =
          userLoopsSnapshot.docs.map((doc) => Loop.fromDoc(doc)).toList();

      userLoops = userLoops.where((loop) => loop.deleted != true).toList();

      return userLoops;
    }
  }

  Stream<Loop> userLoopsObserver(
    String userId, {
    int limit = 20,
  }) async* {
    Stream<QuerySnapshot<Map<String, dynamic>>> userLoopsSnapshotObserver =
        loopsRef
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            // .where('deleted', isNotEqualTo: true)
            .limit(limit)
            .snapshots();

    Stream<Loop> userLoopsObserver = userLoopsSnapshotObserver.map((event) {
      return event.docChanges
          .where((DocumentChange<Map<String, dynamic>> element) =>
              element.type == DocumentChangeType.added)
          .map((DocumentChange<Map<String, dynamic>> element) {
        return Loop.fromDoc(element.doc);
        // if (element.type == DocumentChangeType.modified) {}
        // if (element.type == DocumentChangeType.removed) {}
      });
    }).flatMap((value) =>
        Stream.fromIterable(value).where((loop) => loop.deleted != true));

    yield* userLoopsObserver;
  }

  Future<List<Loop>> getFollowingLoops(
    String currentUserId, {
    int limit = 20,
    String? lastLoopId,
  }) async {
    if (lastLoopId != null) {
      DocumentSnapshot documentSnapshot = await loopsRef.doc(lastLoopId).get();

      QuerySnapshot<Map<String, dynamic>> userFeedLoops = await feedRefs
          .doc(currentUserId)
          .collection('userFeed')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      List<Loop> followingLoops = await Future.wait(
        userFeedLoops.docs.map((doc) async {
          Loop loop = await getLoopById(doc.id);
          return loop;
        }),
      );

      followingLoops =
          followingLoops.where((loop) => loop.deleted != true).toList();

      return followingLoops;
    } else {
      QuerySnapshot<Map<String, dynamic>> userFeedLoops = await feedRefs
          .doc(currentUserId)
          .collection('userFeed')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      List<Loop> followingLoops = await Future.wait(
        userFeedLoops.docs.map((doc) async {
          Loop loop = await getLoopById(doc.id);
          return loop;
        }),
      );

      followingLoops =
          followingLoops.where((loop) => loop.deleted != true).toList();

      return followingLoops;
    }
  }

  Stream<Loop> followingLoopsObserver(
    String currentUserId, {
    int limit = 20,
  }) async* {
    Stream<QuerySnapshot<Map<String, dynamic>>> userFeedLoopsSnapshotObserver =
        feedRefs
            .doc(currentUserId)
            .collection('userFeed')
            .orderBy('timestamp', descending: true)
            .limit(limit)
            .snapshots();

    Stream<Loop> userFeedLoopsObserver = userFeedLoopsSnapshotObserver
        .map((event) {
      return event.docChanges
          .where((DocumentChange<Map<String, dynamic>> element) =>
              element.type == DocumentChangeType.added)
          .map((DocumentChange<Map<String, dynamic>> element) async {
        return await getLoopById(element.doc.id);
        // if (element.type == DocumentChangeType.modified) {}
        // if (element.type == DocumentChangeType.removed) {}
      });
    }).flatMap((value) =>
            Stream.fromFutures(value).where((loop) => loop.deleted != true));

    yield* userFeedLoopsObserver;
  }

  Future<List<Loop>> getAllLoops(
    String currentUserId, {
    int limit = 20,
    String? lastLoopId,
  }) async {
    if (lastLoopId != null) {
      DocumentSnapshot documentSnapshot = await loopsRef.doc(lastLoopId).get();

      QuerySnapshot<Map<String, dynamic>> allLoopsDocs = await loopsRef
          .orderBy('timestamp', descending: true)
          // .where('deleted', isNotEqualTo: true)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      List<Loop> allLoopsList = await Future.wait(
        allLoopsDocs.docs.map((doc) async => Loop.fromDoc(doc)).toList(),
      );

      return allLoopsList
          .where((e) => e.userId != currentUserId && e.deleted != true)
          .toList();
    } else {
      QuerySnapshot<Map<String, dynamic>> allLoopsDocs = await loopsRef
          .orderBy('timestamp', descending: true)
          // .where('deleted', isNotEqualTo: true)
          .limit(limit)
          .get();

      List<Loop> allLoopsList = await Future.wait(
        allLoopsDocs.docs.map((doc) async => Loop.fromDoc(doc)).toList(),
      );

      return allLoopsList
          .where((e) => e.userId != currentUserId && e.deleted != true)
          .toList();
    }
  }

  Stream<Loop> allLoopsObserver(
    String currentUserId, {
    int limit = 20,
  }) async* {
    Stream<QuerySnapshot<Map<String, dynamic>>> allLoopsSnapshotObserver =
        loopsRef
            .orderBy('timestamp', descending: true)
            // .where('deleted', isNotEqualTo: true)
            .limit(limit)
            .snapshots();

    Stream<Loop> allLoopsObserver = allLoopsSnapshotObserver.map((event) {
      return event.docChanges
          .where((DocumentChange<Map<String, dynamic>> element) =>
              element.type == DocumentChangeType.added)
          .map((DocumentChange<Map<String, dynamic>> element) {
        return Loop.fromDoc(element.doc);
        // if (element.type == DocumentChangeType.modified) {}
        // if (element.type == DocumentChangeType.removed) {}
      });
    }).flatMap((value) => Stream.fromIterable(value)
        .where((loop) => loop.userId != currentUserId && loop.deleted != true));

    yield* allLoopsObserver;
  }

  Future<void> likeLoop(String currentUserId, Loop loop) async {
    HttpsCallable callable = _functions.httpsCallable('likeLoop');
    final results = await callable({
      'currentUserId': currentUserId,
      'loopId': loop.id,
      'loopUserId': loop.userId,
    });

    print(results.data.toString());
  }

  Future<void> unlikeLoop(String currentUserId, Loop loop) async {
    HttpsCallable callable = _functions.httpsCallable('unlikeLoop');
    final results = await callable({
      'currentUserId': currentUserId,
      'loopId': loop.id,
      'loopUserId': loop.userId,
    });

    print(results.data.toString());
  }

  Future<bool> isLikeLoop(String currentUserId, Loop loop) async {
    DocumentSnapshot userDoc = await likesRef
        .doc(loop.id)
        .collection('loopLikes')
        .doc(currentUserId)
        .get();

    return userDoc.exists;
  }

  Future<List<UserModel>> getLikes(Loop loop) async {
    QuerySnapshot likesSnapshot =
        await likesRef.doc(loop.id).collection('loopLikes').get();

    List<UserModel> usersList =
        await Future.wait(likesSnapshot.docs.map((doc) async {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await usersRef.doc(doc.id).get();
      return UserModel.fromDoc(userDoc);
    }).toList());

    return usersList;
  }

  Future<List<Activity>> getActivities(
    String userId, {
    int limit = 20,
    String? lastActivityId,
  }) async {
    if (lastActivityId != null) {
      DocumentSnapshot documentSnapshot =
          await activitiesRef.doc(lastActivityId).get();

      QuerySnapshot<Map<String, dynamic>> activitiesSnapshot =
          await activitiesRef
              .orderBy('timestamp', descending: true)
              .where('toUserId', isEqualTo: userId)
              .limit(limit)
              .startAfterDocument(documentSnapshot)
              .get();

      List<Activity> activities =
          activitiesSnapshot.docs.map((doc) => Activity.fromDoc(doc)).toList();

      return activities;
    } else {
      QuerySnapshot<Map<String, dynamic>> activitiesSnapshot =
          await activitiesRef
              .orderBy('timestamp', descending: true)
              .where('toUserId', isEqualTo: userId)
              .limit(limit)
              .get();

      List<Activity> activities =
          activitiesSnapshot.docs.map((doc) => Activity.fromDoc(doc)).toList();

      return activities;
    }
  }

  Stream<Activity> activitiesObserver(
    String userId, {
    int limit = 20,
  }) async* {
    Stream<QuerySnapshot<Map<String, dynamic>>> activitiesSnapshotObserver =
        activitiesRef
            .orderBy('timestamp', descending: true)
            .where('toUserId', isEqualTo: userId)
            .limit(limit)
            .snapshots();

    Stream<Activity> activitiesObserver =
        activitiesSnapshotObserver.map((event) {
      return event.docChanges
          .where((DocumentChange<Map<String, dynamic>> element) =>
              element.type == DocumentChangeType.added)
          .map((DocumentChange<Map<String, dynamic>> element) {
        return Activity.fromDoc(element.doc);
        // if (element.type == DocumentChangeType.modified) {}
        // if (element.type == DocumentChangeType.removed) {}
      });
    }).flatMap((value) => Stream.fromIterable(value));

    yield* activitiesObserver;
  }

  Future<void> addActivity({
    required String currentUserId,
    required ActivityType type,
    Loop? loop,
    required String visitedUserId,
  }) async {
    HttpsCallable callable = _functions.httpsCallable('addActivity');
    final results = await callable({
      'toUserId': visitedUserId,
      'fromUserId': currentUserId,
      "type": EnumToString.convertToString(type),
    });

    print(results.data.toString());
  }

  Future<void> markActivityAsRead(Activity activity) async {
    HttpsCallable callable = _functions.httpsCallable('markActivityAsRead');
    final results = await callable({
      'id': activity.id,
    });

    print(results.data.toString());
  }

  Future<List<Comment>> getLoopComments(
    Loop loop, {
    int limit = 20,
  }) async {
    QuerySnapshot<Map<String, dynamic>> loopCommentsSnapshot = await commentsRef
        .doc(loop.id)
        .collection('loopComments')
        .orderBy('timestamp')
        // .where('parentId', isNull: true) // Needed for threaded comments
        .limit(limit)
        .get();

    List<Comment> loopComments =
        loopCommentsSnapshot.docs.map((doc) => Comment.fromDoc(doc)).toList();

    return loopComments;
  }

  Stream<Comment> loopCommentsObserver(
    Loop loop, {
    int limit = 20,
  }) async* {
    Stream<QuerySnapshot<Map<String, dynamic>>> loopCommentsSnapshotObserver =
        commentsRef
            .doc(loop.id)
            .collection('loopComments')
            .orderBy('timestamp')
            .limit(limit)
            // .where('parentId', isNull: true) // Needed for threaded comments
            .snapshots();

    Stream<Comment> loopCommentsObserver =
        loopCommentsSnapshotObserver.map((event) {
      return event.docChanges
          .where((DocumentChange<Map<String, dynamic>> element) =>
              element.type == DocumentChangeType.added)
          .map((DocumentChange<Map<String, dynamic>> element) {
        return Comment.fromDoc(element.doc);
        // if (element.type == DocumentChangeType.modified) {}
        // if (element.type == DocumentChangeType.removed) {}
      });
    }).flatMap((value) => Stream.fromIterable(value));

    yield* loopCommentsObserver;
  }

  Future<Comment> getComment(Loop loop, String commentId) async {
    DocumentSnapshot<Map<String, dynamic>> commentSnapshot = await commentsRef
        .doc(loop.id)
        .collection('loopComments')
        .doc(commentId)
        .get();

    Comment comment = Comment.fromDoc(commentSnapshot);

    return comment;
  }

  Future<void> addComment(Comment comment, String visitedUserId) async {
    HttpsCallable callable = _functions.httpsCallable('addComment');
    final results = await callable({
      'visitedUserId': visitedUserId,
      'rootLoopId': comment.rootLoopId ?? '',
      'userId': comment.userId ?? '',
      'content': comment.content ?? '',
      'parentId': comment.parentId ?? '',
      'children': comment.children ?? [],
    });

    print(results.data.toString());
  }

  // Future<List<Tag>> getTagSuggestions(String query) async {
  //   // TODO: Add suggestions to Firestore?
  //   await Future.delayed(Duration(milliseconds: 0), null);

  //   return <Tag>[]
  //       .where((tag) => tag.value.toLowerCase().contains(query.toLowerCase()))
  //       .toList();
  // }

  Future<void> shareLoop(Loop loop) async {
    HttpsCallable callable = _functions.httpsCallable('shareLoop');
    final results = await callable({
      'loopId': loop.id,
      'userId': loop.userId,
    });

    print(results.data.toString());
  }

  Future<bool> checkUsernameAvailability(String username, String userid) async {
    HttpsCallable callable =
        _functions.httpsCallable('checkUsernameAvailability');
    final results = await callable({
      'username': username,
      'userId': userid,
    });

    print(results.data.toString());

    return results.data;
  }
}
