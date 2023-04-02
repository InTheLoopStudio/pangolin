import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:intheloopapp/domains/controllers/audio_controller.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_seek_bar.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/play_pause_button.dart';

class AudioControls extends StatelessWidget {
  const AudioControls({
    required this.audioPath,
    super.key,
  });

  final String audioPath;

  @override
  Widget build(BuildContext context) {
    if (audioPath.isEmpty) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<AudioController>(
      future: AudioController.fromUrl(
        audioRepo: RepositoryProvider.of<AudioRepository>(context),
        url: audioPath,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final audioController = snapshot.data;

        return Column(
          children: [
            Row(
              children: [
                PlayPauseButton(
                  audioController: audioController!,
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
