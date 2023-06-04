import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/common/insta_image_viewer.dart';
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

    if (loop.audioPath.isSome) {
      return AudioControls(
        audioPath: loop.audioPath.unwrap,
        title: loop.title.unwrapOr('Untitled Loop'),
        artist: loopUser.displayName,
        profilePicture: loopUser.profilePicture,
      );
    }

    if (loop.imagePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    final imagePath = loop.imagePaths[0];

    if (imagePath.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            clipBehavior: Clip.hardEdge,
            child: InstaImageViewer(
              // tag: heroTag,
              child: CachedNetworkImage(
                imageUrl: imagePath,
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
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
