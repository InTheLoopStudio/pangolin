import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/domains/models/comment.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/post.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils.dart';
import 'package:rxdart/rxdart.dart';

final _storage = FirebaseStorage.instance.ref();
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
final _badgesSentRef = _firestore.collection('badgesSent');
final _postsRef = _firestore.collection('posts');

class HandleAlreadyExistsException implements Exception {
  HandleAlreadyExistsException(this.cause);
  String cause;
}

/// Database implementation using Firebase's FirestoreDB
class FirestoreDatabaseImpl extends DatabaseRepository {
  String _getFileFromURL(String fileURL) {
    final fSlashes = fileURL.split('/');
    final fQuery = fSlashes[fSlashes.length - 1].split('?');
    final segments = fQuery[0].split('%2F');
    final fileName = segments.join('/');

    return fileName;
  }

  String _getLikesSubcollectionFromEntityType(EntityType entityType) {
    const loopLikesSubcollection = 'loopLikes';
    const postLikesSubcollection = 'postLikes';

    switch (entityType) {
      case EntityType.loop:
        return loopLikesSubcollection;
      case EntityType.post:
        return postLikesSubcollection;
    }
  }

  String _getCommentsSubcollectionFromEntityType(EntityType entityType) {
    const loopCommentsSubcollection = 'loopComments';
    const postCommentsSubcollection = 'postComments';

    switch (entityType) {
      case EntityType.loop:
        return loopCommentsSubcollection;
      case EntityType.post:
        return postCommentsSubcollection;
    }
  }

  String _getFeedsSubcollectionFromEntityType(EntityType entityType) {
    const loopsFeedSubcollection = 'userFeed';
    const postsFeedSubcollection = 'userPostsFeed';

    switch (entityType) {
      case EntityType.loop:
        return loopsFeedSubcollection;
      case EntityType.post:
        return postsFeedSubcollection;
    }
  }

  // true if username available, false otherwise
  @override
  Future<bool> checkUsernameAvailability(
    String username,
    String userid,
  ) async {
    final blacklist = ['anonymous', '*deleted*'];

    final reserverd = [
      'mictheplug',
      'bobbyshmurda',
      'aboogie',
      'teegrizley',
      'loganpaul',
      'mikemajlak',
      'keyglock',
      'mrbeast',
      'keemokazi',
    ];

    if (blacklist.contains(username) || reserverd.contains(username)) {
      // print('''
      //   username check for blacklisted item:
      //     userId: ${data.userId},
      //     username: ${data.username}
      // ''');
      return false;
    }

    final userQuery =
        await _usersRef.where('username', isEqualTo: username).get();
    if (userQuery.docs.isNotEmpty && userQuery.docs[0].id != userid) {
      // print('''
      //   username check for already taken username:
      //     userId: ${data.userId},
      //     username: ${data.username}
      // ''');
      return false;
    }

    // print('''
    //   username check for available username:
    //     userId: ${data.userId},
    //     username: ${data.username}
    // ''');
    return true;
  }

  @override
  Future<bool> userEmailExists(String email) async {
    final userSnapshot = await _usersRef.where('email', isEqualTo: email).get();

    return userSnapshot.docs.isNotEmpty;
  }

  @override
  Future<void> createUser(UserModel user) async {
    await _analytics.logEvent(name: 'onboarding_user');

    final userAlreadyExists = (await _usersRef.doc(user.id).get()).exists;
    if (userAlreadyExists) {
      return;
    }

    if (await checkUsernameAvailability(user.username, user.id)) {
      throw HandleAlreadyExistsException('username availability check failed');
    }

    await _usersRef.doc(user.id).set(user.toMap());
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
  Future<UserModel?> getUserById(String userId) async {
    final userSnapshot = await _usersRef.doc(userId).get();
    if (!userSnapshot.exists) {
      return null;
    }

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
    await _analytics.logEvent(name: 'user_data_update');
    if (await checkUsernameAvailability(user.username, user.id)) {
      throw HandleAlreadyExistsException('username availability check failed');
    }

    await _usersRef.doc(user.id).set(user.toMap());
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
    final followingDoc = await _followingRef
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .get();

    if (followingDoc.exists) {
      return;
    }

    await _followingRef
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .set({});
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
    final doc = await _followingRef
        .doc(currentUserId)
        .collection('Following')
        .doc(visitedUserId)
        .get();

    if (!doc.exists) {
      return;
    }

    await doc.reference.delete();
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
  Future<void> addLoop(Loop loop) async {
    await _analytics.logEvent(
      name: 'upload_loop',
      parameters: {
        'user_id': loop.userId,
        'loop_id': loop.id,
      },
    );
    await _loopsRef.add(loop.toMap());
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

    await _loopsRef.doc(loop.id).update({
      'audioPath': FieldValue.delete(),
      'commentCount': FieldValue.delete(),
      'likeCount': FieldValue.delete(),
      'tags': FieldValue.delete(),
      'timestamp': FieldValue.delete(),
      'title': '*deleted*',
      'deleted': true,
    });

    await _usersRef.doc(loop.userId).update({
      'loopsCount': FieldValue.increment(-1),
    });

    // *delete loops keyed at refFromURL(loop.audioPath)*
    await _storage.child(_getFileFromURL(loop.audioPath)).delete();
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

      final userLoops = userLoopsSnapshot.docs
          .map((doc) => Loop.fromDoc(doc))
          .where((loop) => loop.deleted != true)
          .toList();

      return userLoops;
    } else {
      final userLoopsSnapshot = await _loopsRef
          .orderBy('timestamp', descending: true)
          .where('userId', isEqualTo: userId)
          .limit(limit)
          .get();

      final userLoops = userLoopsSnapshot.docs
          .map((doc) => Loop.fromDoc(doc))
          .where((loop) => loop.deleted != true)
          .toList();

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
    final subcollection = _getFeedsSubcollectionFromEntityType(EntityType.post);

    if (lastLoopId != null) {
      final documentSnapshot = await _loopsRef.doc(lastLoopId).get();

      final userFeedLoops = await _feedRefs
          .doc(currentUserId)
          .collection(subcollection)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      final followingLoops = await Future.wait(
        userFeedLoops.docs.map((doc) async {
          final loop = await getLoopById(doc.id);
          return loop;
        }),
      );

      return followingLoops.where((loop) => loop.deleted != true).toList();
    } else {
      final userFeedLoops = await _feedRefs
          .doc(currentUserId)
          .collection(subcollection)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      final followingLoops = await Future.wait(
        userFeedLoops.docs.map((doc) async {
          final loop = await getLoopById(doc.id);
          return loop;
        }),
      );

      return followingLoops.where((loop) => loop.deleted != true).toList();
    }
  }

  @override
  Stream<Loop> followingLoopsObserver(
    String currentUserId, {
    int limit = 20,
  }) async* {
    final subcollection = _getFeedsSubcollectionFromEntityType(EntityType.loop);

    final userFeedLoopsSnapshotObserver = _feedRefs
        .doc(currentUserId)
        .collection(subcollection)
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
        final loop = await getLoopById(element.doc.id);
        return loop;
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
  Future<void> addLike(
    String currentUserId,
    String entityId,
    EntityType entityType,
  ) async {
    await _analytics.logEvent(
      name: 'like',
      parameters: {
        'user_id': currentUserId,
        'entity_id': entityId,
      },
    );

    final subcollection = _getLikesSubcollectionFromEntityType(entityType);

    await _likesRef
        .doc(entityId)
        .collection(subcollection)
        .doc(currentUserId)
        .set({});
  }

  @override
  Future<void> deleteLike(
    String currentUserId,
    String entityId,
    EntityType entityType,
  ) async {
    await _analytics.logEvent(
      name: 'unlike',
      parameters: {
        'user_id': currentUserId,
        'entity_id': entityId,
      },
    );

    final subcollection = _getLikesSubcollectionFromEntityType(entityType);

    await _likesRef
        .doc(entityId)
        .collection(subcollection)
        .doc(currentUserId)
        .delete();
  }

  @override
  Future<bool> isLiked(
    String currentUserId,
    String entityId,
    EntityType entityType,
  ) async {
    final subcollection = _getLikesSubcollectionFromEntityType(entityType);

    final userDoc = await _likesRef
        .doc(entityId)
        .collection(subcollection)
        .doc(currentUserId)
        .get();

    return userDoc.exists;
  }

  @override
  Future<List<UserModel>> getLikes(
    String entityId,
    EntityType entityType,
  ) async {
    final subcollection = _getLikesSubcollectionFromEntityType(entityType);

    final likesSnapshot =
        await _likesRef.doc(entityId).collection(subcollection).get();

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
      final documentSnapshot = await _activitiesRef.doc(lastActivityId).get();

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

    await _activitiesRef.add({
      'toUserId': visitedUserId,
      'fromUserId': currentUserId,
      'timestamp': Timestamp.now(),
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
    await _activitiesRef.doc(activity.id).update({
      'markedRead': true,
    });
  }

  @override
  Future<List<Comment>> getComments(
    String rootId,
    EntityType rootType, {
    int limit = 20,
  }) async {
    final subcollection = _getCommentsSubcollectionFromEntityType(rootType);

    final commentsSnapshot = await _commentsRef
        .doc(rootId)
        .collection(subcollection)
        .orderBy('timestamp')
        // .where('parentId', isNull: true) // Needed for threaded comments
        .limit(limit)
        .get();

    final comments =
        commentsSnapshot.docs.map((doc) => Comment.fromDoc(doc)).toList();

    return comments;
  }

  @override
  Stream<Comment> commentsObserver(
    String rootId,
    EntityType rootType, {
    int limit = 20,
  }) async* {
    final subcollection = _getCommentsSubcollectionFromEntityType(rootType);

    final commentsSnapshotObserver = _commentsRef
        .doc(rootId)
        .collection(subcollection)
        .orderBy('timestamp')
        .limit(limit)
        // .where('parentId', isNull: true) // Needed for threaded comments
        .snapshots();

    final commentsObserver = commentsSnapshotObserver.map((event) {
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

    yield* commentsObserver;
  }

  @override
  Future<Comment> getComment(
    String rootId,
    EntityType rootType,
    String commentId,
  ) async {
    final subcollection = _getCommentsSubcollectionFromEntityType(rootType);

    final commentSnapshot = await _commentsRef
        .doc(rootId)
        .collection(subcollection)
        .doc(commentId)
        .get();

    final comment = Comment.fromDoc(commentSnapshot);

    return comment;
  }

  @override
  Future<void> addComment(
    Comment comment,
    EntityType rootType,
  ) async {
    await _analytics.logEvent(
      name: 'new_comment',
      parameters: {
        'root_id': comment.rootId,
        'user_id': comment.userId,
      },
    );

    final subcollection = _getCommentsSubcollectionFromEntityType(rootType);

    await _commentsRef.doc(comment.rootId).collection(subcollection).add({
      'userId': comment.userId,
      'timestamp': Timestamp.now(),
      'content': comment.content,
      'parentId': comment.parentId,
      'rootId': comment.rootId,
      'children': comment.children,
      'deleted': false,
    });
  }

  // Future<List<Tag>> getTagSuggestions(String query) async {
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

    await _loopsRef.doc(loop.id).update({
      'shares': FieldValue.increment(1),
    });
  }

  @override
  Future<void> createBadge(Badge badge) async {
    await _analytics.logEvent(name: 'create_badge');
    await _badgesRef.doc(badge.id).set({
      'name': badge.name,
      'description': badge.description,
      'creatorId': badge.creatorId,
      'imageUrl': badge.imageUrl,
      'timestamp': Timestamp.now(),
    });
  }

  @override
  Future<void> sendBadge(String badgeId, String receiverId) async {
    await _analytics.logEvent(name: 'create_badge');

    await _badgesSentRef.doc(receiverId).collection('badges').doc(badgeId).set({
      'timestamp': Timestamp.now(),
    });

    await _usersRef
        .doc(receiverId)
        .update({'badgesCount': FieldValue.increment(1)});
  }

  @override
  Stream<Badge> userCreatedBadgesObserver(
    String userId, {
    int limit = 20,
  }) async* {
    final userCreatedBadgesSnapshotObserver = _badgesRef
        .where('creatorId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();

    final userCreatedBadgesObserver =
        userCreatedBadgesSnapshotObserver.map((event) {
      return event.docChanges
          .where(
        (DocumentChange<Map<String, dynamic>> element) =>
            element.type == DocumentChangeType.added,
      )
          .map((DocumentChange<Map<String, dynamic>> element) {
        return Badge.fromDoc(element.doc);
      });
    }).flatMap((value) => Stream.fromIterable(value));

    yield* userCreatedBadgesObserver;
  }

  @override
  Stream<Badge> userBadgesObserver(
    String userId, {
    int limit = 20,
  }) async* {
    final userBadgesSnapshotObserver = _badgesSentRef
        .doc(userId)
        .collection('badges')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();

    final userBadgesObserver = userBadgesSnapshotObserver.map((event) {
      return event.docChanges
          .where(
        (DocumentChange<Map<String, dynamic>> element) =>
            element.type == DocumentChangeType.added,
      )
          .map((DocumentChange<Map<String, dynamic>> element) async {
        final badgeId = element.doc.id;
        final badgeSnapshot = await _badgesRef.doc(badgeId).get();
        return Badge.fromDoc(badgeSnapshot);
      });
    }).flatMap((value) => Stream.fromIterable(value));

    await for (final badge in userBadgesObserver) {
      try {
        yield await badge;
      } catch (error, stack) {
        yield* Stream.error(error, stack);
      }
    }
  }

  @override
  Future<List<Badge>> getUserCreatedBadges(
    String userId, {
    int limit = 20,
    String? lastBadgeId,
  }) async {
    if (lastBadgeId != null) {
      final documentSnapshot = await _badgesRef.doc(lastBadgeId).get();

      final userCreatedBadgesSnapshot = await _badgesRef
          .orderBy('timestamp', descending: true)
          .where('creatorId', isEqualTo: userId)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      final userCreatedBadges = userCreatedBadgesSnapshot.docs
          .map((doc) => Badge.fromDoc(doc))
          .toList();
      return userCreatedBadges;
    } else {
      final userCreatedBadgesSnapshot = await _badgesRef
          .orderBy('timestamp', descending: true)
          .where('creatorId', isEqualTo: userId)
          .limit(limit)
          .get();

      final userCreatedBadges = userCreatedBadgesSnapshot.docs
          .map((doc) => Badge.fromDoc(doc))
          .toList();

      return userCreatedBadges;
    }
  }

  @override
  Future<List<Badge>> getUserBadges(
    String userId, {
    int limit = 20,
    String? lastBadgeId,
  }) async {
    if (lastBadgeId != null) {
      final documentSnapshot = await _badgesSentRef
          .doc(userId)
          .collection('badges')
          .doc(lastBadgeId)
          .get();

      final userBadgesSnapshot = await _badgesSentRef
          .doc(userId)
          .collection('badges')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      final userBadges = Future.wait(
        userBadgesSnapshot.docs.map((doc) async {
          final badgeId = doc.getOrElse('badgeId', '') as String;
          final badgeSnapshot = await _badgesRef.doc(badgeId).get();
          return Badge.fromDoc(badgeSnapshot);
        }).toList(),
      );
      return userBadges;
    } else {
      final userBadgesSnapshot = await _badgesSentRef
          .doc(userId)
          .collection('badges')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      final userBadges = Future.wait(
        userBadgesSnapshot.docs.map((doc) async {
          final badgeId = doc.getOrElse('badgeId', '') as String;
          final badgeSnapshot = await _badgesRef.doc(badgeId).get();
          return Badge.fromDoc(badgeSnapshot);
        }).toList(),
      );
      return userBadges;
    }
  }

  @override
  Future<Post> getPostById(String postId) async {
    final postSnapshot = await _postsRef.doc(postId).get();
    final post = Post.fromDoc(postSnapshot);
    return post;
  }

  @override
  Future<void> addPost(Post post) async {
    await _analytics.logEvent(
      name: 'upload_post',
      parameters: {
        'user_id': post.userId,
        'post_id': post.id,
      },
    );
    await _postsRef.add(post.toMap());
  }

  @override
  Future<void> deletePost(Post post) async {
    await _analytics.logEvent(
      name: 'delete_post',
      parameters: {
        'user_id': post.userId,
        'post_id': post.id,
      },
    );

    await _postsRef.doc(post.id).update({
      'description': FieldValue.delete(),
      'commentCount': FieldValue.delete(),
      'likeCount': FieldValue.delete(),
      'tags': FieldValue.delete(),
      'timestamp': FieldValue.delete(),
      'title': '*deleted*',
      'deleted': true,
    });
  }

  @override
  Future<List<Post>> getUserPost(
    String userId, {
    int limit = 20,
    String? lastPostId,
  }) async {
    if (lastPostId != null) {
      final documentSnapshot = await _postsRef.doc(lastPostId).get();

      final userPostsSnapshot = await _postsRef
          .orderBy('timestamp', descending: true)
          .where('userId', isEqualTo: userId)
          // .where('deleted', isNotEqualTo: true)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      final userPosts = userPostsSnapshot.docs
          .map((doc) => Post.fromDoc(doc))
          .where((post) => post.deleted != true)
          .toList();

      return userPosts;
    } else {
      final userPostsSnapshot = await _postsRef
          .orderBy('timestamp', descending: true)
          .where('userId', isEqualTo: userId)
          .limit(limit)
          .get();

      final userPosts = userPostsSnapshot.docs
          .map((doc) => Post.fromDoc(doc))
          .where((post) => post.deleted != true)
          .toList();

      return userPosts;
    }
  }

  @override
  Stream<Post> userPostsObserver(
    String userId, {
    int limit = 20,
  }) async* {
    final userPostsSnapshotObserver = _postsRef
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        // .where('deleted', isNotEqualTo: true)
        .limit(limit)
        .snapshots();

    final userPostsObserver = userPostsSnapshotObserver.map((event) {
      return event.docChanges
          .where(
        (DocumentChange<Map<String, dynamic>> element) =>
            element.type == DocumentChangeType.added,
      )
          .map((DocumentChange<Map<String, dynamic>> element) {
        return Post.fromDoc(element.doc);
        // if (element.type == DocumentChangeType.modified) {}
        // if (element.type == DocumentChangeType.removed) {}
      });
    }).flatMap(
      (value) =>
          Stream.fromIterable(value).where((post) => post.deleted != true),
    );

    yield* userPostsObserver;
  }

  @override
  Future<List<Post>> getFollowingPosts(
    String currentUserId, {
    int limit = 20,
    String? lastPostId,
  }) async {
    final subcollection = _getFeedsSubcollectionFromEntityType(EntityType.post);

    if (lastPostId != null) {
      final documentSnapshot = await _postsRef.doc(lastPostId).get();

      final userFeedPosts = await _feedRefs
          .doc(currentUserId)
          .collection(subcollection)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      final followingPosts = await Future.wait(
        userFeedPosts.docs.map((doc) async {
          final post = await getPostById(doc.id);
          return post;
        }),
      );

      return followingPosts.where((post) => post.deleted != true).toList();
    } else {
      final userFeedPosts = await _feedRefs
          .doc(currentUserId)
          .collection(subcollection)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      final followingPosts = await Future.wait(
        userFeedPosts.docs.map((doc) async {
          final post = await getPostById(doc.id);
          return post;
        }),
      );

      return followingPosts.where((post) => post.deleted != true).toList();
    }
  }

  @override
  Stream<Post> followingPostsObserver(
    String currentUserId, {
    int limit = 20,
  }) async* {
    final subcollection = _getFeedsSubcollectionFromEntityType(EntityType.post);

    final userFeedPostsSnapshotObserver = _feedRefs
        .doc(currentUserId)
        .collection(subcollection)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots();

    final userFeedPostsObserver = userFeedPostsSnapshotObserver.map((event) {
      return event.docChanges
          .where(
        (DocumentChange<Map<String, dynamic>> element) =>
            element.type == DocumentChangeType.added,
      )
          .map((DocumentChange<Map<String, dynamic>> element) async {
        final post = await getPostById(element.doc.id);
        return post;
        // if (element.type == DocumentChangeType.modified) {}
        // if (element.type == DocumentChangeType.removed) {}
      });
    }).flatMap(
      (value) =>
          Stream.fromFutures(value).where((post) => post.deleted != true),
    );

    yield* userFeedPostsObserver;
  }

  @override
  Future<List<Post>> getAllPosts(
    String currentUserId, {
    int limit = 20,
    String? lastPostId,
  }) async {
    if (lastPostId != null) {
      final documentSnapshot = await _postsRef.doc(lastPostId).get();

      final allPostsDocs = await _postsRef
          .orderBy('timestamp', descending: true)
          // .where('deleted', isNotEqualTo: true)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      final allPostsList = await Future.wait(
        allPostsDocs.docs.map((doc) async => Post.fromDoc(doc)).toList(),
      );

      return allPostsList
          .where((e) => e.userId != currentUserId && e.deleted != true)
          .toList();
    } else {
      final allPostsDocs = await _postsRef
          .orderBy('timestamp', descending: true)
          // .where('deleted', isNotEqualTo: true)
          .limit(limit)
          .get();

      final allPostsList = await Future.wait(
        allPostsDocs.docs.map((doc) async => Post.fromDoc(doc)).toList(),
      );

      return allPostsList
          .where((e) => e.userId != currentUserId && e.deleted != true)
          .toList();
    }
  }

  @override
  Stream<Post> allPostsObserver(
    String currentUserId, {
    int limit = 20,
  }) async* {
    final allPostsSnapshotObserver = _postsRef
        .orderBy('timestamp', descending: true)
        // .where('deleted', isNotEqualTo: true)
        .limit(limit)
        .snapshots();

    final allPostsObserver = allPostsSnapshotObserver.map((event) {
      return event.docChanges
          .where(
        (DocumentChange<Map<String, dynamic>> element) =>
            element.type == DocumentChangeType.added,
      )
          .map((DocumentChange<Map<String, dynamic>> element) {
        return Post.fromDoc(element.doc);
        // if (element.type == DocumentChangeType.modified) {}
        // if (element.type == DocumentChangeType.removed) {}
      });
    }).flatMap(
      (value) => Stream.fromIterable(value).where(
        (post) => post.userId != currentUserId && post.deleted != true,
      ),
    );

    yield* allPostsObserver;
  }
}
