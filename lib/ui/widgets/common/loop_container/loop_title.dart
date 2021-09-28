import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';

class LoopTitle extends StatelessWidget {
  const LoopTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopContainerCubit, LoopContainerState>(
      builder: (context, state) {
        return Text(
          state.loop.title ?? '',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }
}
