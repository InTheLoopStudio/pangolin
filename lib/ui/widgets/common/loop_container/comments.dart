import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';

class Comments extends StatelessWidget {
  const Comments({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopContainerCubit, LoopContainerState>(
      builder: (context, state) {
        final navigationBloc = context.read<NavigationBloc>();
        return GestureDetector(
          onTap: () => navigationBloc.add(
            PushLoop(
              state.loop,
              const None(),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              const Icon(
                Icons.comment,
                size: 20,
                color: Color(0xFF757575),
              ),
              const SizedBox(width: 5),
              Text(
                '${state.loop.commentCount}',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF757575),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
