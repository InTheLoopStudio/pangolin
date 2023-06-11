import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/controllers/audio_controller.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'loop_container_state.dart';

class LoopContainerCubit extends Cubit<LoopContainerState> {
  LoopContainerCubit({
    required this.databaseRepository,
    required this.audioRepo,
    required this.loop,
    required this.currentUser,
    this.commentStream,
  }) : super(
          LoopContainerState(
            loop: loop,
            likeCount: loop.likeCount,
            commentCount: loop.commentCount,
          ),
        );

  final Loop loop;
  final AudioRepository audioRepo;
  final DatabaseRepository databaseRepository;
  final UserModel currentUser;
  final Stream<int>? commentStream;

  void initCommentStream() {
    commentStream?.listen((event) {
      emit(
        state.copyWith(
          commentCount: state.commentCount + event,
        ),
      );
    });
  }

  void deleteLoop() {
    databaseRepository.deleteLoop(loop);
  }

  void toggleLoopLike() {
    if (state.isLiked) {
      databaseRepository.deleteLike(
        currentUser.id,
        state.loop.id,
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
      );
      emit(
        state.copyWith(
          isLiked: true,
          likeCount: state.likeCount + 1,
        ),
      );
    }
  }

  Future<void> incrementShares() async {
    await databaseRepository.shareLoop(loop);
  }

  @override
  Future<void> close() async {
    await state.audioController?.dispose();
    await super.close();
  }
}
