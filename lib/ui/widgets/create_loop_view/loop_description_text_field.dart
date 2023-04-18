import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/linkify.dart';
import 'package:intheloopapp/ui/views/create_loop/cubit/create_loop_cubit.dart';
import 'package:transparent_pointer/transparent_pointer.dart';

class LoopDescriptionTextField extends StatelessWidget {
  const LoopDescriptionTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateLoopCubit, CreateLoopState>(
      builder: (context, state) {
        return Stack(
          children: [
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration.collapsed(
                hintText: "What's on your mind?",
              ),
              style: const TextStyle(
                letterSpacing: 0,
                color: Colors.transparent,
              ),
              maxLength: 256,
              minLines: 6,
              validator: (value) =>
                  value!.isEmpty ? 'Description cannot be empty' : null,
              onChanged: (input) =>
                  context.read<CreateLoopCubit>().onDescriptionChange(
                        input.trim(),
                      ),
            ),
            TransparentPointer(
              child: SelectableLinkify(
                text: state.description.value,
                options: const LinkifyOptions(humanize: false),
              ),
            ),
          ],
        );
      },
    );
  }
}
