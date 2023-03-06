import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/controllers/audio_controller.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/upload_loop/loop_title.dart';

part 'upload_loop_state.dart';

/// Functionality and instructions for uploading a loop
class UploadLoopCubit extends Cubit<UploadLoopState> {
  /// Uploading a loop requires the database, storage, onboarding,
  /// knowledge of the current of the current user, view scaffold info,
  /// and navigation instructions
  UploadLoopCubit({
    required this.databaseRepository,
    required this.storageRepository,
    required this.onboardingBloc,
    required this.currentUser,
    this.scaffoldKey,
    this.navigationBloc,
  }) : super(UploadLoopState());

  /// Database methods
  final DatabaseRepository databaseRepository;

  /// Object storage methods
  final StorageRepository storageRepository;

  /// Onboarding data
  final OnboardingBloc onboardingBloc;

  /// The currently logged in user
  final UserModel currentUser;

  /// The scaffold of the view
  final GlobalKey<ScaffoldMessengerState>? scaffoldKey;

  /// Navigation instructions
  final NavigationBloc? navigationBloc;

  static const String _audioLockId = 'uploaded-loop';
  static const Duration _maxDuration = Duration(minutes: 10);

  @override
  Future<void> close() async {
    state.audioController.dispose();
    await super.close();
  }

  // Future<List<Tag>> getTagSuggestions(String value) async {
  //   return databaseRepository.getTagSuggestions(value);
  // }

  /// checks if the audio lock has changed
  /// and plays or pauses music accordingly
  void listenToAudioLockChange() {
    audioLock.addListener(() {
      if (audioLock.value != _audioLockId &&
          state.audioController.player.playing == true) {
        state.audioController.pause();
      }
    });
  }

  /// what to do it the title of the loop changes
  void titleChanged(String value) {
    final title = LoopTitle.dirty(value);
    emit(
      state.copyWith(
        loopTitle: title,
      ),
    );
  }

  // void addTag(Tag value) {
  //   emit(
  //     state.copyWith(
  //       selectedTags: [...state.selectedTags]..add(value),
  //     ),
  //   );
  // }

  /// What to do if an upload is canceled
  Future<void> cancelUpload() async {
    state.audioController.pause();
    emit(UploadLoopState());
  }

  /// opens a user's gallery to upload audio
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

        emit(
          state.copyWith(
            pickedAudio: pickedAudio,
            loopTitle: LoopTitle.dirty(pickedAudioName),
          ),
        );

        await state.audioController.setAudioFile(pickedAudio);
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
  }

  /// instructions for how to upload a loop
  Future<void> uploadLoop() async {
    // print('PATH 1 : ${state.pickedAudio!.path}');

    try {
      if (!state.isValid || state.pickedAudio == null) return;

      final tmp = await state.audioController.setAudioFile(state.pickedAudio);

      final audioDuration = tmp ?? Duration.zero;

      final tooLarge = audioDuration.compareTo(_maxDuration) >= 0;

      if (!tooLarge) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.inProgress,
          ),
        );

        final audioPath = await storageRepository.uploadLoop(
          currentUser.id,
          state.pickedAudio!,
        );

        final loop = Loop.empty().copyWith(
          title: state.loopTitle.value,
          audioPath: audioPath,
          userId: currentUser.id,
          // tags: state.selectedTags.map((tag) => tag.value).toList(),
        );

        await databaseRepository.addLoop(loop);

        emit(
          state.copyWith(
            loopTitle: const LoopTitle.pure(),
            status: FormzSubmissionStatus.success,
          ),
        );

        final user = currentUser.copyWith(
          loopsCount: (currentUser.loopsCount) + 1,
        );

        onboardingBloc.add(UpdateOnboardedUser(user: user));
        // Navigate back to the feed page
        navigationBloc?.add(const ChangeTab(selectedTab: 0));
      } else {
        // print('NOT VALID UPLOAD : $tooLarge + ${state.loopTitle.value}');
        if (scaffoldKey != null) {
          scaffoldKey!.currentState?.showSnackBar(
            SnackBar(
              content:
                  const Text('Audio must be under 10 minutes with a title'),
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Ok',
                onPressed: () {},
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (scaffoldKey != null) {
        scaffoldKey!.currentState?.showSnackBar(
          SnackBar(
            content: const Text('Error uploading loop'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          ),
        );
      }
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}
