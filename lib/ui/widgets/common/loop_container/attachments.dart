import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: imagePath,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
