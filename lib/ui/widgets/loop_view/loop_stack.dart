import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/common/comments/comments_section.dart';
import 'package:intheloopapp/ui/views/common/loading/loop_loading_view.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';
import 'package:intheloopapp/ui/widgets/loop_view/background.dart';
import 'package:intheloopapp/ui/widgets/loop_view/foreground.dart';

class LoopStack extends StatelessWidget {
  const LoopStack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopViewCubit, LoopViewState>(
      builder: (context, state) {
        return Stack(
          children: state.loadingLoop
              ? [const LoopLoadingView()]
              : [
                  const Background(),
                  const Foreground(),
                  if (state.showComments) const CommentsSection() else const SizedBox.shrink(),
                ],
        );
      },
    );
  }
}
