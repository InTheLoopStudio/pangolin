import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';

class Comments extends StatelessWidget {
  const Comments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopContainerCubit, LoopContainerState>(
      builder: (context, state) {
        NavigationBloc navigationBloc = context.read<NavigationBloc>();
        return GestureDetector(
          onTap: () => navigationBloc.add(PushLoop(
            state.loop,
            showComments: true,
            autoPlay: false,
          )),
          child: Row(
            children: [
              const SizedBox(width: 20.0),
              Icon(
                Icons.comment,
                size: 20,
              ),
              const SizedBox(width: 5.0),
              Text(
                state.loop.comments.toString() + ' comments',
                style: TextStyle(
                  fontSize: 10,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
