import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/common/comments/comments_cubit.dart';

class CommentsTextField extends StatefulWidget {
  const CommentsTextField({super.key});

  @override
  CommentsTextFieldState createState() => CommentsTextFieldState();
}

class CommentsTextFieldState extends State<CommentsTextField> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsCubit, CommentsState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 300,
              height: 20,
              child: TextField(
                onChanged: (value) =>
                    context.read<CommentsCubit>().changeComment(value),
                controller: _textEditingController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Add Comment...',
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                context.read<CommentsCubit>().addComment();
                _textEditingController.clear();
              },
              backgroundColor: tappedAccent,
              child: state.loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.comment),
            ),
          ],
        );
      },
    );
  }
}
