import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intheloopapp/app_logger.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/prod/firestore_database_impl.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/models/username.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/utils.dart';
import 'package:path/path.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required this.navigationBloc,
    required this.authenticationBloc,
    required this.onboardingBloc,
    required this.authRepository,
    required this.databaseRepository,
    required this.storageRepository,
    required this.places,
    required this.currentUser,
  }) : super(SettingsState());

  final UserModel currentUser;
  final NavigationBloc navigationBloc;
  final AuthenticationBloc authenticationBloc;
  final OnboardingBloc onboardingBloc;
  final AuthRepository authRepository;
  final DatabaseRepository databaseRepository;
  final StorageRepository storageRepository;
  final PlacesRepository places;

  void initUserData() {
    emit(
      state.copyWith(
        username: currentUser.username.toString(),
        artistName: currentUser.artistName,
        bio: currentUser.bio,
        genres: currentUser.genres,
        label: currentUser.label,
        occupations: currentUser.occupations,
        placeId: currentUser.placeId,
        twitterHandle: currentUser.twitterHandle,
        instagramHandle: currentUser.instagramHandle,
        tiktokHandle: currentUser.tiktokHandle,
        spotifyId: currentUser.spotifyId,
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

  Future<void> initPlace() async {
    try {
      final place = currentUser.placeId != null
          ? await places.getPlaceById(currentUser.placeId!)
          : null;
      emit(state.copyWith(place: place));
    } catch (e) {
      emit(state.copyWith());
    }
  }

  Future<void> initServices() async {
    final services = await databaseRepository.getUserServices(currentUser.id);
    emit(state.copyWith(services: services));
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
  void changeSpotify(String value) => emit(state.copyWith(spotifyId: value));
  void changeYoutube(String value) =>
      emit(state.copyWith(youtubeChannelId: value));
  void changePlace(Place? place, String placeId) {
    emit(
      state.copyWith(
        place: place,
        placeId: placeId,
      ),
    );
  }

  void changeGenres(List<Genre> genres) => emit(
        state.copyWith(genres: genres),
      );
  void removeGenre(Genre genre) {
    emit(
      state.copyWith(
        genres: state.genres..remove(genre),
      ),
    );
  }

  void changeOccupations(List<String> value) => emit(
        state.copyWith(occupations: value),
      );
  void removeOccupation(String occupation) {
    emit(
      state.copyWith(
        occupations: state.occupations..remove(occupation),
      ),
    );
  }

  void changeLabel(String? value) => emit(state.copyWith(label: value));

  void updateEmail(String? input) => emit(
        state.copyWith(email: input),
      );

  void updatePassword(String? input) => emit(
        state.copyWith(password: input),
      );

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

  void onServiceCreated(Service service) {
    emit(
      state.copyWith(
        services: List.of(state.services)..insert(0, service),
      ),
    );
  }

  Future<void> removeService(Service service) async {
    try {
      await databaseRepository.deleteService(
        currentUser.id,
        service.id,
      );
      emit(
        state.copyWith(
          services: List.of(state.services)..remove(service),
        ),
      );
    } catch (e, s) {
      logger.error(
        'Error removing service',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<void> handleImageFromGallery() async {
    try {
      final imageFile =
          await state.picker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        emit(state.copyWith(profileImage: File(imageFile.path)));
      }
    } catch (e) {
      // print(error);
    }
  }

  Future<void> saveProfile() async {
    // print(state.formKey);
    if (state.formKey.currentState == null) {
      return;
    }

    if (state.formKey.currentState!.validate() && !state.status.isInProgress) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      final available = await databaseRepository.checkUsernameAvailability(
        state.username,
        currentUser.id,
      );

      if (!available) {
        throw HandleAlreadyExistsException('Username already exists');
      }

      final profilePictureUrl = state.profileImage != null
          ? await storageRepository.uploadProfilePicture(
              currentUser.id,
              state.profileImage!,
            )
          : currentUser.profilePicture;

      final lat = state.place?.latLng?.lat;
      final lng = state.place?.latLng?.lng;
      final geohash = (lat != null && lng != null)
          ? geocodeEncode(lat: lat, lng: lng)
          : null;

      // placeId => geohash
      final user = currentUser.copyWith(
        username: Username.fromString(state.username),
        artistName: state.artistName,
        bio: state.bio,
        genres: state.genres,
        label: state.label,
        occupations: state.occupations,
        placeId: Option.fromNullable(state.placeId),
        geohash: Option.fromNullable(geohash),
        lat: Option.fromNullable(lat),
        lng: Option.fromNullable(lng),
        twitterHandle: state.twitterHandle,
        instagramHandle: state.instagramHandle,
        tiktokHandle: state.tiktokHandle,
        spotifyId: state.spotifyId,
        youtubeChannelId: state.youtubeChannelId,
        profilePicture: profilePictureUrl,
        pushNotificationsLikes: state.pushNotificationsLikes,
        pushNotificationsComments: state.pushNotificationsComments,
        pushNotificationsFollows: state.pushNotificationsFollows,
        pushNotificationsDirectMessages: state.pushNotificationsDirectMessages,
        pushNotificationsITLUpdates: state.pushNotificationsITLUpdates,
        emailNotificationsAppReleases: state.emailNotificationsAppReleases,
        emailNotificationsITLUpdates: state.emailNotificationsITLUpdates,
        // stripeConnectedAccountId: state.stripeConnectedAccountId,
      );

      onboardingBloc.add(UpdateOnboardedUser(user: user));
      emit(state.copyWith(status: FormzSubmissionStatus.success));
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
      state.copyWith(status: FormzSubmissionStatus.inProgress),
    );
    try {
      await authRepository.reauthenticateWithGoogle();
      await deleteUser();
      emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      );
    } catch (e) {
      // print(e);
      emit(
        state.copyWith(status: FormzSubmissionStatus.failure),
      );
    }
  }

  Future<void> reauthWithApple() async {
    emit(
      state.copyWith(status: FormzSubmissionStatus.inProgress),
    );
    try {
      await authRepository.reauthenticateWithApple();
      await deleteUser();
      emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      );
    } catch (e) {
      // print(e);
      emit(
        state.copyWith(status: FormzSubmissionStatus.failure),
      );
    }
  }

  Future<void> reauthWithCredentials() async {
    emit(
      state.copyWith(status: FormzSubmissionStatus.inProgress),
    );
    try {
      await authRepository.reauthenticateWithCredentials(
        state.email,
        state.password,
      );
      await deleteUser();
      emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      );
    } catch (e) {
      // print(e);
      emit(
        state.copyWith(status: FormzSubmissionStatus.failure),
      );
    }
  }

  Future<void> deleteUser() async {
    await authRepository.deleteUser();
    authenticationBloc.add(LoggedOut());
    navigationBloc
      ..add(const Pop())
      ..add(const Pop());
  }
}
