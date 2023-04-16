import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/create_loop/cubit/create_loop_cubit.dart';

class UploadImageButton extends StatelessWidget {
  const UploadImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateLoopCubit, CreateLoopState>(
      builder: (context, state) {
        return Ink(
          decoration: const ShapeDecoration(
            color: tappedAccent,
            shape: CircleBorder(),
          ),
          child: IconButton(
            onPressed: () {
              try {
                context.read<CreateLoopCubit>().handleImageFromFiles();
              } on Exception catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                  ),
                );
              }
            },
            icon: const Icon(
              Icons.image_outlined,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
