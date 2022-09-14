import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/common/comments/comments_cubit.dart';

class CommentsTextField extends StatefulWidget {
  const CommentsTextField({Key? key}) : super(key: key);

  @override
  _CommentsTextFieldState createState() => _CommentsTextFieldState();
}

class _CommentsTextFieldState extends State<CommentsTextField> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsCubit, CommentsState>(
      builder: (context, state) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 300,
                height: 20,
                child: TextField(
                  onChanged: (value) =>
                      context.read<CommentsCubit>().changeComment(value),
                  controller: _textEditingController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
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
                    ? CircularProgressIndicator(color: Colors.white)
                    : Icon(Icons.comment),
              ),
            ],
          ),
        );
      },
    );
  }
}
