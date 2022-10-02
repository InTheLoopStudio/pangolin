import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/domains/models/comment.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

final _functions = FirebaseFunctions.instance;
final _firestore = FirebaseFirestore.instance;
final _analytics = FirebaseAnalytics.instance;

final _usersRef = _firestore.collection('users');
final _followersRef = _firestore.collection('followers');
final _followingRef = _firestore.collection('following');
final _loopsRef = _firestore.collection('loops');
final _feedRefs = _firestore.collection('feeds');
final _likesRef = _firestore.collection('likes');
final _activitiesRef = _firestore.collection('activities');
final _commentsRef = _firestore.collection('comments');
final _badgesRef = _firestore.collection('badges');

/// Database implementation using Firebase's FirestoreDB
class FirestoreDatabaseImpl extends DatabaseRepository {
  @override
  Future<bool> userEmailExists(String email) async {
    final userSnapshot = await _usersRef.where('email', isEqualTo: email).get();

    return userSnapshot.docs.isNotEmpty;
  }

  @override
  Future<void> createUser(UserModel user) async {
    await _analytics.logEvent(name: 'sign_up');
    final callable = _functions.httpsCallable('createUser');
    final results = await callable(user.toMap());
  }

  @override
  Future<UserModel?> getUserByUsername(String? username) async {
    if (username == null) return null;

    final userSnapshots =
        await _usersRef.where('username', isEqualTo: username).get();

    if (userSnapshots.docs.isNotEmpty) {
      return UserModel.fromDoc(userSnapshots.docs.first);
    }

    return null;
  }

  @override
  Future<UserModel> getUser(String userId) async {
    final userSnapshot = await _usersRef.doc(userId).get();
    final user = UserModel.fromDoc(userSnapshot);

    return user;
  }

  @override
  Future<Loop> getLoopById(String loopId) async {
    final loopSnapshot = await _loopsRef.doc(loopId).get();

    final loop = Loop.fromDoc(loopSnapshot);

    return loop;
  }

  @override
  Future<int> followersNum(String userid) async {
    final followersSnapshot =
        await _followersRef.doc(userid).collection('Followers').get();

    return followersSnapshot.docs.length;
  }

  @override
  Future<int> followingNum(String userid) async {
    final followingSnapshot =
        await _followingRef.doc(userid).collection('Following').get();

    return followingSnapshot.docs.length;
  }

  @override
  Future<void> updateUserData(UserModel user) async {
    final callable = _functions.httpsCallable('updateUserData');
    await callable<Map<String, dynamic>>(user.toMap());
  }

  @override
  Future<void> followUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    await _analytics.logEvent(
      name: 'follow_user',
      parameters: {
        'follower': currentUserId,
        'followee': visitedUserId,
      },
    );
    final callable = _functions.httpsCallable('followUser');
    await callable<Map<String, dynamic>>({
      'follower': currentUserId,
      'followed': visitedUserId,
    });
  }

  @override
  Future<void> unfollowUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    await _analytics.logEvent(
      name: 'unfollow_user',
      parameters: {
        'follower': currentUserId,
        'followed': visitedUserId,
      },
    );
    final callable = _functions.httpsCallable('unfollowUser');
    await callable<Map<String, dynamic>>({
      'follower': currentUserId,
      'followed': visitedUserId,
    });
  }

  @override
  Future<bool> isFollowingUser(
    String currentUserId,
    String visitedUserId,
  ) async {
    try {
      final followingDoc = await _followersRef
          .doc(visitedUserId)
          .collection('Followers')
          .doc(currentUserId)
          .get();
      return followingDoc.exists;
    } on Exception {
      return false;
    }
  }

  @override
  Future<List<UserModel>> getFollowing(String currentUserId) async {
    final userFollowingSnapshot =
        await _followingRef.doc(currentUserId).collection('Following').get();

    final followingFutures = userFollowingSnapshot.docs.map(
      (doc) async {
        final userDoc = await _usersRef.doc(doc.id).get();
        return UserModel.fromDoc(userDoc);
      },
    ).toList();

    final following = await Future.wait(followingFutures);

    return following;
  }

  @override
  Future<List<UserModel>> getFollowers(String currentUserId) async {
    final userFollowerSnapshot =
        await _followersRef.doc(currentUserId).collection('Followers').get();

    final followerFutures = userFollowerSnapshot.docs.map(
      (doc) async {
        final userDoc = await _usersRef.doc(doc.id).get();
        return UserModel.fromDoc(userDoc);
      },
    ).toList();

    final followers = await Future.wait(followerFutures);

    return followers;
  }

  @override
  Future<void> uploadLoop(Loop loop) async {
    await _analytics.logEvent(
      name: 'upload_loop',
      parameters: {
        'user_id': loop.userId,
        'loop_id': loop.id,
      },
    );
    final callable = _functions.httpsCallable('uploadLoop');
    await callable<Map<String, dynamic>>({
      'loopTitle': loop.title,
      'loopAudio': loop.audio,
      'loopUserId': loop.userId,
      'loopLikes': loop.likes,
      'loopDownloads': loop.downloads,
      'loopComments': loop.comments,
      'loopTags': loop.tags,
    });
  }

  @override
  Future<void> deleteLoop(Loop loop) async {
    await _analytics.logEvent(
      name: 'delete_loop',
      parameters: {
        'user_id': loop.userId,
        'loop_id': loop.id,
      },
    );
    final callable = _functions.httpsCallable('deleteLoop');
    final results = await callable({
      'id': loop.id,
      'userId': loop.userId,
    });
  }

  @override
  Future<List<Loop>> getUserLoops(
    String userId, {
    int limit = 20,
    String? lastLoopId,
  }) async {
    if (lastLoopId != null) {
      final documentSnapshot = await _loopsRef.doc(lastLoopId).get();

      final userLoopsSnapshot = await _loopsRef
          .orderBy('timestamp', descending: true)
          .where('userId', isEqualTo: userId)
          // .where('deleted', isNotEqualTo: true)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      var userLoops =
          userLoopsSnapshot.docs.map((doc) => Loop.fromDoc(doc)).toList();

      userLoops = userLoops.where((loop) => loop.deleted != true).toList();

      return userLoops;
    } else {
      final userLoopsSnapshot = await _loopsRef
          .orderBy('timestamp', descending: true)
          .where('userId', isEqualTo: userId)
          .limit(limit)
          .get();

      var userLoops =
          userLoopsSnapshot.docs.map((doc) => Loop.fromDoc(doc)).toList();

      userLoops = userLoops.where((loop) => loop.deleted != true).toList();

      return userLoops;
    }
  }

  @override
  Stream<Loop> userLoopsObserver(
    String userId, {
    int limit = 20,
  }) async* {
    final userLoopsSnapshotObserver = _loopsRef
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        // .where('deleted', isNotEqualTo: true)
        .limit(limit)
        .snapshots();

    final userLoopsObserver = userLoopsSnapshotObserver.map((event) {
      return event.docChanges
          .where(
        (DocumentChange<Map<String, dynamic>> element) =>
            element.type == DocumentChangeType.added,
      )
          .map((DocumentChange<Map<String, dynamic>> element) {
        return Loop.fromDoc(element.doc);
        // if (element.type == DocumentChangeType.modified) {}
        // if (element.type == DocumentChangeType.removed) {}
      });
    }).flatMap(
      (value) =>
          Stream.fromIterable(value).where((loop) => loop.deleted != true),
    );

    yield* userLoopsObserver;
  }

  @override
  Future<List<Loop>> getFollowingLoops(
    String currentUserId, {
    int limit = 20,
    String? lastLoopId,
  }) async {
    if (lastLoopId != null) {
      final documentSnapshot = await _loopsRef.doc(lastLoopId).get();

      final userFeedLoops = await _feedRefs
          .doc(currentUserId)
          .collection('userFeed')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      var followingLoops = await Future.wait(
        userFeedLoops.docs.map((doc) async {
          final loop = await getLoopById(doc.id);
          return loop;
        }),
      );

      followingLoops =
          followingLoops.where((loop) => loop.deleted != true).toList();

      return followingLoops;
    } else {
      final userFeedLoops = await _feedRefs
          .doc(currentUserId)
          .collection('userFeed')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      var followingLoops = await Future.wait(
        userFeedLoops.docs.map((doc) async {
          final loop = await getLoopById(doc.id);
          return loop;
        }),
      );

      followingLoops =
          followingLoops.where((loop) => loop.deleted != true).toList();

      return followingLoops;
    }
  }

  @override
  Stream<Loop> followingLoopsObserver(
    String currentUserId, {
    int limit = 20,
  }) async* {
    final userFeedLoopsSnapshotObserver = _feedRefs
        .doc(currentUserId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();

    final userFeedLoopsObserver = userFeedLoopsSnapshotObserver.map((event) {
      return event.docChanges
          .where(
        (DocumentChange<Map<String, dynamic>> element) =>
            element.type == DocumentChangeType.added,
      )
          .map((DocumentChange<Map<String, dynamic>> element) async {
        return await getLoopById(element.doc.id);
        // if (element.type == DocumentChangeType.modified) {}
        // if (element.type == DocumentChangeType.removed) {}
      });
    }).flatMap(
      (value) =>
          Stream.fromFutures(value).where((loop) => loop.deleted != true),
    );

    yield* userFeedLoopsObserver;
  }

  @override
  Future<List<Loop>> getAllLoops(
    String currentUserId, {
    int limit = 20,
    String? lastLoopId,
  }) async {
    if (lastLoopId != null) {
      final documentSnapshot = await _loopsRef.doc(lastLoopId).get();

      final allLoopsDocs = await _loopsRef
          .orderBy('timestamp', descending: true)
          // .where('deleted', isNotEqualTo: true)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      final allLoopsList = await Future.wait(
        allLoopsDocs.docs.map((doc) async => Loop.fromDoc(doc)).toList(),
      );

      return allLoopsList
          .where((e) => e.userId != currentUserId && e.deleted != true)
          .toList();
    } else {
      final allLoopsDocs = await _loopsRef
          .orderBy('timestamp', descending: true)
          // .where('deleted', isNotEqualTo: true)
          .limit(limit)
          .get();

      final allLoopsList = await Future.wait(
        allLoopsDocs.docs.map((doc) async => Loop.fromDoc(doc)).toList(),
      );

      return allLoopsList
          .where((e) => e.userId != currentUserId && e.deleted != true)
          .toList();
    }
  }

  @override
  Stream<Loop> allLoopsObserver(
    String currentUserId, {
    int limit = 20,
  }) async* {
    final allLoopsSnapshotObserver = _loopsRef
        .orderBy('timestamp', descending: true)
        // .where('deleted', isNotEqualTo: true)
        .limit(limit)
        .snapshots();

    final allLoopsObserver = allLoopsSnapshotObserver.map((event) {
      return event.docChanges
          .where(
        (DocumentChange<Map<String, dynamic>> element) =>
            element.type == DocumentChangeType.added,
      )
          .map((DocumentChange<Map<String, dynamic>> element) {
        return Loop.fromDoc(element.doc);
        // if (element.type == DocumentChangeType.modified) {}
        // if (element.type == DocumentChangeType.removed) {}
      });
    }).flatMap(
      (value) => Stream.fromIterable(value).where(
          (loop) => loop.userId != currentUserId && loop.deleted != true,
        ),
    );

    yield* allLoopsObserver;
  }

  @override
  Future<void> likeLoop(String currentUserId, Loop loop) async {
    await _analytics.logEvent(
      name: 'like_loop',
      parameters: {
        'user_id': currentUserId,
        'loop_id': loop.id,
      },
    );
    final callable = _functions.httpsCallable('likeLoop');
    await callable<Map<String, dynamic>>({
      'currentUserId': currentUserId,
      'loopId': loop.id,
      'loopUserId': loop.userId,
    });
  }

  @override
  Future<void> unlikeLoop(String currentUserId, Loop loop) async {
    await _analytics.logEvent(
      name: 'unlike_loop',
      parameters: {
        'user_id': currentUserId,
        'loop_id': loop.id,
      },
    );
    final callable = _functions.httpsCallable('unlikeLoop');
    await callable<Map<String, dynamic>>({
      'currentUserId': currentUserId,
      'loopId': loop.id,
      'loopUserId': loop.userId,
    });
  }

  @override
  Future<bool> isLikeLoop(String currentUserId, Loop loop) async {
    final userDoc = await _likesRef
        .doc(loop.id)
        .collection('loopLikes')
        .doc(currentUserId)
        .get();

    return userDoc.exists;
  }

  @override
  Future<List<UserModel>> getLikes(Loop loop) async {
    final likesSnapshot =
        await _likesRef.doc(loop.id).collection('loopLikes').get();

    final usersList = await Future.wait(
      likesSnapshot.docs.map((doc) async {
        final userDoc = await _usersRef.doc(doc.id).get();
        return UserModel.fromDoc(userDoc);
      }).toList(),
    );

    return usersList;
  }

  @override
  Future<List<Activity>> getActivities(
    String userId, {
    int limit = 20,
    String? lastActivityId,
  }) async {
    if (lastActivityId != null) {
      final documentSnapshot =
          await _activitiesRef.doc(lastActivityId).get();

      final activitiesSnapshot = await _activitiesRef
          .orderBy('timestamp', descending: true)
          .where('toUserId', isEqualTo: userId)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      final activities =
          activitiesSnapshot.docs.map((doc) => Activity.fromDoc(doc)).toList();

      return activities;
    } else {
      final activitiesSnapshot = await _activitiesRef
          .orderBy('timestamp', descending: true)
          .where('toUserId', isEqualTo: userId)
          .limit(limit)
          .get();

      final activities =
          activitiesSnapshot.docs.map((doc) => Activity.fromDoc(doc)).toList();

      return activities;
    }
  }

  @override
  Stream<Activity> activitiesObserver(
    String userId, {
    int limit = 20,
  }) async* {
    final activitiesSnapshotObserver = _activitiesRef
        .orderBy('timestamp', descending: true)
        .where('toUserId', isEqualTo: userId)
        .limit(limit)
        .snapshots();

    final activitiesObserver = activitiesSnapshotObserver.map((event) {
      return event.docChanges
          .where(
        (DocumentChange<Map<String, dynamic>> element) =>
            element.type == DocumentChangeType.added,
      )
          .map((DocumentChange<Map<String, dynamic>> element) {
        return Activity.fromDoc(element.doc);
        // if (element.type == DocumentChangeType.modified) {}
        // if (element.type == DocumentChangeType.removed) {}
      });
    }).flatMap((value) => Stream.fromIterable(value));

    yield* activitiesObserver;
  }

  @override
  Future<void> addActivity({
    required String currentUserId,
    required ActivityType type,
    Loop? loop,
    required String visitedUserId,
  }) async {
    await _analytics.logEvent(
      name: 'new_activity',
      parameters: {
        'from_user_id': currentUserId,
        'to_user_id': visitedUserId,
        'type': EnumToString.convertToString(type),
      },
    );
    final callable = _functions.httpsCallable('addActivity');
    await callable<Map<String, dynamic>>({
      'toUserId': visitedUserId,
      'fromUserId': currentUserId,
      'type': EnumToString.convertToString(type),
    });
  }

  @override
  Future<void> markActivityAsRead(Activity activity) async {
    await _analytics.logEvent(
      name: 'activity_read',
      parameters: {
        'activity': activity.id,
      },
    );
    final callable = _functions.httpsCallable('markActivityAsRead');
    final results = await callable({
      'id': activity.id,
    });
  }

  @override
  Future<List<Comment>> getLoopComments(
    Loop loop, {
    int limit = 20,
  }) async {
    final loopCommentsSnapshot = await _commentsRef
        .doc(loop.id)
        .collection('loopComments')
        .orderBy('timestamp')
        // .where('parentId', isNull: true) // Needed for threaded comments
        .limit(limit)
        .get();

    final loopComments =
        loopCommentsSnapshot.docs.map((doc) => Comment.fromDoc(doc)).toList();

    return loopComments;
  }

  @override
  Stream<Comment> loopCommentsObserver(
    Loop loop, {
    int limit = 20,
  }) async* {
    final loopCommentsSnapshotObserver = _commentsRef
        .doc(loop.id)
        .collection('loopComments')
        .orderBy('timestamp')
        .limit(limit)
        // .where('parentId', isNull: true) // Needed for threaded comments
        .snapshots();

    final loopCommentsObserver = loopCommentsSnapshotObserver.map((event) {
      return event.docChanges
          .where(
        (DocumentChange<Map<String, dynamic>> element) =>
            element.type == DocumentChangeType.added,
      )
          .map((DocumentChange<Map<String, dynamic>> element) {
        return Comment.fromDoc(element.doc);
        // if (element.type == DocumentChangeType.modified) {}
        // if (element.type == DocumentChangeType.removed) {}
      });
    }).flatMap((value) => Stream.fromIterable(value));

    yield* loopCommentsObserver;
  }

  @override
  Future<Comment> getComment(Loop loop, String commentId) async {
    final commentSnapshot = await _commentsRef
        .doc(loop.id)
        .collection('loopComments')
        .doc(commentId)
        .get();

    final comment = Comment.fromDoc(commentSnapshot);

    return comment;
  }

  @override
  Future<void> addComment(Comment comment, String visitedUserId) async {
    await _analytics.logEvent(
      name: 'new_comment',
      parameters: {
        'root_loop_id': comment.rootLoopId,
        'user_id': comment.userId,
      },
    );
    final callable = _functions.httpsCallable('addComment');
    await callable<Map<String, dynamic>>({
      'visitedUserId': visitedUserId,
      'rootLoopId': comment.rootLoopId ?? '',
      'userId': comment.userId ?? '',
      'content': comment.content ?? '',
      'parentId': comment.parentId ?? '',
      'children': comment.children ?? [],
    });
  }

  // Future<List<Tag>> getTagSuggestions(String query) async {
  //   // TODO: Add suggestions to Firestore?
  //   await Future.delayed(Duration(milliseconds: 0), null);

  //   return <Tag>[]
  //       .where((tag) => tag
  //                .value.toLowerCase().contains(query.toLowerCase()))
  //       .toList();
  // }

  @override
  Future<void> shareLoop(Loop loop) async {
    await _analytics.logShare(
      contentType: 'loop',
      itemId: loop.id,
      method: 'unknown',
    );
    final callable = _functions.httpsCallable('shareLoop');
    await callable<Map<String, dynamic>>({
      'loopId': loop.id,
      'userId': loop.userId,
    });
  }

  @override
  Future<bool> checkUsernameAvailability(String username, String userid) async {
    final callable = _functions.httpsCallable('checkUsernameAvailability');
    final results = await callable({
      'username': username,
      'userId': userid,
    });

    final isAvailable = results.data as bool;

    return isAvailable;
  }

  @override
  Future<void> createBadge(Badge badge) async {
    await _analytics.logEvent(name: 'create_badge');
    final callable = _functions.httpsCallable('createBadge');
    await callable<Map<String, dynamic>>(badge.toMap());
  }

  @override
  Stream<Badge> userBadgesObserver(
    String userId, {
    int limit = 20,
  }) async* {
    final userBadgesSnapshotObserver = _badgesRef
        .where('receiverId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();

    final userBadgesObserver = userBadgesSnapshotObserver.map((event) {
      return event.docChanges
          .where(
        (DocumentChange<Map<String, dynamic>> element) =>
            element.type == DocumentChangeType.added,
      )
          .map((DocumentChange<Map<String, dynamic>> element) {
        return Badge.fromDoc(element.doc);
      });
    }).flatMap((value) => Stream.fromIterable(value));

    yield* userBadgesObserver;
  }

  @override
  Future<List<Badge>> getUserBadges(
    String userId, {
    int limit = 20,
    String? lastBadgeId,
  }) async {
    if (lastBadgeId != null) {
      final documentSnapshot = await _badgesRef.doc(lastBadgeId).get();

      final userBadgesSnapshot = await _badgesRef
          .orderBy('timestamp', descending: true)
          .where('receiverId', isEqualTo: userId)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      final userBadges =
          userBadgesSnapshot.docs.map((doc) => Badge.fromDoc(doc)).toList();
      return userBadges;
    } else {
      final userBadgesSnapshot = await _badgesRef
          .orderBy('timestamp', descending: true)
          .where('receiverId', isEqualTo: userId)
          .limit(limit)
          .get();

      final userBadges =
          userBadgesSnapshot.docs.map((doc) => Badge.fromDoc(doc)).toList();

      return userBadges;
    }
  }
}
