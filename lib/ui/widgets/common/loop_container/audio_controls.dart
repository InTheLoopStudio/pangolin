import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:intheloopapp/domains/controllers/audio_controller.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_seek_bar.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/play_pause_button.dart';
import 'package:skeletons/skeletons.dart';

class AudioControls extends StatelessWidget {
  const AudioControls({
    required this.audioPath,
    required this.title,
    required this.artist,
    required this.profilePicture,
    super.key,
  });

  final String audioPath;
  final String title;
  final String artist;
  final String? profilePicture;

  @override
  Widget build(BuildContext context) {
    if (audioPath.isEmpty) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<AudioController?>(
      future: AudioController.fromUrl(
        audioRepo: RepositoryProvider.of<AudioRepository>(context),
        url: audioPath,
        title: title,
        artist: artist,
        image: profilePicture,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SkeletonListTile();
        }

        final audioController = snapshot.data!;

        return Column(
          children: [
            Row(
              children: [
                PlayPauseButton(
                  audioController: audioController,
                ),
                Expanded(
                  child: LoopSeekBar(
                    audioController: audioController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
          ],
        );
      },
    );
  }
}
