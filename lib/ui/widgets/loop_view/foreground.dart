import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';
import 'package:intheloopapp/ui/widgets/loop_view/actions_toolbar.dart';
import 'package:intheloopapp/ui/widgets/loop_view/audio_description.dart';
import 'package:intheloopapp/ui/widgets/loop_view/loop_seek_bar.dart';

class Foreground extends StatelessWidget {
  const Foreground({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopViewCubit, LoopViewState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AudioDescription(
                      user: state.user,
                      loop: state.loop,
                    ),
                  ],
                ),
                ActionsToolbar(
                  user: state.user,
                  loop: state.loop,
                )
              ],
            ),
            const Row(
              children:  [
                LoopSeekBar(),
              ],
            ),
            const SizedBox(height: 25)
          ],
        );
      },
    );
  }
}
