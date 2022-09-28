import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/controllers/audio_controller.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/upload_loop/loop_title.dart';

part 'upload_loop_state.dart';

class UploadLoopCubit extends Cubit<UploadLoopState> {
  UploadLoopCubit({
    required this.databaseRepository,
    required this.storageRepository,
    required this.authenticationBloc,
    required this.currentUser,
    this.scaffoldKey,
    this.navigationBloc,
  }) : super(UploadLoopState());

  final DatabaseRepository databaseRepository;
  final StorageRepository storageRepository;
  final AuthenticationBloc authenticationBloc;
  final UserModel currentUser;
  final GlobalKey<ScaffoldMessengerState>? scaffoldKey;
  final NavigationBloc? navigationBloc;

  static String audioLockId = 'uploaded-loop';
  static const Duration _maxDuration = Duration(minutes: 5);

  @override
  Future<void> close() async {
    state.audioController.dispose();
    await super.close();
  }

  // Future<List<Tag>> getTagSuggestions(String value) async {
  //   return databaseRepository.getTagSuggestions(value);
  // }

  void listenToAudioLockChange() {
    audioLock.addListener(() {
      if (audioLock.value != audioLockId &&
          state.audioController.player.playing == true) {
        state.audioController.pause();
      }
    });
  }

  void titleChanged(String value) {
    final title = LoopTitle.dirty(value);
    emit(state.copyWith(
      loopTitle: title,
      status: Formz.validate([title]),
    ),);
  }

  // void addTag(Tag value) {
  //   emit(
  //     state.copyWith(
  //       selectedTags: [...state.selectedTags]..add(value),
  //     ),
  //   );
  // }

  Future<void> cancelUpload() async {
    state.audioController.pause();
    emit(UploadLoopState());
  }

  Future<void> handleAudioFromFiles() async {
    try {
      final audioFileResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'],
      );
      if (audioFileResult != null) {
        final pickedAudioName =
            audioFileResult.files.single.path!.split('/').last;
        final pickedAudio = File(audioFileResult.files.single.path!);

        emit(state.copyWith(
          pickedAudio: pickedAudio,
          status: Formz.validate([
            LoopTitle.dirty(pickedAudioName),
          ]),
          loopTitle: LoopTitle.dirty(pickedAudioName),
        ),);

        await state.audioController.setAudioFile(pickedAudio);

        print(state.audioController);
      }
    } catch (error) {
      print(error);
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
      ),);
    }
  }

  Future<void> uploadLoop() async {
    print('PATH 1 : ${state.pickedAudio!.path}');

    try {
      if (!state.status.isValidated || state.pickedAudio == null) return;

      final tmp =
          await state.audioController.setAudioFile(state.pickedAudio);

      final audioDuration = tmp ?? const Duration();

      final tooLarge = audioDuration.compareTo(_maxDuration) >= 0;

      print('PATH 2 : ${state.pickedAudio!.path}');

      if (state.loopTitle.value.isNotEmpty && !tooLarge) {
        emit(state.copyWith(
          status: FormzStatus.submissionInProgress,
        ),);

        final audio = await storageRepository.uploadLoop(
          currentUser.id,
          state.pickedAudio!,
        );

        final loop = Loop.empty.copyWith(
          title: state.loopTitle.value,
          audio: audio,
          userId: currentUser.id,
          // tags: state.selectedTags.map((tag) => tag.value).toList(),
        );

        await databaseRepository.uploadLoop(loop);

        emit(state.copyWith(
          loopTitle: const LoopTitle.pure(),
          status: FormzStatus.submissionSuccess,
        ),);

        final user = currentUser.copyWith(
          loopsCount: (currentUser.loopsCount) + 1,
        );

        authenticationBloc.add(UpdateAuthenticatedUser(user));
        // Navigate back to the feed page
        navigationBloc?.add(const ChangeTab(selectedTab: 0));
      } else {
        print('NOT VALID UPLOAD : $tooLarge + ${state.loopTitle.value}');
        if (scaffoldKey != null) {
          scaffoldKey!.currentState?.showSnackBar(SnackBar(
            content: const Text('Audio must be under 5 minutes with a title'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          ),);
        }
      }
    } catch (e) {
      print('[ERROR] $e');
      if (scaffoldKey != null) {
        scaffoldKey!.currentState?.showSnackBar(SnackBar(
          content: const Text('Error uploading loop'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {},
          ),
        ),);
      }
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
      ),);
    }
  }
}
