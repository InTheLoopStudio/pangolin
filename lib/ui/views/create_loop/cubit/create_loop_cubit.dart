import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/app_logger.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/controllers/audio_controller.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/widgets/create_loop_view/loop_description.dart';
import 'package:intheloopapp/ui/widgets/create_loop_view/loop_title.dart';

part 'create_loop_state.dart';

class CreateLoopCubit extends Cubit<CreateLoopState> {
  CreateLoopCubit({
    required this.currentUser,
    required this.onboardingBloc,
    required this.databaseRepository,
    required this.navigationBloc,
    required this.audioRepo,
    required this.storageRepository,
  }) : super(const CreateLoopState());

  final UserModel currentUser;
  AudioRepository audioRepo;
  AudioController? audioController;
  final OnboardingBloc onboardingBloc;
  final DatabaseRepository databaseRepository;
  final StorageRepository storageRepository;
  final NavigationBloc navigationBloc;

  static const Duration _maxDuration = Duration(minutes: 10);

  void onTitleChange(String input) {
    final title = LoopTitle.dirty(input);
    emit(
      state.copyWith(
        pickedAudio: state.pickedAudio,
        pickedImage: state.pickedImage,
        title: title,
      ),
    );
  }

  void onDescriptionChange(String input) {
    final description = LoopDescription.dirty(input);
    emit(
      state.copyWith(
        pickedAudio: state.pickedAudio,
        pickedImage: state.pickedImage,
        description: description,
      ),
    );
  }

  Future<String?> getAudioPath() async {
    if (state.pickedAudio == null) {
      return null;
    }

    final audioDuration = await AudioController.getDuration(state.pickedAudio);

    final tooLarge = audioDuration.compareTo(_maxDuration) >= 0;
    if (tooLarge) {
      throw Exception('Audio is too large, must be under 10 minutes');
    }

    final audioPath = await storageRepository.uploadAudioAttachment(
      state.pickedAudio!,
    );

    return audioPath;
  }

  Future<String?> getImagePath() async {
    if (state.pickedImage == null) {
      return null;
    }

    final imagePath = await storageRepository.uploadImageAttachment(
      state.pickedImage!,
    );

    return imagePath;
  }

  /// opens a user's gallery to upload audio
  Future<void> handleAudioFromFiles() async {
    try {
      final audioFileResult = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );
      if (audioFileResult != null) {
        final pickedAudioName =
            audioFileResult.files.single.path!.split('/').last;
        final pickedAudio = File(audioFileResult.files.single.path!);

        emit(
          state.copyWith(
            pickedImage: state.pickedImage,
            pickedAudio: pickedAudio,
            title: LoopTitle.dirty(pickedAudioName),
          ),
        );

        await state.audioController?.detach();
        audioController = AudioController.fromAudioFile(
          audioRepo: audioRepo,
          audioFile: pickedAudio,
          title: state.title.value,
          artist: currentUser.artistName,
          image: currentUser.profilePicture,
        );
        await audioController?.attach();
      }
    } catch (error, s) {
      logger.error(
        'error handling audio from files',
        error: error,
        stackTrace: s,
      );
      emit(
        state.copyWith(
          pickedAudio: state.pickedAudio,
          pickedImage: state.pickedImage,
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
  }

  /// opens a user's gallery to upload image
  Future<void> handleImageFromFiles() async {
    try {
      final fileResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (fileResult != null) {
        final pickedImage = File(fileResult.files.single.path!);

        emit(
          state.copyWith(
            pickedAudio: state.pickedAudio,
            pickedImage: pickedImage,
          ),
        );
      }
    } catch (e, s) {
      logger.error('error picking image', error: e, stackTrace: s);
      emit(
        state.copyWith(
          pickedAudio: state.pickedAudio,
          pickedImage: state.pickedImage,
          status: FormzSubmissionStatus.failure,
        ),
      );
      rethrow;
    }
  }

  void removeImage() {
    emit(
      state.copyWith(
        pickedAudio: state.pickedAudio,
        pickedImage: null,
      ),
    );
  }

  void removeAudio() {
    emit(
      state.copyWith(
        pickedAudio: null,
        pickedImage: state.pickedImage,
      ),
    );
  }

  Future<void> createLoop() async {
    try {
      if (state.status.isInProgress) return;

      if (!state.isValid) {
        throw Exception('Invalid form');
      }

      emit(
        state.copyWith(
          pickedAudio: state.pickedAudio,
          pickedImage: state.pickedImage,
          status: FormzSubmissionStatus.inProgress,
        ),
      );

      // Just settings the audio to get the duration
      final audioPath = state.pickedAudio != null ? await getAudioPath() : '';

      // Just settings the audio to get the duration
      final imagePath = state.pickedImage != null ? await getImagePath() : null;

      final loop = Loop.empty().copyWith(
        title: state.title.value,
        description: state.description.value,
        audioPath: audioPath,
        imagePaths: imagePath != null ? [imagePath] : [],
        userId: currentUser.id,
        // tags: state.selectedTags.map((tag) => tag.value).toList(),
      );

      logger.debug('creating loop: $loop');

      await databaseRepository.addLoop(loop);

      emit(
        state.copyWith(
          pickedAudio: null,
          pickedImage: null,
          title: const LoopTitle.pure(),
          description: const LoopDescription.pure(),
          status: FormzSubmissionStatus.success,
        ),
      );

      final user = currentUser.copyWith(
        loopsCount: (currentUser.loopsCount) + 1,
      );

      onboardingBloc.add(UpdateOnboardedUser(user: user));

      // Navigate back to the feed page
      navigationBloc
        ..add(const ChangeTab(selectedTab: 0))
        ..add(const Pop());
    } catch (e, s) {
      logger.error('error creating loop', error: e, stackTrace: s);
      emit(
        state.copyWith(
          pickedAudio: state.pickedAudio,
          pickedImage: state.pickedImage,
          status: FormzSubmissionStatus.failure,
        ),
      );
      rethrow;
    }
  }

  /// What to do if an upload is canceled
  Future<void> cancelUpload() async {
    await state.audioController?.detach();
    emit(const CreateLoopState());
  }
}
