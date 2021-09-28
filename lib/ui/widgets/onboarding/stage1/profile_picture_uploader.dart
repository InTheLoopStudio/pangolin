import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_cubit.dart';

class ProfilePictureUploader extends StatelessWidget {
  const ProfilePictureUploader({Key? key}) : super(key: key);

  ImageProvider displayProfileImage(
    File? newProfileImage,
    String currentProfileImage,
  ) {
    if (newProfileImage == null) {
      if (currentProfileImage.isEmpty) {
        return AssetImage('assets/default_avatar.png');
      } else {
        return CachedNetworkImageProvider(currentProfileImage);
      }
    } else {
      return FileImage(newProfileImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthRepository authRepo = RepositoryProvider.of<AuthRepository>(context);

    return StreamBuilder<UserModel>(
      stream: authRepo.user,
      builder: (context, snapshot) {
        return BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () =>
                      context.read<OnboardingCubit>().handleImageFromGallery(),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: snapshot.hasData
                            ? displayProfileImage(
                                state.pickedPhoto,
                                snapshot.data!.profilePicture,
                              )
                            : displayProfileImage(
                                state.pickedPhoto,
                                '',
                              ),
                      ),
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.black54,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              'Upload Profile Picture',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
