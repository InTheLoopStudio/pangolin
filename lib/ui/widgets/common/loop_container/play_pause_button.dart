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
              return SizedBox.shrink();
            }

            final processingState = playerState.processingState;

            if (processingState == ProcessingState.idle) {
              state.audioController.setURL(state.loop.audio!);
            }

            final playing = playerState.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 40.0,
                height: 40.0,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_arrow),
                iconSize: 48.0,
                onPressed: () {
                  state.audioController.play(state.loop.id);
                },
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause),
                iconSize: 48.0,
                onPressed: () {
                  state.audioController.pause();
                },
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay),
                iconSize: 48.0,
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
