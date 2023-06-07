import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intheloopapp/app_logger.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/models/username.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/onboarding/artist_name_input.dart';
import 'package:intheloopapp/ui/views/onboarding/bio_input.dart';
import 'package:intheloopapp/ui/views/onboarding/username_input.dart';
import 'package:intheloopapp/utils.dart';

part 'onboarding_flow_state.dart';

class OnboardingFlowCubit extends Cubit<OnboardingFlowState> {
  OnboardingFlowCubit({
    required this.currentAuthUser,
    required this.onboardingBloc,
    required this.navigationBloc,
    required this.authenticationBloc,
    required this.storageRepository,
    required this.databaseRepository,
  }) : super(
          OnboardingFlowState(
            currentUserId: currentAuthUser.uid,
            artistName: ArtistNameInput.dirty(
              value: currentAuthUser.displayName ?? '',
            ),
          ),
        );

  final OnboardingBloc onboardingBloc;
  final NavigationBloc navigationBloc;
  final AuthenticationBloc authenticationBloc;
  final StorageRepository storageRepository;
  final DatabaseRepository databaseRepository;
  final User currentAuthUser;

  void usernameChange(String input) => emit(
        state.copyWith(
          username: UsernameInput.dirty(value: input),
        ),
      );
  void aristNameChange(String input) => emit(
        state.copyWith(
          artistName: ArtistNameInput.dirty(value: input),
        ),
      );
  void locationChange(Place? place, String placeId) {
    emit(
      state.copyWith(
        place: Option.fromNullable(place),
        placeId: Some(placeId),
      ),
    );
  }

  // ignore: avoid_positional_boolean_parameters
  void eulaChange(bool input) => emit(
        state.copyWith(
          eula: input,
        ),
      );

  void bioChange(String input) => emit(
        state.copyWith(
          bio: BioInput.dirty(value: input),
        ),
      );

  Future<void> handleImageFromGallery() async {
    try {
      final imageFile =
          await state.picker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        emit(
          state.copyWith(
            pickedPhoto: Some(File(imageFile.path)),
          ),
        );
      }
    } catch (e) {
      // print(error);
    }
  }

  Future<void> finishOnboarding() async {
    if (state.status.isInProgress) {
      return;
    }

    if (!state.formKey.currentState!.validate()) {
      return;
    }

    if (state.isNotValid) {
      return;
    }

    if (!state.eula) {
      throw Exception('You must agree to the EULA');
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final profilePictureUrl = await switch (state.pickedPhoto) {
        Some(:final value) => () async {
            final url = await storageRepository.uploadProfilePicture(
              currentAuthUser.uid,
              value,
            );
            return Some(url);
          }(),
        None() => Future.value(const None<String>()),
      };

      final lat = state.place.asNullable()?.latLng?.lat;
      final lng = state.place.asNullable()?.latLng?.lng;
      final geohash = (lat != null && lng != null)
          ? geocodeEncode(lat: lat, lng: lng)
          : null;

      final emptyUser = UserModel.empty();
      final currentUser = emptyUser.copyWith(
        id: currentAuthUser.uid,
        email: currentAuthUser.email,
        username: Username.fromString(state.username.value),
        artistName: state.artistName.value,
        profilePicture: profilePictureUrl.asNullable(),
        bio: state.bio.value,
        placeId: state.placeId,
        geohash: Option.fromNullable(geohash),
        lat: Option.fromNullable(lat),
        lng: Option.fromNullable(lng),
      );

      await databaseRepository.createUser(currentUser);

      onboardingBloc.add(FinishOnboarding(user: currentUser));
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e, s) {
      logger.error('error finishing onboarding', error: e, stackTrace: s);
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
