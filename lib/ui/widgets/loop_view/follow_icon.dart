import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';

class FollowIcon extends StatelessWidget {
  const FollowIcon({Key? key}) : super(key: key);

  static const double actionWidgetSize = 60;
  static const double actionIconSize = 35;
  static const double profileImageSize = 50;
  static const double plusIconSize = 20;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopViewCubit, LoopViewState>(
      builder: (context, state) {
        return Positioned(
          left: (actionWidgetSize / 2) - (plusIconSize / 2),
          bottom: 0,
          child: Container(
            width: plusIconSize,
            height: plusIconSize,
            decoration: BoxDecoration(
              color: tappedAccent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              state.isFollowing ? Icons.check : Icons.add,
              color: Colors.white,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}
