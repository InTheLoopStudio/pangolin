import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'profile_state.dart';

class ProfileCubit extends HydratedCubit<ProfileState> {
  ProfileCubit({
    required this.databaseRepository,
    required this.places,
    required this.currentUser,
    required this.visitedUser,
  }) : super(
          ProfileState(
            currentUser: currentUser,
            visitedUser: visitedUser,
          ),
        );
  final DatabaseRepository databaseRepository;
  final PlacesRepository places;
  final UserModel currentUser;
  final UserModel visitedUser;
  StreamSubscription<Loop>? loopListener;
  StreamSubscription<Badge>? badgeListener;
  StreamSubscription<Badge>? userCreatedBadgeListener;

  @override
  ProfileState fromJson(Map<String, dynamic> json) {
    return ProfileState(
      followerCount: json['followerCount'] as int,
      followingCount: json['followingCount'] as int,
      isFollowing: json['isFollowing'] as bool,
      // userLoops: json['userLoops'],
      visitedUser: visitedUser,
      currentUser: currentUser,
      // visitedUser: UserModel.fromJson(json['visitedUser']),
      // currentUser: UserModel.fromJson(json['currentUser']),
    );
  }

  @override
  Map<String, dynamic> toJson(ProfileState state) => {
        'followerCount': state.followerCount,
        'followingCount': state.followingCount,
        'isFollowing': state.isFollowing,
        // 'userLoops': state.userLoops,
        // 'visitedUser': state.visitedUser.toJson(),
        // 'currentUser': state.currentUser.toJson(),
      };

  Future<void> refetchVisitedUser({UserModel? newUserData}) async {
    if (newUserData == null) {
      final refreshedVisitedUser =
          await databaseRepository.getUserById(state.visitedUser.id);
      emit(state.copyWith(visitedUser: refreshedVisitedUser));
    } else {
      emit(state.copyWith(visitedUser: newUserData));
    }
  }

  Future<void> initLoops({bool clearLoops = true}) async {
    await loopListener?.cancel();
    if (clearLoops) {
      emit(
        state.copyWith(
          loopStatus: LoopsStatus.initial,
          userLoops: [],
          hasReachedMaxLoops: false,
        ),
      );
    }

    final userLoops =
        await databaseRepository.getUserLoops(visitedUser.id, limit: 1);
    if (userLoops.isEmpty) {
      emit(state.copyWith(loopStatus: LoopsStatus.success));
    }

    loopListener = databaseRepository
        .userLoopsObserver(visitedUser.id)
        .listen((Loop event) {
      // print('loop { ${event.id} : ${event.title} }');
      emit(
        state.copyWith(
          loopStatus: LoopsStatus.success,
          userLoops: List.of(state.userLoops)..add(event),
        ),
      );
    });
  }

  Future<void> initBadges({bool clearBadges = true}) async {
    await badgeListener?.cancel();
    if (clearBadges) {
      emit(
        state.copyWith(
          badgeStatus: BadgesStatus.initial,
          userBadges: [],
          hasReachedMaxBadges: false,
        ),
      );
    }

    final badgesAvailable =
        (await databaseRepository.getUserBadges(visitedUser.id, limit: 1))
            .isNotEmpty;
    if (!badgesAvailable) {
      emit(state.copyWith(badgeStatus: BadgesStatus.success));
    }

    badgeListener = databaseRepository
        .userBadgesObserver(visitedUser.id)
        .listen((Badge event) {
      // print('badge { ${event.id} : ${event.title} }');
      emit(
        state.copyWith(
          badgeStatus: BadgesStatus.success,
          userBadges: List.of(state.userBadges)..add(event),
          hasReachedMaxBadges: state.userBadges.length < 10,
        ),
      );
    });
  }

  Future<void> initUserCreatedBadges({bool clearBadges = true}) async {
    await userCreatedBadgeListener?.cancel();

    if (clearBadges) {
      emit(
        state.copyWith(
          userCreatedBadgeStatus: UserCreatedBadgesStatus.initial,
          userCreatedBadges: [],
          hasReachedMaxUserCreatedBadges: false,
        ),
      );
    }

    final badgesAvailable = (await databaseRepository
            .getUserCreatedBadges(visitedUser.id, limit: 1))
        .isNotEmpty;
    if (!badgesAvailable) {
      emit(
        state.copyWith(
          userCreatedBadgeStatus: UserCreatedBadgesStatus.success,
        ),
      );
    }

    badgeListener = databaseRepository
        .userCreatedBadgesObserver(visitedUser.id)
        .listen((Badge event) {
      // print('loop { ${event.id} : ${event.title} }');
      emit(
        state.copyWith(
          userCreatedBadgeStatus: UserCreatedBadgesStatus.success,
          userCreatedBadges: List.of(state.userCreatedBadges)..add(event),
          hasReachedMaxUserCreatedBadges: state.userCreatedBadges.length < 10,
        ),
      );
    });
  }

  Future<void> initPlace() async {
    final place = await places.getPlaceById(visitedUser.placeId);
    emit(state.copyWith(place: place));
  }

  Future<void> fetchMoreLoops() async {
    if (state.hasReachedMaxLoops) return;

    try {
      if (state.loopStatus == LoopsStatus.initial) {
        await initLoops();
      }

      final loops = await databaseRepository.getUserLoops(
        visitedUser.id,
        // limit: 10,
        lastLoopId: state.userLoops.last.id,
      );
      loops.isEmpty
          ? emit(state.copyWith(hasReachedMaxLoops: true))
          : emit(
              state.copyWith(
                loopStatus: LoopsStatus.success,
                userLoops: List.of(state.userLoops)..addAll(loops),
                hasReachedMaxLoops: false,
              ),
            );
    } on Exception {
      emit(state.copyWith(loopStatus: LoopsStatus.failure));
    }
  }

  Future<void> fetchMoreBadges() async {
    if (state.hasReachedMaxBadges) return;

    try {
      if (state.badgeStatus == BadgesStatus.initial) {
        await initBadges();
      }

      final badges = await databaseRepository.getUserBadges(
        visitedUser.id,
        limit: 10,
        lastBadgeId: state.userBadges.last.id,
      );
      badges.isEmpty
          ? emit(state.copyWith(hasReachedMaxBadges: true))
          : emit(
              state.copyWith(
                badgeStatus: BadgesStatus.success,
                userBadges: List.of(state.userBadges)..addAll(badges),
                hasReachedMaxBadges: false,
              ),
            );
    } on Exception {
      emit(state.copyWith(badgeStatus: BadgesStatus.failure));
    }
  }

  Future<void> fetchMoreUserCreatedBadges() async {
    if (state.hasReachedMaxUserCreatedBadges) return;

    try {
      if (state.userCreatedBadgeStatus == UserCreatedBadgesStatus.initial) {
        await initUserCreatedBadges();
      }

      final badges = await databaseRepository.getUserCreatedBadges(
        visitedUser.id,
        limit: 10,
        lastBadgeId: state.userBadges.last.id,
      );
      badges.isEmpty
          ? emit(state.copyWith(hasReachedMaxUserCreatedBadges: true))
          : emit(
              state.copyWith(
                userCreatedBadgeStatus: UserCreatedBadgesStatus.success,
                userCreatedBadges: List.of(state.userCreatedBadges)
                  ..addAll(badges),
                hasReachedMaxUserCreatedBadges: false,
              ),
            );
    } on Exception {
      emit(
        state.copyWith(
          userCreatedBadgeStatus: UserCreatedBadgesStatus.failure,
        ),
      );
    }
  }

  void toggleFollow(String currentUserId, String visitedUserId) {
    if (state.isFollowing) {
      unfollow(currentUserId, visitedUserId);
    } else {
      follow(currentUserId, visitedUserId);
    }
  }

  Future<void> follow(String currentUserId, String visitedUserId) async {
    emit(
      state.copyWith(
        followerCount: state.followerCount + 1,
        isFollowing: true,
      ),
    );
    await databaseRepository.followUser(currentUserId, visitedUserId);
  }

  Future<void> unfollow(String currentUserId, String visitedUserId) async {
    emit(
      state.copyWith(
        followerCount: state.followerCount - 1,
        isFollowing: false,
      ),
    );
    await databaseRepository.unfollowUser(currentUserId, visitedUserId);
  }

  Future<void> loadFollowing(String visitedUserId) async {
    final followingCount = await databaseRepository.followingNum(visitedUserId);

    emit(
      state.copyWith(
        followingCount: followingCount,
      ),
    );
  }

  Future<void> loadFollower(String visitedUserId) async {
    final followerCount = await databaseRepository.followersNum(visitedUserId);

    emit(
      state.copyWith(
        followerCount: followerCount,
      ),
    );
  }

  Future<void> loadIsFollowing(
    String currentUserId,
    String visitedUserId,
  ) async {
    final isFollowing = await databaseRepository.isFollowingUser(
      currentUserId,
      visitedUserId,
    );

    emit(
      state.copyWith(
        isFollowing: isFollowing,
      ),
    );
  }

  Future<void> loadIsVerified(String visitedUserId) async {
    final isVerified = await databaseRepository.isVerified(visitedUserId);

    emit(
      state.copyWith(
        isVerified: isVerified,
      ),
    );
  }

  void deleteLoop(Loop loop) {
    final newLoops = List<Loop>.of(state.userLoops)
      ..removeWhere((element) => element.id == loop.id);
    emit(state.copyWith(userLoops: newLoops));
  }

  @override
  Future<void> close() async {
    await loopListener?.cancel();
    await badgeListener?.cancel();
    await userCreatedBadgeListener?.cancel();
    await super.close();
  }
}
