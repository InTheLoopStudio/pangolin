// Mocks generated by Mockito 5.3.2 from annotations
// in intheloopapp/test/ui/likes_cubit_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:intheloopapp/data/database_repository.dart' as _i5;
import 'package:intheloopapp/domains/models/activity.dart' as _i8;
import 'package:intheloopapp/domains/models/badge.dart' as _i9;
import 'package:intheloopapp/domains/models/comment.dart' as _i3;
import 'package:intheloopapp/domains/models/loop.dart' as _i2;
import 'package:intheloopapp/domains/models/post.dart' as _i4;
import 'package:intheloopapp/domains/models/user_model.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeLoop_0 extends _i1.SmartFake implements _i2.Loop {
  _FakeLoop_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeComment_1 extends _i1.SmartFake implements _i3.Comment {
  _FakeComment_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePost_2 extends _i1.SmartFake implements _i4.Post {
  _FakePost_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [DatabaseRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabaseRepository extends _i1.Mock
    implements _i5.DatabaseRepository {
  MockDatabaseRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<bool> userEmailExists(String? email) => (super.noSuchMethod(
        Invocation.method(
          #userEmailExists,
          [email],
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
  @override
  _i6.Future<void> createUser(_i7.UserModel? user) => (super.noSuchMethod(
        Invocation.method(
          #createUser,
          [user],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<_i7.UserModel?> getUserByUsername(String? username) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUserByUsername,
          [username],
        ),
        returnValue: _i6.Future<_i7.UserModel?>.value(),
      ) as _i6.Future<_i7.UserModel?>);
  @override
  _i6.Future<_i7.UserModel?> getUserById(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #getUserById,
          [userId],
        ),
        returnValue: _i6.Future<_i7.UserModel?>.value(),
      ) as _i6.Future<_i7.UserModel?>);
  @override
  _i6.Future<List<_i7.UserModel>> searchUsersByLocation({
    required double? lat,
    required double? lng,
    int? radius = 50000,
    int? limit = 20,
    String? lastUserId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #searchUsersByLocation,
          [],
          {
            #lat: lat,
            #lng: lng,
            #radius: radius,
            #limit: limit,
            #lastUserId: lastUserId,
          },
        ),
        returnValue: _i6.Future<List<_i7.UserModel>>.value(<_i7.UserModel>[]),
      ) as _i6.Future<List<_i7.UserModel>>);
  @override
  _i6.Future<void> updateUserData(_i7.UserModel? user) => (super.noSuchMethod(
        Invocation.method(
          #updateUserData,
          [user],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<bool> checkUsernameAvailability(
    String? username,
    String? userid,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #checkUsernameAvailability,
          [
            username,
            userid,
          ],
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
  @override
  _i6.Future<_i2.Loop> getLoopById(String? loopId) => (super.noSuchMethod(
        Invocation.method(
          #getLoopById,
          [loopId],
        ),
        returnValue: _i6.Future<_i2.Loop>.value(_FakeLoop_0(
          this,
          Invocation.method(
            #getLoopById,
            [loopId],
          ),
        )),
      ) as _i6.Future<_i2.Loop>);
  @override
  _i6.Future<void> addLoop(_i2.Loop? loop) => (super.noSuchMethod(
        Invocation.method(
          #addLoop,
          [loop],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> deleteLoop(_i2.Loop? loop) => (super.noSuchMethod(
        Invocation.method(
          #deleteLoop,
          [loop],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<List<_i2.Loop>> getUserLoops(
    String? userId, {
    int? limit = 20,
    String? lastLoopId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUserLoops,
          [userId],
          {
            #limit: limit,
            #lastLoopId: lastLoopId,
          },
        ),
        returnValue: _i6.Future<List<_i2.Loop>>.value(<_i2.Loop>[]),
      ) as _i6.Future<List<_i2.Loop>>);
  @override
  _i6.Stream<_i2.Loop> userLoopsObserver(
    String? userId, {
    int? limit = 20,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #userLoopsObserver,
          [userId],
          {#limit: limit},
        ),
        returnValue: _i6.Stream<_i2.Loop>.empty(),
      ) as _i6.Stream<_i2.Loop>);
  @override
  _i6.Future<List<_i2.Loop>> getFollowingLoops(
    String? currentUserId, {
    int? limit = 20,
    String? lastLoopId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFollowingLoops,
          [currentUserId],
          {
            #limit: limit,
            #lastLoopId: lastLoopId,
          },
        ),
        returnValue: _i6.Future<List<_i2.Loop>>.value(<_i2.Loop>[]),
      ) as _i6.Future<List<_i2.Loop>>);
  @override
  _i6.Stream<_i2.Loop> followingLoopsObserver(
    String? currentUserId, {
    int? limit = 20,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #followingLoopsObserver,
          [currentUserId],
          {#limit: limit},
        ),
        returnValue: _i6.Stream<_i2.Loop>.empty(),
      ) as _i6.Stream<_i2.Loop>);
  @override
  _i6.Future<List<_i2.Loop>> getAllLoops(
    String? currentUserId, {
    int? limit = 20,
    String? lastLoopId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllLoops,
          [currentUserId],
          {
            #limit: limit,
            #lastLoopId: lastLoopId,
          },
        ),
        returnValue: _i6.Future<List<_i2.Loop>>.value(<_i2.Loop>[]),
      ) as _i6.Future<List<_i2.Loop>>);
  @override
  _i6.Stream<_i2.Loop> allLoopsObserver(
    String? currentUserId, {
    int? limit = 20,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #allLoopsObserver,
          [currentUserId],
          {#limit: limit},
        ),
        returnValue: _i6.Stream<_i2.Loop>.empty(),
      ) as _i6.Stream<_i2.Loop>);
  @override
  _i6.Future<void> addLike(
    String? currentUserId,
    String? entityId,
    _i5.EntityType? entityType,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addLike,
          [
            currentUserId,
            entityId,
            entityType,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> deleteLike(
    String? currentUserId,
    String? entityId,
    _i5.EntityType? entityType,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteLike,
          [
            currentUserId,
            entityId,
            entityType,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<bool> isLiked(
    String? currentUserId,
    String? entityId,
    _i5.EntityType? entityType,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #isLiked,
          [
            currentUserId,
            entityId,
            entityType,
          ],
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
  @override
  _i6.Future<List<_i7.UserModel>> getLikes(
    String? entityId,
    _i5.EntityType? entityType,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getLikes,
          [
            entityId,
            entityType,
          ],
        ),
        returnValue: _i6.Future<List<_i7.UserModel>>.value(<_i7.UserModel>[]),
      ) as _i6.Future<List<_i7.UserModel>>);
  @override
  _i6.Future<List<_i3.Comment>> getComments(
    String? rootId,
    _i5.EntityType? rootType, {
    int? limit = 20,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getComments,
          [
            rootId,
            rootType,
          ],
          {#limit: limit},
        ),
        returnValue: _i6.Future<List<_i3.Comment>>.value(<_i3.Comment>[]),
      ) as _i6.Future<List<_i3.Comment>>);
  @override
  _i6.Stream<_i3.Comment> commentsObserver(
    String? rootId,
    _i5.EntityType? rootType, {
    int? limit = 20,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #commentsObserver,
          [
            rootId,
            rootType,
          ],
          {#limit: limit},
        ),
        returnValue: _i6.Stream<_i3.Comment>.empty(),
      ) as _i6.Stream<_i3.Comment>);
  @override
  _i6.Future<_i3.Comment> getComment(
    String? rootId,
    _i5.EntityType? rootType,
    String? commentId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getComment,
          [
            rootId,
            rootType,
            commentId,
          ],
        ),
        returnValue: _i6.Future<_i3.Comment>.value(_FakeComment_1(
          this,
          Invocation.method(
            #getComment,
            [
              rootId,
              rootType,
              commentId,
            ],
          ),
        )),
      ) as _i6.Future<_i3.Comment>);
  @override
  _i6.Future<void> addComment(
    _i3.Comment? comment,
    _i5.EntityType? rootType,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addComment,
          [
            comment,
            rootType,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> shareLoop(_i2.Loop? loop) => (super.noSuchMethod(
        Invocation.method(
          #shareLoop,
          [loop],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<int> followersNum(String? userid) => (super.noSuchMethod(
        Invocation.method(
          #followersNum,
          [userid],
        ),
        returnValue: _i6.Future<int>.value(0),
      ) as _i6.Future<int>);
  @override
  _i6.Future<int> followingNum(String? userid) => (super.noSuchMethod(
        Invocation.method(
          #followingNum,
          [userid],
        ),
        returnValue: _i6.Future<int>.value(0),
      ) as _i6.Future<int>);
  @override
  _i6.Future<void> followUser(
    String? currentUserId,
    String? visitedUserId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #followUser,
          [
            currentUserId,
            visitedUserId,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> unfollowUser(
    String? currentUserId,
    String? visitedUserId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #unfollowUser,
          [
            currentUserId,
            visitedUserId,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<bool> isFollowingUser(
    String? currentUserId,
    String? visitedUserId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #isFollowingUser,
          [
            currentUserId,
            visitedUserId,
          ],
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
  @override
  _i6.Future<List<_i7.UserModel>> getFollowing(String? currentUserId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFollowing,
          [currentUserId],
        ),
        returnValue: _i6.Future<List<_i7.UserModel>>.value(<_i7.UserModel>[]),
      ) as _i6.Future<List<_i7.UserModel>>);
  @override
  _i6.Future<List<_i7.UserModel>> getFollowers(String? currentUserId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFollowers,
          [currentUserId],
        ),
        returnValue: _i6.Future<List<_i7.UserModel>>.value(<_i7.UserModel>[]),
      ) as _i6.Future<List<_i7.UserModel>>);
  @override
  _i6.Future<List<_i8.Activity>> getActivities(
    String? userId, {
    int? limit = 20,
    String? lastActivityId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getActivities,
          [userId],
          {
            #limit: limit,
            #lastActivityId: lastActivityId,
          },
        ),
        returnValue: _i6.Future<List<_i8.Activity>>.value(<_i8.Activity>[]),
      ) as _i6.Future<List<_i8.Activity>>);
  @override
  _i6.Stream<_i8.Activity> activitiesObserver(
    String? userId, {
    int? limit = 20,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #activitiesObserver,
          [userId],
          {#limit: limit},
        ),
        returnValue: _i6.Stream<_i8.Activity>.empty(),
      ) as _i6.Stream<_i8.Activity>);
  @override
  _i6.Future<void> addActivity({
    required String? currentUserId,
    required String? visitedUserId,
    required _i8.ActivityType? type,
    _i2.Loop? loop,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addActivity,
          [],
          {
            #currentUserId: currentUserId,
            #visitedUserId: visitedUserId,
            #type: type,
            #loop: loop,
          },
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> markActivityAsRead(_i8.Activity? activity) =>
      (super.noSuchMethod(
        Invocation.method(
          #markActivityAsRead,
          [activity],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<bool> isVerified(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #isVerified,
          [userId],
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
  @override
  _i6.Future<void> createBadge(_i9.Badge? badge) => (super.noSuchMethod(
        Invocation.method(
          #createBadge,
          [badge],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> sendBadge(
    String? badgeId,
    String? receiverId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendBadge,
          [
            badgeId,
            receiverId,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Stream<_i9.Badge> userCreatedBadgesObserver(
    String? userId, {
    int? limit = 20,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #userCreatedBadgesObserver,
          [userId],
          {#limit: limit},
        ),
        returnValue: _i6.Stream<_i9.Badge>.empty(),
      ) as _i6.Stream<_i9.Badge>);
  @override
  _i6.Future<List<_i9.Badge>> getUserCreatedBadges(
    String? userId, {
    int? limit = 20,
    String? lastBadgeId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUserCreatedBadges,
          [userId],
          {
            #limit: limit,
            #lastBadgeId: lastBadgeId,
          },
        ),
        returnValue: _i6.Future<List<_i9.Badge>>.value(<_i9.Badge>[]),
      ) as _i6.Future<List<_i9.Badge>>);
  @override
  _i6.Stream<_i9.Badge> userBadgesObserver(
    String? userId, {
    int? limit = 20,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #userBadgesObserver,
          [userId],
          {#limit: limit},
        ),
        returnValue: _i6.Stream<_i9.Badge>.empty(),
      ) as _i6.Stream<_i9.Badge>);
  @override
  _i6.Future<List<_i9.Badge>> getUserBadges(
    String? userId, {
    int? limit = 20,
    String? lastBadgeId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUserBadges,
          [userId],
          {
            #limit: limit,
            #lastBadgeId: lastBadgeId,
          },
        ),
        returnValue: _i6.Future<List<_i9.Badge>>.value(<_i9.Badge>[]),
      ) as _i6.Future<List<_i9.Badge>>);
  @override
  _i6.Future<_i4.Post> getPostById(String? postId) => (super.noSuchMethod(
        Invocation.method(
          #getPostById,
          [postId],
        ),
        returnValue: _i6.Future<_i4.Post>.value(_FakePost_2(
          this,
          Invocation.method(
            #getPostById,
            [postId],
          ),
        )),
      ) as _i6.Future<_i4.Post>);
  @override
  _i6.Future<void> addPost(_i4.Post? post) => (super.noSuchMethod(
        Invocation.method(
          #addPost,
          [post],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> deletePost(_i4.Post? post) => (super.noSuchMethod(
        Invocation.method(
          #deletePost,
          [post],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<List<_i4.Post>> getUserPosts(
    String? userId, {
    int? limit = 20,
    String? lastPostId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUserPosts,
          [userId],
          {
            #limit: limit,
            #lastPostId: lastPostId,
          },
        ),
        returnValue: _i6.Future<List<_i4.Post>>.value(<_i4.Post>[]),
      ) as _i6.Future<List<_i4.Post>>);
  @override
  _i6.Stream<_i4.Post> userPostsObserver(
    String? userId, {
    int? limit = 20,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #userPostsObserver,
          [userId],
          {#limit: limit},
        ),
        returnValue: _i6.Stream<_i4.Post>.empty(),
      ) as _i6.Stream<_i4.Post>);
  @override
  _i6.Future<List<_i4.Post>> getFollowingPosts(
    String? currentUserId, {
    int? limit = 20,
    String? lastPostId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFollowingPosts,
          [currentUserId],
          {
            #limit: limit,
            #lastPostId: lastPostId,
          },
        ),
        returnValue: _i6.Future<List<_i4.Post>>.value(<_i4.Post>[]),
      ) as _i6.Future<List<_i4.Post>>);
  @override
  _i6.Stream<_i4.Post> followingPostsObserver(
    String? currentUserId, {
    int? limit = 20,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #followingPostsObserver,
          [currentUserId],
          {#limit: limit},
        ),
        returnValue: _i6.Stream<_i4.Post>.empty(),
      ) as _i6.Stream<_i4.Post>);
  @override
  _i6.Future<List<_i4.Post>> getAllPosts(
    String? currentUserId, {
    int? limit = 20,
    String? lastPostId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllPosts,
          [currentUserId],
          {
            #limit: limit,
            #lastPostId: lastPostId,
          },
        ),
        returnValue: _i6.Future<List<_i4.Post>>.value(<_i4.Post>[]),
      ) as _i6.Future<List<_i4.Post>>);
  @override
  _i6.Stream<_i4.Post> allPostsObserver(
    String? currentUserId, {
    int? limit = 20,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #allPostsObserver,
          [currentUserId],
          {#limit: limit},
        ),
        returnValue: _i6.Stream<_i4.Post>.empty(),
      ) as _i6.Stream<_i4.Post>);
}
