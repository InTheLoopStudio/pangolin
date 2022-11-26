import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';

part 'onboarding_flow_state.dart';

class OnboardingFlowCubit extends Cubit<OnboardingFlowState> {
  OnboardingFlowCubit({
    required this.currentUser,
    required this.onboardingBloc,
    required this.navigationBloc,
    required this.authenticationBloc,
    required this.storageRepository,
    required this.databaseRepository,
  }) : super(OnboardingFlowState(currentUser: currentUser));

  final OnboardingBloc onboardingBloc;
  final NavigationBloc navigationBloc;
  final AuthenticationBloc authenticationBloc;
  final StorageRepository storageRepository;
  final DatabaseRepository databaseRepository;
  UserModel currentUser;

  void initUserData() {
    emit(
      state.copyWith(
        username: currentUser.username,
        artistName: currentUser.artistName,
        location: currentUser.location,
        bio: currentUser.bio,
      ),
    );
  }

  Future<void> initFollowRecommendations() async {
    for (final userId in [
      'VWj4qT2JMIhjjEYYFnbvebIazfB3',
      '8yYVxpQ7cURSzNfBsaBGF7A7kkv2',
      'wHpU3xj2yUSuz2rLFKC6J87HTLu1',
      'n4zIL6bOuPTqRC3dtsl6gyEBPQl1'
    ]) {
      var isFollowing = false;

      if (userId == currentUser.id) {
        isFollowing = true;
      } else {
        isFollowing = await databaseRepository.isFollowingUser(
          currentUser.id,
          userId,
        );
      }

      switch (userId) {
        case 'VWj4qT2JMIhjjEYYFnbvebIazfB3':
          emit(state.copyWith(followingInfamous: isFollowing));
          break;
        case '8yYVxpQ7cURSzNfBsaBGF7A7kkv2':
          emit(state.copyWith(followingJohannes: isFollowing));
          break;
        case 'wHpU3xj2yUSuz2rLFKC6J87HTLu1':
          emit(state.copyWith(followingChris: isFollowing));
          break;
        case 'n4zIL6bOuPTqRC3dtsl6gyEBPQl1':
          emit(state.copyWith(followingIlias: isFollowing));
          break;
        default:
          break;
      }
    }
  }

  Future<void> followRecommendation(String userId) async {
    switch (userId) {
      case 'VWj4qT2JMIhjjEYYFnbvebIazfB3':
        emit(state.copyWith(followingInfamous: true));
        break;
      case '8yYVxpQ7cURSzNfBsaBGF7A7kkv2':
        emit(state.copyWith(followingJohannes: true));
        break;
      case 'wHpU3xj2yUSuz2rLFKC6J87HTLu1':
        emit(state.copyWith(followingChris: true));
        break;
      case 'n4zIL6bOuPTqRC3dtsl6gyEBPQl1':
        emit(state.copyWith(followingIlias: true));
        break;
      default:
        break;
    }

    await databaseRepository.followUser(
      currentUser.id,
      userId,
    );
  }

  void usernameChange(String input) => emit(state.copyWith(username: input));
  void aristNameChange(String input) => emit(state.copyWith(artistName: input));
  void locationChange(String input) => emit(state.copyWith(location: input));
  void bioChange(String input) => emit(state.copyWith(bio: input));

  Future<void> handleImageFromGallery() async {
    try {
      final imageFile =
          await state.picker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        emit(state.copyWith(pickedPhoto: File(imageFile.path)));
      }
    } on Exception {
      // print(error);
    }
  }

  void next() {
    if (state.onboardingStage == OnboardingStage.stage1) {
      if (state.formKey.currentState == null) {
        return;
      }

      state.formKey.currentState!.save();
      if (state.formKey.currentState!.validate() &&
          !state.status.isSubmissionInProgress) {
        emit(state.copyWith(status: FormzStatus.submissionInProgress));

        // Write data to db
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
        emit(state.copyWith(onboardingStage: OnboardingStage.stage2));
      }
    } else if (state.onboardingStage == OnboardingStage.stage2) {
      // Write data to db
      navigationBloc.add(const Pop());
    }
  }

  void previous() {
    if (state.onboardingStage == OnboardingStage.stage2) {
      emit(state.copyWith(onboardingStage: OnboardingStage.stage1));
    }
  }

  Future<void> finishOnboarding() async {
    if (!state.loading) {
      emit(state.copyWith(loading: true));

      var profilePictureUrl = currentUser.profilePicture;
      if (state.pickedPhoto != null) {
        profilePictureUrl = await storageRepository.uploadProfilePicture(
          currentUser.id,
          currentUser.profilePicture,
          state.pickedPhoto!,
        );
      }

      currentUser = currentUser.copyWith(
        username: state.username,
        artistName: state.artistName,
        profilePicture: profilePictureUrl,
        location: state.location,
        bio: state.bio,
      );

      await databaseRepository.createUser(currentUser);

      onboardingBloc.add(FinishOnboarding(user: currentUser));
    }
  }
}
