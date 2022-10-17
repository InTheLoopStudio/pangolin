import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';

class ChangeProfileImage extends StatelessWidget {
  const ChangeProfileImage({Key? key}) : super(key: key);

  ImageProvider displayProfileImage(
    File? newProfileImage,
    String currentProfileImage,
  ) {
    if (newProfileImage == null) {
      if (currentProfileImage.isEmpty) {
        return const AssetImage('assets/default_avatar.png');
      } else {
        return CachedNetworkImageProvider(currentProfileImage);
      }
    } else {
      return FileImage(newProfileImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authRepo = RepositoryProvider.of<AuthRepository>(context);
    return StreamBuilder<UserModel>(
      stream: authRepo.user,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final user = snapshot.data!;

        return BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () =>
                  context.read<SettingsCubit>().handleImageFromGallery(),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: displayProfileImage(
                      state.profileImage,
                      user.profilePicture,
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
                          'Change Profile Picture',
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
            );
          },
        );
      },
    );
  }
}
