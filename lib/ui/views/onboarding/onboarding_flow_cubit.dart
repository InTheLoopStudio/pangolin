import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/models/username.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
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
  }) : super(OnboardingFlowState(currentUserId: currentAuthUser.uid));

  final OnboardingBloc onboardingBloc;
  final NavigationBloc navigationBloc;
  final AuthenticationBloc authenticationBloc;
  final StorageRepository storageRepository;
  final DatabaseRepository databaseRepository;
  final User currentAuthUser;

  void usernameChange(String input) => emit(state.copyWith(username: input));
  void aristNameChange(String input) => emit(state.copyWith(artistName: input));
  void locationChange(Place? place, String placeId) {
    emit(
      state.copyWith(
        place: place,
        placeId: placeId,
      ),
    );
  }

  void bioChange(String input) => emit(state.copyWith(bio: input));

  Future<void> handleImageFromGallery() async {
    try {
      final imageFile =
          await state.picker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        emit(state.copyWith(pickedPhoto: File(imageFile.path)));
      }
    } catch (e) {
      // print(error);
    }
  }

  Future<void> finishOnboarding() async {
    if (!state.loading) {
      emit(state.copyWith(loading: true));

      try {
        final profilePictureUrl = state.pickedPhoto != null
            ? await storageRepository.uploadProfilePicture(
                currentAuthUser.uid,
                state.pickedPhoto!,
              )
            : null;

        final lat = state.place?.latLng?.lat;
        final lng = state.place?.latLng?.lng;
        final geohash = (lat != null && lng != null)
            ? geocodeEncode(lat: lat, lng: lng)
            : null;

        final emptyUser = UserModel.empty();
        final currentUser = emptyUser.copyWith(
          id: currentAuthUser.uid,
          email: currentAuthUser.email,
          username: Username.fromString(state.username),
          artistName: state.artistName,
          profilePicture: profilePictureUrl,
          bio: state.bio,
          placeId: Option.fromNullable(state.placeId),
          geohash: Option.fromNullable(geohash),
          lat: Option.fromNullable(lat),
          lng: Option.fromNullable(lng),
        );

        await databaseRepository.createUser(currentUser);

        onboardingBloc.add(FinishOnboarding(user: currentUser));
      } catch (e, s) {
        await FirebaseCrashlytics.instance.recordError(e, s);
        emit(state.copyWith(loading: false));
      }
    }
  }
}
