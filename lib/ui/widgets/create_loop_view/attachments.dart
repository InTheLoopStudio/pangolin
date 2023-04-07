import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/create_loop/cubit/create_loop_cubit.dart';
import 'package:intheloopapp/ui/widgets/create_loop_view/audio_container.dart';
import 'package:intheloopapp/ui/widgets/create_loop_view/upload_audio_button.dart';
import 'package:intheloopapp/ui/widgets/create_loop_view/upload_image_button.dart';

class Attachments extends StatelessWidget {
  const Attachments({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateLoopCubit, CreateLoopState>(
      builder: (context, state) {
        if (state.pickedAudio != null) {
          return const AudioContainer();
        }

        if (state.pickedImage != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.file(state.pickedImage!),
          );
        }

        return const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            UploadAudioButton(),
            SizedBox(
              width: 12,
            ),
            UploadImageButton(),
          ],
        );
      },
    );
  }
}
