import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
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
    required this.audioController,
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
            audioController: audioController,
          ),
        );

  final DatabaseRepository databaseRepository;
  final UserModel currentUser;
  final Loop loop;
  final UserModel user;
  final String feedId;
  final bool showComments;
  final bool autoPlay;
  final PageController? pageController;

  final AudioController audioController;

  @override
  Future<void> close() async {
    await state.audioController.dispose();
    await super.close();
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
    if (state.audioController.isPlaying) {
      state.audioController.pause();
    } else {
      state.audioController.play();
    }
  }

  void initAudio() {
    // _player.setLoopMode(LoopMode.one);
    if (autoPlay == true) {
      state.audioController.play();
    }
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

  Future<void> unfollowUser() async {
    emit(state.copyWith(isFollowing: false));
    await databaseRepository.unfollowUser(currentUser.id, user.id);
  }

  Future<void> followUser() async {
    emit(state.copyWith(isFollowing: true));
    await databaseRepository.followUser(currentUser.id, user.id);
  }

  Future<void> initIsFollowing() async {
    if (currentUser.id == user.id) {
      return;
    }

    final isFollowingThisUser = await databaseRepository.isFollowingUser(
      currentUser.id,
      user.id,
    );

    emit(state.copyWith(isFollowing: isFollowingThisUser));
  }

  Future<void> initLoopLikes() async {
    final isLiked = await databaseRepository.isLiked(
      currentUser.id,
      loop.id,
      EntityType.loop,
    );
    emit(state.copyWith(isLiked: isLiked, likeCount: loop.likeCount));
  }

  Future<void> checkIsVerified() async {
    final isVerified = await databaseRepository.isVerified(loop.userId);
    emit(state.copyWith(isVerified: isVerified));
  }

  Future<void> initLoopComments() async {
    emit(state.copyWith(commentsCount: loop.commentCount));
  }

  Future<void> toggleLikeLoop() async {
    if (state.isLiked) {
      emit(
        state.copyWith(
          isLiked: false,
          likeCount: state.likeCount - 1,
        ),
      );

      await databaseRepository.deleteLike(
        currentUser.id,
        loop.id,
        EntityType.loop,
      );
    } else {
      emit(
        state.copyWith(
          isLiked: true,
          likeCount: state.likeCount + 1,
        ),
      );

      await databaseRepository.addLike(
        currentUser.id,
        loop.id,
        EntityType.loop,
      );
    }
  }

  Future<void> incrementShares() async {
    await databaseRepository.shareLoop(loop);
  }
}
