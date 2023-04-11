import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              height: 40,
              child: TextField(
                onChanged: (value) =>
                    context.read<CommentsCubit>().changeComment(value),
                controller: _textEditingController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                minLines: 3,
                decoration: const InputDecoration.collapsed(
                  // border: OutlineInputBorder(),
                  hintText: 'Add Comment...',
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                await context.read<CommentsCubit>().addComment();
                _textEditingController.clear();
              },
              icon: state.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.send),
            ),
          ],
        );
      },
    );
  }
}
