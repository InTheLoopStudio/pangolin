import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/upload_loop/upload_loop_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/seek_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioContainer extends StatelessWidget {
  const AudioContainer({Key? key}) : super(key: key);

  static const String audioLockId = 'uploaded-loop';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<UploadLoopCubit, UploadLoopState>(
      builder: (context, state) {
        return state.pickedAudio == null
            ? const SizedBox.shrink()
            : Column(
                children: [
                  Text(state.pickedAudio!.path.split('/').last),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.background,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            StreamBuilder<PlayerState>(
                              stream: state
                                  .audioController.player.playerStateStream,
                              builder: (context, snapshot) {
                                final playerState = snapshot.data;

                                if (playerState == null) {
                                  return const SizedBox.shrink();
                                }

                                final processingState =
                                    playerState.processingState;

                                if (processingState == ProcessingState.idle) {
                                  state.audioController
                                      .setAudioFile(state.pickedAudio);
                                }
                                final playing = playerState.playing;
                                if (processingState ==
                                        ProcessingState.loading ||
                                    processingState ==
                                        ProcessingState.buffering) {
                                  return Container(
                                    margin: const EdgeInsets.all(8),
                                    width: 48,
                                    height: 48,
                                    child: const CircularProgressIndicator(),
                                  );
                                } else if (playing != true) {
                                  return IconButton(
                                    icon: const Icon(Icons.play_arrow),
                                    iconSize: 48,
                                    onPressed: () {
                                      state.audioController.play(audioLockId);
                                    },
                                  );
                                } else if (processingState !=
                                    ProcessingState.completed) {
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
                                      index: state.audioController.player
                                          .effectiveIndices!.first,
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                StreamBuilder<Duration?>(
                                  stream: state
                                      .audioController.player.durationStream,
                                  builder: (context, snapshot) {
                                    final duration =
                                        snapshot.data ?? Duration.zero;
                                    return StreamBuilder<PositionData>(
                                      stream: Rx.combineLatest2<Duration,
                                          Duration, PositionData>(
                                        state.audioController.player
                                            .positionStream,
                                        state.audioController.player
                                            .bufferedPositionStream,
                                        (position, bufferedPosition) =>
                                            PositionData(
                                          position,
                                          bufferedPosition,
                                        ),
                                      ),
                                      builder: (context, snapshot) {
                                        final positionData = snapshot.data ??
                                            PositionData(
                                              Duration.zero,
                                              Duration.zero,
                                            );
                                        var position = positionData.position;
                                        if (position > duration) {
                                          position = duration;
                                        }
                                        var bufferedPosition =
                                            positionData.bufferedPosition;
                                        if (bufferedPosition > duration) {
                                          bufferedPosition = duration;
                                        }
                                        return SeekBar(
                                          duration: duration,
                                          position: position,
                                          bufferedPosition: bufferedPosition,
                                          onChangeEnd: (newPosition) {
                                            state.audioController.seek(
                                              newPosition ?? Duration.zero,
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
      },
    );
  }
}
