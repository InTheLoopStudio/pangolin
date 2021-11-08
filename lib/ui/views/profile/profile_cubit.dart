import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'profile_state.dart';

class ProfileCubit extends HydratedCubit<ProfileState> {
  final DatabaseRepository databaseRepository;
  final UserModel currentUser;
  final UserModel visitedUser;
  StreamSubscription? loopListener;

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

  void refetchVisitedUser({UserModel? newUserData}) async {
    if (newUserData == null) {
      final refreshedVisitedUser =
          await databaseRepository.getUser(state.visitedUser.id);
      emit(state.copyWith(visitedUser: refreshedVisitedUser));
    } else {
      emit(state.copyWith(visitedUser: newUserData));
    }
  }

  void initLoops({bool clearLoops = true}) async {
    loopListener?.cancel();
    if (clearLoops) {
      emit(state.copyWith(
        status: ProfileStatus.initial,
        userLoops: [],
        hasReachedMax: false,
      ));
    }

    bool loopsAvailable =
        (await databaseRepository.getUserLoops(visitedUser.id, limit: 1))
                .length !=
            0;
    if (!loopsAvailable) {
      emit(state.copyWith(status: ProfileStatus.success));
    }

    loopListener = databaseRepository
        .userLoopsObserver(visitedUser.id, limit: 20)
        .listen((Loop event) {
      // print('loop { ${event.id} : ${event.title} }');
      emit(state.copyWith(
        status: ProfileStatus.success,
        userLoops: List.of(state.userLoops)..add(event),
      ));
    });
  }

  void fetchMoreLoops() async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == ProfileStatus.initial) {
        initLoops();
      }

      final List<Loop> loops = await databaseRepository.getUserLoops(
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

  void toggleFollow(String currentUserId, String visitedUserId) {
    if (state.isFollowing) {
      unfollow(currentUserId, visitedUserId);
    } else {
      follow(currentUserId, visitedUserId);
    }
  }

  void follow(String currentUserId, String visitedUserId) async {
    emit(
      state.copyWith(
        followerCount: state.followerCount + 1,
        isFollowing: true,
      ),
    );
    await databaseRepository.followUser(currentUserId, visitedUserId);
  }

  void unfollow(String currentUserId, String visitedUserId) async {
    emit(
      state.copyWith(
        followerCount: state.followerCount - 1,
        isFollowing: false,
      ),
    );
    await databaseRepository.unfollowUser(currentUserId, visitedUserId);
  }

  void loadFollowing(String visitedUserId) async {
    int followingCount = await databaseRepository.followingNum(visitedUserId);

    emit(
      state.copyWith(
        followingCount: followingCount,
      ),
    );
  }

  void loadFollower(String visitedUserId) async {
    int followerCount = await databaseRepository.followersNum(visitedUserId);

    emit(
      state.copyWith(
        followerCount: followerCount,
      ),
    );
  }

  void loadIsFollowing(String currentUserId, String visitedUserId) async {
    bool isFollowing = await databaseRepository.isFollowingUser(
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
    List<Loop> newLoops = List.of(state.userLoops)
      ..removeWhere((element) => element.id == loop.id);
    emit(state.copyWith(userLoops: newLoops));
  }

  @override
  Future<void> close() async {
    loopListener?.cancel();
    super.close();
  }
}
