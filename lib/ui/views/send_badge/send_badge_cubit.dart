import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:uuid/uuid.dart';

part 'send_badge_state.dart';

class SendBadgeCubit extends Cubit<SendBadgeState> {
  SendBadgeCubit({
    required this.currentUser,
    required this.navigationBloc,
    required this.databaseRepository,
    required this.storageRepository,
  }) : super(SendBadgeState());

  final UserModel currentUser;
  final NavigationBloc navigationBloc;
  final DatabaseRepository databaseRepository;
  final StorageRepository storageRepository;

  void changeReceiverUsername(String? value) =>
      emit(state.copyWith(receiverUsername: value));

  void handleImageFromGallery() async {
    try {
      final imageFile =
          await state.picker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        emit(state.copyWith(badgeImage: File(imageFile.path)));
      }
    } catch (error) {
      print(error);
    }
  }

  void sendBadge() async {
    print(state.formKey);
    if (state.formKey.currentState == null) {
      return;
    }

    state.formKey.currentState!.save();

    if (state.formKey.currentState!.validate() &&
        !state.status.isSubmissionInProgress) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      // Send badgeImage to storage
      if (state.badgeImage == null) {
        emit(state.copyWith(status: FormzStatus.invalid));
        return;
      }

      UserModel? badgeReceiver =
          await databaseRepository.getUserByUsername(state.receiverUsername);

      if (badgeReceiver == null) {
        emit(state.copyWith(status: FormzStatus.invalid));
        return;
      }

      String badgeImageUrl = await storageRepository.uploadBadgeImage(
        badgeReceiver.id,
        state.badgeImage!,
      );

      // create badge object
      Badge badge = Badge(
        id: Uuid().v4(),
        senderId: currentUser.id,
        receiverId: badgeReceiver.id,
        imageUrl: badgeImageUrl,
      );

      // Send badge to DB
      await databaseRepository.createBadge(badge);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
      navigationBloc.add(Pop());
    }
  }
}
