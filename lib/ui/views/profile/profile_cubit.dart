import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'profile_state.dart';

class ProfileCubit extends HydratedCubit<ProfileState> {

  ProfileCubit({
    required this.databaseRepository,
    required this.currentUser,
    required this.visitedUser,
  }) : super(
          ProfileState(
            currentUser: currentUser,
            visitedUser: visitedUser,
          ),
        );
  final DatabaseRepository databaseRepository;
  final UserModel currentUser;
  final UserModel visitedUser;
  StreamSubscription? loopListener;
  StreamSubscription? badgeListener;

  @override
  ProfileState fromJson(Map<String, dynamic> json) {
    return ProfileState(
      followerCount: json['followerCount'],
      followingCount: json['followingCount'],
      isFollowing: json['isFollowing'],
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
          await databaseRepository.getUser(state.visitedUser.id);
      emit(state.copyWith(visitedUser: refreshedVisitedUser));
    } else {
      emit(state.copyWith(visitedUser: newUserData));
    }
  }

  Future<void> initLoops({bool clearLoops = true}) async {
    await loopListener?.cancel();
    if (clearLoops) {
      emit(state.copyWith(
        status: ProfileStatus.initial,
        userLoops: [],
        hasReachedMax: false,
      ),);
    }

    final loopsAvailable =
        (await databaseRepository.getUserLoops(visitedUser.id, limit: 1)).isNotEmpty;
    if (!loopsAvailable) {
      emit(state.copyWith(status: ProfileStatus.success));
    }

    loopListener = databaseRepository
        .userLoopsObserver(visitedUser.id)
        .listen((Loop event) {
      // print('loop { ${event.id} : ${event.title} }');
      emit(state.copyWith(
        status: ProfileStatus.success,
        userLoops: List.of(state.userLoops)..add(event),
      ),);
    });
  }

  Future<void> initBadges({bool clearBadges = true}) async {
    await badgeListener?.cancel();
    if (clearBadges) {
      emit(state.copyWith(
        status: ProfileStatus.initial,
        userBadges: [],
        hasReachedMax: false,
      ),);
    }

    final badgesAvailable =
        (await databaseRepository.getUserBadges(visitedUser.id, limit: 1)).isNotEmpty;
    if (!badgesAvailable) {
      emit(state.copyWith(status: ProfileStatus.success));
    }

    badgeListener = databaseRepository
        .userBadgesObserver(visitedUser.id)
        .listen((Badge event) {
      // print('loop { ${event.id} : ${event.title} }');
      emit(state.copyWith(
        status: ProfileStatus.success,
        userBadges: List.of(state.userBadges)..add(event),
      ),);
    });
  }

  Future<void> fetchMoreLoops() async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == ProfileStatus.initial) {
        await initLoops();
      }

      final loops = await databaseRepository.getUserLoops(
        visitedUser.id,
        limit: 10,
        lastLoopId: state.userLoops.last.id,
      );
      loops.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: ProfileStatus.success,
                userLoops: List.of(state.userLoops)..addAll(loops),
                hasReachedMax: false,
              ),
            );
    } on Exception {
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }

  Future<void> fetchMoreBadges() async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == ProfileStatus.initial) {
        await initBadges();
      }

      final badges = await databaseRepository.getUserBadges(
        visitedUser.id,
        limit: 10,
        lastBadgeId: state.userBadges.last.id,
      );
      badges.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: ProfileStatus.success,
                userBadges: List.of(state.userBadges)..addAll(badges),
                hasReachedMax: false,
              ),
            );
    } on Exception {
      emit(state.copyWith(status: ProfileStatus.failure));
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

  Future<void> loadIsFollowing(String currentUserId, String visitedUserId) async {
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

  void deleteLoop(Loop loop) {
    final newLoops = List<Loop>.of(state.userLoops)
      ..removeWhere((element) => element.id == loop.id);
    emit(state.copyWith(userLoops: newLoops));
  }

  @override
  Future<void> close() async {
    await loopListener?.cancel();
    await super.close();
  }
}
