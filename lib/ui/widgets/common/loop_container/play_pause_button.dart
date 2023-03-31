import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/controllers/audio_controller.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';
import 'package:just_audio/just_audio.dart';

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
          return Container(
            margin: const EdgeInsets.all(8),
            width: 20,
            height: 20,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            iconSize: 32,
            onPressed: audioController.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause),
            iconSize: 32,
            onPressed: audioController.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            iconSize: 24,
            onPressed: () => audioController.seek(
              Duration.zero,
              index: audioController.effectiveIndices!.first,
            ),
          );
        }
      },
    );
  }
}
