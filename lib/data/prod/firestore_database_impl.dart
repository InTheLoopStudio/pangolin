import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:georange/georange.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/comment.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/service.dart';
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
final _bookingsRef = _firestore.collection('bookings');
final _servicesRef = _firestore.collection('services');

const verifiedBadgeId = '0aa46576-1fbe-4312-8b69-e2fef3269083';

const commentsSubcollection = 'loopComments';
const likesSubcollection = 'loopLikes';
const feedSubcollection = 'userFeed';

/// Database implementation using Firebase's FirestoreDB
class FirestoreDatabaseImpl extends DatabaseRepository {
  String _getFileFromURL(String fileURL) {
    final fSlashes = fileURL.split('/');
    final fQuery = fSlashes[fSlashes.length - 1].split('?');
    final segments = fQuery[0].split('%2F');
    final fileName = segments.join('/');

    return fileName;
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
    if (userQuery.docs.isNotEmpty && userQuery.docs.first.id != userid) {
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

    final usernameAvailable = await checkUsernameAvailability(
      user.username.toString(),
      user.id,
    );
    if (!usernameAvailable) {
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
  Future<UserModel?> getUserById(
    String userId, {
    bool ignoreCache = true,
  }) async {
    DocumentSnapshot<Map<String, dynamic>>? userSnapshot;
    if (!ignoreCache) {
      try {
        userSnapshot = await _usersRef.doc(userId).get(
              const GetOptions(source: Source.cache),
            );
      } on FirebaseException {
        userSnapshot = await _usersRef.doc(userId).get();
      }
    }

    userSnapshot ??= await _usersRef.doc(userId).get();

    if (!userSnapshot.exists) {
      return null;
    }

    final user = UserModel.fromDoc(userSnapshot);

    return user;
  }

  @override
  Future<List<UserModel>> searchUsersByLocation({
    required double lat,
    required double lng,
    int radiusInMeters = 100 * 1000, // 100km
    int limit = 100,
    String? lastUserId,
  }) async {
    final range = getGeohashRange(
      latitude: lat,
      longitude: lng,
      distance: radiusInMeters ~/ 1000,
    );

    if (lastUserId != null) {
      final documentSnapshot = await _usersRef.doc(lastUserId).get();

      final usersSnapshot = await _usersRef
          .orderBy('geohash')
          .where('geohash', isGreaterThanOrEqualTo: range.lower)
          .where('geohash', isLessThanOrEqualTo: range.upper)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      if (usersSnapshot.docs.isEmpty) {
        return [];
      }

      final usersWithFP = usersSnapshot.docs.map(UserModel.fromDoc).toList();

      final users = usersWithFP
          .map((user) {
            if (user.lat == null || user.lng == null) {
              return null;
            }

            // We have to filter out a few false positives due to GeoHash
            // accuracy, but most will match
            final distanceInKm = geoDistance(
              Point(latitude: user.lat!, longitude: user.lng!),
              Point(latitude: lat, longitude: lng),
            );

            final distanceInM = distanceInKm * 1000;
            if (distanceInM > radiusInMeters) {
              return null;
            }

            return user;
          })
          .where((e) => e != null)
          .whereType<UserModel>()
          .toList();

      return users;
    } else {
      final usersSnapshot = await _usersRef
          .orderBy('geohash')
          .where('geohash', isGreaterThanOrEqualTo: range.lower)
          .where('geohash', isLessThanOrEqualTo: range.upper)
          .limit(limit)
          .get();

      if (usersSnapshot.docs.isEmpty) {
        return [];
      }

      final usersWithFP = usersSnapshot.docs.map(UserModel.fromDoc).toList();

      final users = usersWithFP
          .map((user) {
            if (user.lat == null || user.lng == null) {
              return null;
            }

            // We have to filter out a few false positives due to GeoHash
            // accuracy, but most will match
            final distanceInKm = geoDistance(
              Point(latitude: user.lat!, longitude: user.lng!),
              Point(latitude: lat, longitude: lng),
            );

            final distanceInM = distanceInKm * 1000;
            if (distanceInM > radiusInMeters) {
              return null;
            }

            return user;
          })
          .where((e) => e != null)
          .whereType<UserModel>()
          .toList();

      return users;
    }
  }

  @override
  Future<Loop> getLoopById(
    String loopId, {
    bool ignoreCache = true,
  }) async {
    DocumentSnapshot<Map<String, dynamic>>? loopSnapshot;
    if (!ignoreCache) {
      try {
        loopSnapshot = await _loopsRef.doc(loopId).get(
              const GetOptions(source: Source.cache),
            );
      } on FirebaseException {
        loopSnapshot = await _usersRef.doc(loopId).get();
      }
    }

    loopSnapshot ??= await _loopsRef.doc(loopId).get();

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
    final isUsernameAvailable =
        await checkUsernameAvailability(user.username.toString(), user.id);
    if (!isUsernameAvailable) {
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
      name: 'create_loop',
      parameters: {
        'user_id': loop.userId,
        'loop_id': loop.id,
      },
    );
    await _loopsRef.doc(loop.id).set(loop.toMap());
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
      'imagePaths': FieldValue.delete(),
      'title': '*deleted*',
      'deleted': true,
    });

    await _usersRef.doc(loop.userId).update({
      'loopsCount': FieldValue.increment(-1),
    });

    if (loop.audioPath.isNotEmpty) {
      // *delete loops keyed at refFromURL(loop.audioPath)*
      await _storage.child(_getFileFromURL(loop.audioPath)).delete();
    }

    for (final imagePath in loop.imagePaths) {
      // *delete images keyed at refFromURL(imagePath)*
      if (imagePath.isNotEmpty) {
        await _storage.child(_getFileFromURL(imagePath)).delete();
      }
    }
  }

  @override
  Future<List<Loop>> getUserLoops(
    String userId, {
    int limit = 100,
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
          .map(Loop.fromDoc)
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
          .map(Loop.fromDoc)
          .where((loop) => loop.deleted != true)
          .toList();

      return userLoops;
    }
  }

  @override
  Stream<Loop> userLoopsObserver(
    String userId, {
    int limit = 100,
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
      (value) => Stream.fromIterable(value).where(
        (loop) => !loop.deleted,
      ),
    );

    yield* userLoopsObserver;
  }

  @override
  Future<List<Loop>> getFollowingLoops(
    String currentUserId, {
    int limit = 100,
    String? lastLoopId,
    bool ignoreCache = true,
  }) async {
    if (lastLoopId != null) {
      final documentSnapshot = await _loopsRef.doc(lastLoopId).get();

      final userFeedLoops = await _feedRefs
          .doc(currentUserId)
          .collection(feedSubcollection)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .startAfterDocument(documentSnapshot)
          .get();

      final followingLoops = await Future.wait(
        userFeedLoops.docs.map((doc) async {
          final loop = await getLoopById(doc.id, ignoreCache: ignoreCache);

          return loop;
        }),
      );

      return followingLoops.where((loop) => !loop.deleted).toList();
    } else {
      final userFeedLoops = await _feedRefs
          .doc(currentUserId)
          .collection(feedSubcollection)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      final followingLoops = await Future.wait(
        userFeedLoops.docs.map((doc) async {
          final loop = await getLoopById(doc.id, ignoreCache: ignoreCache);

          return loop;
        }),
      );

      return followingLoops.where((loop) => !loop.deleted).toList();
    }
  }

  @override
  Stream<Loop> followingLoopsObserver(
    String currentUserId, {
    int limit = 100,
    bool ignoreCache = true,
  }) async* {
    final userFeedLoopsSnapshotObserver = _feedRefs
        .doc(currentUserId)
        .collection(feedSubcollection)
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
        final loop = await getLoopById(
          element.doc.id,
          ignoreCache: ignoreCache,
        );
        return loop;
        // if (element.type == DocumentChangeType.modified) {}
        // if (element.type == DocumentChangeType.removed) {}
      });
    }).flatMap(
      (value) => Stream.fromFutures(value).where((loop) => !loop.deleted),
    );

    yield* userFeedLoopsObserver;
  }

  @override
  Future<List<Loop>> getAllLoops(
    String currentUserId, {
    bool ignoreCache = true,
    int limit = 100,
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
          .where((e) => e.userId != currentUserId && !e.deleted)
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
    int limit = 100,
    bool ignoreCache = true,
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
        (loop) => loop.userId != currentUserId && !loop.deleted,
      ),
    );

    yield* allLoopsObserver;
  }

  @override
  Future<void> addLike(
    String currentUserId,
    String loopId,
  ) async {
    await _analytics.logEvent(
      name: 'like',
      parameters: {
        'user_id': currentUserId,
        'loop_id': loopId,
      },
    );

    await _likesRef
        .doc(loopId)
        .collection(likesSubcollection)
        .doc(currentUserId)
        .set({});
  }

  @override
  Future<void> deleteLike(
    String currentUserId,
    String loopId,
  ) async {
    await _analytics.logEvent(
      name: 'unlike',
      parameters: {
        'user_id': currentUserId,
        'loop_id': loopId,
      },
    );

    await _likesRef
        .doc(loopId)
        .collection(likesSubcollection)
        .doc(currentUserId)
        .delete();
  }

  @override
  Future<bool> isLiked(
    String currentUserId,
    String loopId,
  ) async {
    final userDoc = await _likesRef
        .doc(loopId)
        .collection(likesSubcollection)
        .doc(currentUserId)
        .get();

    return userDoc.exists;
  }

  @override
  Future<List<UserModel>> getLikes(
    String loopId,
  ) async {
    final likesSnapshot =
        await _likesRef.doc(loopId).collection(likesSubcollection).get();

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
    int limit = 100,
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

      final activities = activitiesSnapshot.docs.map(Activity.fromDoc).toList();

      return activities;
    } else {
      final activitiesSnapshot = await _activitiesRef
          .orderBy('timestamp', descending: true)
          .where('toUserId', isEqualTo: userId)
          .limit(limit)
          .get();

      final activities = activitiesSnapshot.docs.map(Activity.fromDoc).toList();

      return activities;
    }
  }

  @override
  Stream<Activity> activitiesObserver(
    String userId, {
    int limit = 100,
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
    }).flatMap(Stream.fromIterable);

    yield* activitiesObserver;
  }

  @override
  Future<void> addActivity({
    required String currentUserId,
    required ActivityType type,
    required String visitedUserId,
    Loop? loop,
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
        'activity_id': activity.id,
      },
    );
    await _activitiesRef.doc(activity.id).update({
      'markedRead': true,
    });
  }

  @override
  Future<List<Comment>> getComments(
    String rootId, {
    int limit = 100,
  }) async {
    final commentsSnapshot = await _commentsRef
        .doc(rootId)
        .collection(commentsSubcollection)
        .orderBy('timestamp')
        // .where('parentId', isNull: true) // Needed for threaded comments
        .limit(limit)
        .get();

    final comments = commentsSnapshot.docs.map(Comment.fromDoc).toList();

    return comments;
  }

  @override
  Stream<Comment> commentsObserver(
    String rootId, {
    int limit = 100,
  }) async* {
    final commentsSnapshotObserver = _commentsRef
        .doc(rootId)
        .collection(commentsSubcollection)
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
    }).flatMap(Stream.fromIterable);

    yield* commentsObserver;
  }

  @override
  Future<Comment> getComment(
    String rootId,
    String commentId,
  ) async {
    final commentSnapshot = await _commentsRef
        .doc(rootId)
        .collection(commentsSubcollection)
        .doc(commentId)
        .get();

    final comment = Comment.fromDoc(commentSnapshot);

    return comment;
  }

  @override
  Future<void> addComment(
    Comment comment,
  ) async {
    await _analytics.logEvent(
      name: 'new_comment',
      parameters: {
        'root_id': comment.rootId,
        'user_id': comment.userId,
      },
    );

    await _commentsRef
        .doc(comment.rootId)
        .collection(commentsSubcollection)
        .add({
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
  Future<bool> isVerified(
    String userId, {
    bool ignoreCache = true,
  }) async {
    final options = ignoreCache
        ? const GetOptions(source: Source.server)
        : const GetOptions(source: Source.cache);

    try {
      final verifiedBadgeSentDoc = await _badgesSentRef
          .doc(userId)
          .collection('badges')
          .doc(verifiedBadgeId)
          .get(
            options,
          );

      final isVerified = verifiedBadgeSentDoc.exists;

      return isVerified;
    } on FirebaseException {
      return false;
    }
  }

  @override
  Future<void> createBadge(Badge badge) async {
    await _analytics.logEvent(
      name: 'create_badge',
      parameters: {
        'badge_id': badge.id,
        'creator_id': badge.creatorId,
      },
    );
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
    await _analytics.logEvent(
      name: 'send_badge',
      parameters: {
        'badge_id': badgeId,
        'receiver_id': receiverId,
      },
    );

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
    int limit = 100,
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
    }).flatMap(Stream.fromIterable);

    yield* userCreatedBadgesObserver;
  }

  @override
  Stream<Badge> userBadgesObserver(
    String userId, {
    int limit = 100,
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
        // print('BADGE ID { $badgeId }');
        final badgeSnapshot = await _badgesRef.doc(badgeId).get();
        return Badge.fromDoc(badgeSnapshot);
      });
    }).flatMap(Stream.fromIterable);

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
    int limit = 100,
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

      final userCreatedBadges =
          userCreatedBadgesSnapshot.docs.map(Badge.fromDoc).toList();
      return userCreatedBadges;
    } else {
      final userCreatedBadgesSnapshot = await _badgesRef
          .orderBy('timestamp', descending: true)
          .where('creatorId', isEqualTo: userId)
          .limit(limit)
          .get();

      final userCreatedBadges =
          userCreatedBadgesSnapshot.docs.map(Badge.fromDoc).toList();

      return userCreatedBadges;
    }
  }

  @override
  Future<List<Badge>> getUserBadges(
    String userId, {
    int limit = 100,
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
          final badgeId = doc.id;
          final badgeSnapshot = await _badgesRef.doc(badgeId).get();
          return Badge.fromDoc(badgeSnapshot);
        }).toList(),
      );
      return userBadges;
    }
  }

  @override
  Future<void> createBooking(
    Booking booking,
  ) async {
    await _analytics.logEvent(
      name: 'booking_created',
      parameters: {
        'requester_id': booking.requesterId,
        'requestee_id': booking.requesteeId,
        'rate': booking.rate,
        'total': booking.totalCost,
        'booking_id': booking.id,
      },
    );
    await _bookingsRef.doc(booking.id).set(booking.toMap());
  }

  @override
  Future<Booking?> getBookingById(
    String bookRequestId,
  ) async {
    final bookingSnapshot = await _bookingsRef.doc(bookRequestId).get();
    final bookingRequest = Booking.fromDoc(bookingSnapshot);

    return bookingRequest;
  }

  @override
  Future<List<Booking>> getBookingsByRequesterRequestee(
    String requesterId,
    String requesteeId, {
    int limit = 20,
    String? lastBookingRequestId,
  }) async {
    final bookingSnapshot = await _bookingsRef
        .where(
          'requesterId',
          isEqualTo: requesterId,
        )
        .where(
          'requesteeId',
          isEqualTo: requesteeId,
        )
        .get();

    final bookingRequests = bookingSnapshot.docs.map(Booking.fromDoc).toList();

    return bookingRequests;
  }

  @override
  Future<List<Booking>> getBookingsByRequester(
    String userId, {
    int limit = 20,
    String? lastBookingRequestId,
  }) async {
    final bookingSnapshot = await _bookingsRef
        .where(
          'requesterId',
          isEqualTo: userId,
        )
        .get();

    final bookingRequests = bookingSnapshot.docs.map(Booking.fromDoc).toList();

    return bookingRequests;
  }

  @override
  Future<List<Booking>> getBookingsByRequestee(
    String userId, {
    int limit = 20,
    String? lastBookingRequestId,
  }) async {
    final bookingSnapshot = await _bookingsRef
        .where(
          'requesteeId',
          isEqualTo: userId,
        )
        .get();

    final bookingRequests = bookingSnapshot.docs.map(Booking.fromDoc).toList();

    return bookingRequests;
  }

  @override
  Future<void> updateBooking(Booking booking) async {
    await _analytics.logEvent(
      name: 'update_booking',
      parameters: {
        'status': EnumToString.convertToString(booking.status),
      },
    );
    await _bookingsRef.doc(booking.id).set(booking.toMap());
  }

  @override
  Future<void> createService(Service service) async {
    await _analytics.logEvent(
      name: 'service_created',
      parameters: {
        'service_id': service.id,
        'user_id': service.userId,
        'title': service.title,
        'description': service.description,
        'rate': service.rate,
        'rate_type': service.rateType.name,
      },
    );
    await _servicesRef
        .doc(service.userId)
        .collection('userServices')
        .doc(service.id)
        .set(service.toJson());
  }

  @override
  Future<void> deleteService(String userId, String serviceId) async {
    await _analytics.logEvent(
      name: 'service_deleted',
    );
    await _servicesRef
        .doc(userId)
        .collection('userServices')
        .doc(serviceId)
        .set({
      'deleted': true,
    });
    return;
  }

  @override
  Future<Service?> getServiceById(String userId, String serviceId) async {
    final serviceSnapshot = await _servicesRef
        .doc(userId)
        .collection('userServices')
        .doc(serviceId)
        .get();

    final service = Service.fromDoc(serviceSnapshot);

    return service;
  }

  @override
  Future<List<Service>> getUserServices(String userId) async {
    try {
      final userServicesSnapshot =
          await _servicesRef.doc(userId).collection('userServices').get();

      final services = userServicesSnapshot.docs.map(Service.fromDoc).toList();

      return services;
    } on Exception {
      // print(e);
      return [];
    }
  }

  @override
  Future<void> updateService(Service service) async {
    await _analytics.logEvent(
      name: 'service_updated',
      parameters: service.toJson(),
    );
    await _servicesRef
        .doc(service.userId)
        .collection('userServices')
        .doc(service.id)
        .set(service.toJson());
  }
}

class HandleAlreadyExistsException implements Exception {
  HandleAlreadyExistsException(this.cause);
  String cause;
}
