import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/create_post/cubit/create_post_cubit.dart';

class PostTitleTextField extends StatelessWidget {
  const PostTitleTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        return TextFormField(
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          decoration: const InputDecoration.collapsed(
            // prefixIcon: Icon(Icons.title),
            // labelText: 'Title (optional)',
            hintText: 'My glorious title',
          ),
          maxLength: 56,
          onChanged: (input) => context.read<CreatePostCubit>().onTitleChange(
                input,
              ),
        );
      },
    );
  }
}
