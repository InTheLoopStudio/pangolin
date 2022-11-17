import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';
import 'package:just_audio/just_audio.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopContainerCubit, LoopContainerState>(
      builder: (context, state) {
        return StreamBuilder<PlayerState>(
          stream: state.audioController.player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;

            if (playerState == null) {
              return const SizedBox.shrink();
            }

            final processingState = playerState.processingState;

            if (processingState == ProcessingState.idle) {
              state.audioController.setURL(state.loop.audioPath);
            }

            final playing = playerState.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8),
                width: 40,
                height: 40,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 48,
                onPressed: () {
                  state.audioController.play(state.loop.id);
                },
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 48,
                onPressed: () {
                  state.audioController.pause();
                },
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 48,
                onPressed: () => state.audioController.seek(
                  Duration.zero,
                  index: state.audioController.player.effectiveIndices!.first,
                ),
              );
            }
          },
        );
      },
    );
  }
}
