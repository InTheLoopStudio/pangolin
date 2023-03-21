import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/common/comments/comments_cubit.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';

class CommentsHeader extends StatelessWidget {
  const CommentsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsCubit, CommentsState>(
      builder: (context, state) {
        return Container(
          height: 50,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: tappedAccent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${state.commentsCount} comments',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => context.read<LoopViewCubit>().toggleComments(),
                child: Container(
                  height: 45,
                  width: 45,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Icon(
                    Icons.cancel,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
