import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/controllers/audio_controller.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/seek_bar.dart';
import 'package:rxdart/rxdart.dart';

class LoopSeekBar extends StatelessWidget {
  const LoopSeekBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopContainerCubit, LoopContainerState>(
      builder: (context, state) {
        return StreamBuilder<Duration?>(
          stream: state.audioController.durationStream,
          builder: (context, snapshot) {
            final duration = snapshot.data ?? Duration.zero;
            return StreamBuilder<PositionData>(
              stream: Rx.combineLatest2<Duration, Duration, PositionData>(
                state.audioController.positionStream,
                state.audioController.bufferedPositionStream,
                PositionData.new,
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
                var bufferedPosition = positionData.bufferedPosition;
                if (bufferedPosition > duration) {
                  bufferedPosition = duration;
                }
                return SeekBar(
                  duration: duration,
                  position: position,
                  bufferedPosition: bufferedPosition,
                  onChangeEnd: (newPosition) {
                    state.audioController.seek(newPosition);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
