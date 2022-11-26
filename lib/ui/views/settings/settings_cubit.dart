import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required this.navigationBloc,
    required this.authenticationBloc,
    required this.authRepository,
    required this.databaseRepository,
    required this.storageRepository,
    required this.currentUser,
  }) : super(SettingsState());

  final UserModel currentUser;
  final NavigationBloc navigationBloc;
  final AuthenticationBloc authenticationBloc;
  final AuthRepository authRepository;
  final DatabaseRepository databaseRepository;
  final StorageRepository storageRepository;

  void initUserData() {
    emit(
      state.copyWith(
        username: currentUser.username,
        artistName: currentUser.artistName,
        bio: currentUser.bio,
        location: currentUser.location,
        twitterHandle: currentUser.twitterHandle,
        instagramHandle: currentUser.instagramHandle,
        tiktokHandle: currentUser.tiktokHandle,
        soundcloudHandle: currentUser.soundcloudHandle,
        youtubeChannelId: currentUser.youtubeChannelId,
        pushNotificationsLikes: currentUser.pushNotificationsLikes,
        pushNotificationsComments: currentUser.pushNotificationsComments,
        pushNotificationsFollows: currentUser.pushNotificationsComments,
        pushNotificationsDirectMessages:
            currentUser.pushNotificationsDirectMessages,
        pushNotificationsITLUpdates: currentUser.pushNotificationsITLUpdates,
        emailNotificationsAppReleases:
            currentUser.emailNotificationsAppReleases,
        emailNotificationsITLUpdates: currentUser.emailNotificationsITLUpdates,
      ),
    );
  }

  void changeBio(String value) => emit(state.copyWith(bio: value));
  void changeUsername(String value) => emit(state.copyWith(username: value));
  void changeArtistName(String value) =>
      emit(state.copyWith(artistName: value));
  void changeTwitter(String value) =>
      emit(state.copyWith(twitterHandle: value));
  void changeInstagram(String value) =>
      emit(state.copyWith(instagramHandle: value));
  void changeTikTik(String value) => emit(state.copyWith(tiktokHandle: value));
  void changeSoundcloud(String value) =>
      emit(state.copyWith(soundcloudHandle: value));
  void changeYoutube(String value) =>
      emit(state.copyWith(youtubeChannelId: value));
  void changeLocation(String value) => emit(state.copyWith(location: value));

  void changeNewLikesPush({required bool selected}) =>
      emit(state.copyWith(pushNotificationsLikes: selected));
  void changeNewCommentsPush({required bool selected}) =>
      emit(state.copyWith(pushNotificationsComments: selected));
  void changeNewFollowerPush({required bool selected}) =>
      emit(state.copyWith(pushNotificationsFollows: selected));
  void changeDirectMsgPush({required bool selected}) =>
      emit(state.copyWith(pushNotificationsDirectMessages: selected));
  void changeITLUpdatesPush({required bool selected}) =>
      emit(state.copyWith(pushNotificationsITLUpdates: selected));
  void changeAllPush({required bool selected}) => emit(
        state.copyWith(
          pushNotificationsLikes: selected,
          pushNotificationsComments: selected,
          pushNotificationsFollows: selected,
          pushNotificationsDirectMessages: selected,
          pushNotificationsITLUpdates: selected,
        ),
      );

  void changeAppReleaseEmail({required bool selected}) =>
      emit(state.copyWith(emailNotificationsAppReleases: selected));
  void changeITLUpdatesEmail({required bool selected}) =>
      emit(state.copyWith(emailNotificationsITLUpdates: selected));
  void changeAllEmail({required bool selected}) => emit(
        state.copyWith(
          emailNotificationsAppReleases: selected,
          emailNotificationsITLUpdates: selected,
        ),
      );

  Future<void> handleImageFromGallery() async {
    try {
      final imageFile =
          await state.picker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        emit(state.copyWith(profileImage: File(imageFile.path)));
      }
    } on Exception {
      // print(error);
    }
  }

  Future<void> saveProfile() async {
    // print(state.formKey);
    if (state.formKey.currentState == null) {
      return;
    }

    state.formKey.currentState!.save();
    if (state.formKey.currentState!.validate() &&
        !state.status.isSubmissionInProgress) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      var profilePictureUrl = '';
      if (state.profileImage == null) {
        profilePictureUrl = currentUser.profilePicture;
      } else {
        profilePictureUrl = await storageRepository.uploadProfilePicture(
          currentUser.id,
          currentUser.profilePicture,
          state.profileImage!,
        );
      }

      final user = currentUser.copyWith(
        username: state.username,
        artistName: state.artistName,
        bio: state.bio,
        location: state.location,
        twitterHandle: state.twitterHandle,
        instagramHandle: state.instagramHandle,
        tiktokHandle: state.tiktokHandle,
        soundcloudHandle: state.soundcloudHandle,
        youtubeChannelId: state.youtubeChannelId,
        profilePicture: profilePictureUrl,
        pushNotificationsLikes: state.pushNotificationsLikes,
        pushNotificationsComments: state.pushNotificationsComments,
        pushNotificationsFollows: state.pushNotificationsFollows,
        pushNotificationsDirectMessages: state.pushNotificationsDirectMessages,
        pushNotificationsITLUpdates: state.pushNotificationsITLUpdates,
        emailNotificationsAppReleases: state.emailNotificationsAppReleases,
        emailNotificationsITLUpdates: state.emailNotificationsITLUpdates,
      );

      await databaseRepository.updateUserData(user);
      authenticationBloc.add(UpdateAuthenticatedUser(user.id));
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
      navigationBloc.add(const Pop());
    } else {
      // print('invalid');
    }
  }

  void logout() {
    authenticationBloc.add(LoggedOut());
  }

  Future<void> reauthWithGoogle() async {
    emit(
      state.copyWith(status: FormzStatus.submissionInProgress),
    );
    try {
      await authRepository.reauthenticateWithGoogle();
      deleteUser();
      emit(
        state.copyWith(status: FormzStatus.submissionSuccess),
      );
    } on Exception {
      // print(e);
      emit(
        state.copyWith(status: FormzStatus.submissionFailure),
      );
    // ignore: avoid_catching_errors
    } on NoSuchMethodError {
      emit(
        state.copyWith(status: FormzStatus.pure),
      );
    }
  }

  Future<void> reauthWithApple() async {
    emit(
      state.copyWith(status: FormzStatus.submissionInProgress),
    );
    try {
      await authRepository.reauthenticateWithApple();
      deleteUser();
      emit(
        state.copyWith(status: FormzStatus.submissionSuccess),
      );
    } on Exception {
      // print(e);
      emit(
        state.copyWith(status: FormzStatus.submissionFailure),
      );
    // ignore: avoid_catching_errors
    } on NoSuchMethodError {
      emit(
        state.copyWith(status: FormzStatus.pure),
      );
    }
  }

  void deleteUser() {
    authRepository.deleteUser();
    authenticationBloc.add(LoggedOut());
    navigationBloc
      ..add(const Pop())
      ..add(const Pop());
  }
}
