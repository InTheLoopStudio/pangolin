import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/create_loop/cubit/create_loop_cubit.dart';
import 'package:intheloopapp/ui/widgets/create_loop_view/audio_container.dart';

class UploadAudioButton extends StatelessWidget {
  const UploadAudioButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateLoopCubit, CreateLoopState>(
      builder: (context, state) {
        return state.pickedAudio == null
            ? Ink(
                decoration: const ShapeDecoration(
                  color: tappedAccent,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  onPressed: () {
                    try {
                      context.read<CreateLoopCubit>().handleAudioFromFiles();
                    } on Exception catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.audio_file_outlined,
                    color: Colors.white,
                  ),
                ),
              )
            : const AudioContainer();
      },
    );
  }
}
