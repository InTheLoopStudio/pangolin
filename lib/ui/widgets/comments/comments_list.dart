import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/common/comments/comments_cubit.dart';
import 'package:intheloopapp/ui/widgets/comments/comment_container.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsCubit, CommentsState>(
      builder: (context, state) {
        return SliverList.builder(
          itemCount: state.comments.length,
          itemBuilder: (BuildContext context, index) {
            return Column(
              children: [
                CommentContainer(
                  comment: state.comments[index],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
