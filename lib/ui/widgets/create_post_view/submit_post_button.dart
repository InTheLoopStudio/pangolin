import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/ui/views/create_post/cubit/create_post_cubit.dart';

class SubmitPostButton extends StatelessWidget {
  const SubmitPostButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        return CupertinoButton.filled(
          // color: tappedAccent,
          onPressed: () => context.read<CreatePostCubit>().createPost(),
          child: state.status.isInProgress
              ? const CircularProgressIndicator(
                  color: Colors.black,
                )
              : const Text('Post'),
        );
      },
    );
  }
}
