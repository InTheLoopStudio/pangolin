import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';

class FollowIcon extends StatelessWidget {
  const FollowIcon({Key? key}) : super(key: key);

  static const double ActionWidgetSize = 60.0;
  static const double ActionIconSize = 35.0;
  static const double ProfileImageSize = 50.0;
  static const double PlusIconSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopViewCubit, LoopViewState>(
      builder: (context, state) {
        return Positioned(
          left: (ActionWidgetSize / 2) - (PlusIconSize / 2),
          bottom: 0,
          child: Container(
            width: PlusIconSize,
            height: PlusIconSize,
            decoration: BoxDecoration(
              color: itlAccent,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Icon(
              state.isFollowing ? Icons.check : Icons.add,
              color: Colors.white,
              size: 20.0,
            ),
          ),
        );
      },
    );
  }
}
