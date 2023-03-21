import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/create_post/cubit/create_post_cubit.dart';

class PostDescriptionTextField extends StatelessWidget {
  const PostDescriptionTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        return TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration.collapsed(
            hintText: "What's on your mind?",
          ),
          maxLength: 256,
          onChanged: (input) =>
              context.read<CreatePostCubit>().onDescriptionChange(
                    input,
                  ),
        );
      },
    );
  }
}
