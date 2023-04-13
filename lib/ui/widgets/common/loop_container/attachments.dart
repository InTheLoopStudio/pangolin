import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/audio_controls.dart';

class Attachments extends StatelessWidget {
  const Attachments({
    required this.loop,
    required this.loopUser,
    super.key,
  });

  final Loop loop;
  final UserModel loopUser;

  @override
  Widget build(BuildContext context) {
    if (loop.audioPath.isNotEmpty) {
      return AudioControls(
        audioPath: loop.audioPath,
        title: loop.title,
        artist: loopUser.displayName,
        profilePicture: loopUser.profilePicture,
      );
    }

    if (loop.imagePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    final imagePath = loop.imagePaths[0];

    if (imagePath.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: GestureDetector(
          onTap: () {
            context.read<NavigationBloc>().add(
                  PushPhotoView(
                    imageUrl: imagePath,
                  ),
                );
          },
          child: Hero(
            tag: imagePath,
            child: CachedNetworkImage(
              imageUrl: imagePath,
              imageBuilder: (context, imageProvider) => Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(
                color: tappedAccent,
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
