import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/controllers/audio_controller.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    required this.audioController,
    super.key,
  });

  final AudioController audioController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioController.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;

        if (playerState == null) {
          return const SizedBox.shrink();
        }

        final processingState = playerState.processingState;

        final playing = playerState.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return FloatingActionButton(
            heroTag: 'playPauseButton-${audioController.title}',
            onPressed: null,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.play_arrow,
              size: 32,
            ),
          );
        } else if (!playing) {
          return FloatingActionButton(
            heroTag:
                'playPauseButton-${audioController.title}-${const Uuid().v4()}',
            onPressed: audioController.play,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.play_arrow,
              size: 32,
            ),
          );
        } else if (processingState != ProcessingState.completed) {
          return FloatingActionButton(
            heroTag: 'playPauseButton-${audioController.title}',
            onPressed: audioController.pause,
            child: const Icon(
              Icons.pause,
              size: 32,
            ),
          );
        } else {
          return FloatingActionButton(
            heroTag: 'playPauseButton-${audioController.title}',
            onPressed: () => audioController.seek(
              Duration.zero,
              index: audioController.effectiveIndices!.first,
            ),
            child: const Icon(
              Icons.replay,
              size: 24,
            ),
          );
        }
      },
    );
  }
}
