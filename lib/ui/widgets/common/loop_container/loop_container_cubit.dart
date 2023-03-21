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
    required this.audioController,
    required this.loop,
    required this.currentUser,
  }) : super(
          LoopContainerState(
            loop: loop,
            audioController: audioController,
          ),
        );

  final Loop loop;
  final DatabaseRepository databaseRepository;
  final UserModel currentUser;
  final AudioController audioController;

  Future<void> initLoopLikes() async {
    final isLiked = await databaseRepository.isLiked(
      currentUser.id,
      loop.id,
      EntityType.loop,
    );

    emit(
      state.copyWith(
        isLiked: isLiked,
        likeCount: state.loop.likeCount,
      ),
    );
  }

  void initAudio() {
    state.audioController.setLoopMode(LoopMode.one);
  }

  void deleteLoop() {
    databaseRepository.deleteLoop(loop);
  }

  void likeLoop() {
    if (state.isLiked) {
      databaseRepository.deleteLike(
        currentUser.id,
        state.loop.id,
        EntityType.loop,
      );
      emit(
        state.copyWith(
          isLiked: false,
          likeCount: state.likeCount - 1,
        ),
      );
    } else {
      databaseRepository.addLike(
        currentUser.id,
        state.loop.id,
        EntityType.loop,
      );
      emit(
        state.copyWith(
          isLiked: true,
          likeCount: state.likeCount + 1,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await state.audioController.dispose();
    await super.close();
  }
}
