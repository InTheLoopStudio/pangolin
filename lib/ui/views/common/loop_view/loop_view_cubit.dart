import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/controllers/audio_controller.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'loop_view_state.dart';

class LoopViewCubit extends Cubit<LoopViewState> {
  LoopViewCubit({
    required this.databaseRepository,
    required this.currentUser,
    required this.loop,
    required this.user,
    this.showComments = false,
    this.autoPlay = true,
    this.pageController,
    this.feedId = 'unknown',
  }) : super(
          LoopViewState(
            loop: loop,
            feedId: feedId,
            user: user,
            showComments: showComments,
          ),
        );

  String get audioLockId => "${this.feedId}-${this.loop.id}";

  final DatabaseRepository databaseRepository;
  final UserModel currentUser;
  final Loop loop;
  final UserModel user;
  final String feedId;
  final bool showComments;
  final bool autoPlay;
  final PageController? pageController;

  @override
  Future<void> close() async {
    state.audioController.pause();
    state.audioController.dispose();
    audioLock.removeListener(audioLockListener);
    super.close();
  }

  void nextLoop() {
    if (pageController != null) {
      state.audioController.pause();
      pageController?.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void toggleComments() {
    emit(state.copyWith(showComments: !state.showComments));
  }

  void togglePlaying() {
    if (state.audioController.player.playing == true) {
      state.audioController.pause();
    } else {
      state.audioController.play(audioLockId);
    }
  }

  void audioLockListener() {
    if (audioLock.value != audioLockId) {
      state.audioController.pause();
    }
  }

  void initAudio() {
    // _player.setLoopMode(LoopMode.one);
    state.audioController.setURL(loop.audio!);
    if (autoPlay == true) {
      state.audioController.play(audioLockId);
    }
    audioLock.addListener(audioLockListener);
  }

  void addComment() {
    emit(state.copyWith(commentsCount: state.commentsCount + 1));
  }

  void toggleFollow() {
    if (currentUser.id == user.id) {
      return;
    }

    if (state.isFollowing) {
      unfollowUser();
    } else {
      followUser();
    }
  }

  void unfollowUser() async {
    emit(state.copyWith(isFollowing: false));
    await databaseRepository.unfollowUser(currentUser.id, user.id);
  }

  void followUser() async {
    emit(state.copyWith(isFollowing: true));
    await databaseRepository.followUser(currentUser.id, user.id);
  }

  void initIsFollowing() async {
    if (currentUser.id == user.id) {
      return;
    }

    bool isFollowingThisUser = await databaseRepository.isFollowingUser(
      currentUser.id,
      user.id,
    );

    emit(state.copyWith(isFollowing: isFollowingThisUser));
  }

  void initLoopLikes() async {
    bool isLiked = await databaseRepository.isLikeLoop(currentUser.id, loop);
    emit(state.copyWith(isLiked: isLiked, likesCount: loop.likes ?? 0));
  }

  void initLoopComments() async {
    emit(state.copyWith(commentsCount: loop.comments ?? 0));
  }

  toggleLikeLoop() async {
    if (state.isLiked) {
      emit(state.copyWith(
        isLiked: false,
        likesCount: state.likesCount - 1,
      ));

      await databaseRepository.unlikeLoop(currentUser.id, loop);
    } else {
      emit(state.copyWith(
        isLiked: true,
        likesCount: state.likesCount + 1,
      ));

      await databaseRepository.likeLoop(currentUser.id, loop);
    }
  }
}
