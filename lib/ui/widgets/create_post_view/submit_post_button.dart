import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/ui/views/create_post/cubit/create_post_cubit.dart';

class SubmitPostButton extends StatelessWidget {
  const SubmitPostButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        return FloatingActionButton.extended(
          // color: tappedAccent,
          onPressed: () => context.read<CreatePostCubit>().createPost(),
          icon: const Icon(
            Icons.edit_outlined,
          ),
          label: state.status.isInProgress
              ? const CircularProgressIndicator()
              : const Text('Create Post'),
        );
      },
    );
  }
}
