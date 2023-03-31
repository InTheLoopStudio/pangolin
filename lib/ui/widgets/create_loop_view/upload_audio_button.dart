import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/create_loop/cubit/create_loop_cubit.dart';
import 'package:intheloopapp/ui/widgets/create_loop_view/audio_container.dart';

class UploadAudioButton extends StatelessWidget {
  const UploadAudioButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateLoopCubit, CreateLoopState>(
      builder: (context, state) {
        return state.pickedAudio == null
            ? FilledButton.icon(
                onPressed: () =>
                    context.read<CreateLoopCubit>().handleAudioFromFiles(),
                icon: const Icon(
                  Icons.upload_file,
                  color: Colors.white,
                ),
                label: const Text(
                  'Upload Audio (optional)',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            : const AudioContainer();
      },
    );
  }
}
