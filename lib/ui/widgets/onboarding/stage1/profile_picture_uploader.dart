import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_flow_cubit.dart';

class ProfilePictureUploader extends StatelessWidget {
  const ProfilePictureUploader({super.key});

  ImageProvider displayProfileImage(
    File? newProfileImage,
    String currentProfileImage,
  ) {
    if (newProfileImage != null) {
      return FileImage(newProfileImage);
    }
    return currentProfileImage.isEmpty
        ? const AssetImage(
            'assets/default_avatar.png',
          ) as ImageProvider
        : CachedNetworkImageProvider(currentProfileImage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthenticationBloc, AuthenticationState, Authenticated>(
      selector: (state) => state as Authenticated,
      builder: (context, userState) {
        return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => context
                      .read<OnboardingFlowCubit>()
                      .handleImageFromGallery(),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: displayProfileImage(
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
                          children: const [
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
