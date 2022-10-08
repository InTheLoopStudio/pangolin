import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/controllers/audio_controller.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:just_audio/just_audio.dart';

part 'loop_container_state.dart';

class LoopContainerCubit extends Cubit<LoopContainerState> {
  LoopContainerCubit({
    required this.databaseRepository,
    required this.loop,
    required this.currentUser,
  }) : super(LoopContainerState(loop: loop));

  final Loop loop;
  final DatabaseRepository databaseRepository;
  final UserModel currentUser;

  Future<void> initLoopLikes() async {
    final isLiked = await databaseRepository.isLikeLoop(currentUser.id, loop);

    emit(
      state.copyWith(
        isLiked: isLiked,
        likesCount: state.loop.likes,
      ),
    );
  }

  void initAudio() {
    audioLock.addListener(onAudioLockChange);
    state.audioController.setLoopMode(LoopMode.one);
  }

  void deleteLoop() {
    databaseRepository.deleteLoop(loop);
  }

  void likeLoop() {
    if (state.isLiked) {
      databaseRepository.unlikeLoop(currentUser.id, state.loop);
      emit(
        state.copyWith(
          isLiked: false,
          likesCount: state.likesCount - 1,
        ),
      );
    } else {
      databaseRepository.likeLoop(currentUser.id, state.loop);
      emit(
        state.copyWith(
          isLiked: true,
          likesCount: state.likesCount + 1,
        ),
      );
    }
  }

  void onAudioLockChange() {
    if (audioLock.value != state.loop.id) {
      state.audioController.pause();
    }
  }

  @override
  Future<void> close() async {
    audioLock.removeListener(onAudioLockChange);
    state.audioController.pause();
    state.audioController.dispose();
    await super.close();
  }
}
