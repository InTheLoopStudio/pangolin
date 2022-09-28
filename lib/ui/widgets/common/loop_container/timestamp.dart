import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;

class Timestamp extends StatelessWidget {
  const Timestamp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopContainerCubit, LoopContainerState>(
      builder: (context, state) {
        return Text(
          timeago.format(
            state.loop.timestamp,
            locale: 'en_short',
          ),
          style: const TextStyle(
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
