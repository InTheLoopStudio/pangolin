import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopContainerCubit, LoopContainerState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () =>
              context.read<NavigationBloc>().add(PushLikes(state.loop)),
          child: Row(
            children: [
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => context.read<LoopContainerCubit>().likeLoop(),
                child: Icon(
                  state.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: state.isLiked ? tappedAccent : Colors.black,
                  size: 20,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '${state.likeCount}',
                style: const TextStyle(
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
