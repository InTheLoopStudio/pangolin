import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/upload_loop/upload_loop_cubit.dart';

class UploadAudioInput extends StatelessWidget {
  const UploadAudioInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<UploadLoopCubit, UploadLoopState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pick a file',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(width: 25),
            GestureDetector(
              onTap: () =>
                  context.read<UploadLoopCubit>().handleAudioFromFiles(),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: theme.colorScheme.background,
                  border: Border.all(
                    color: tappedAccent,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  FontAwesomeIcons.fileAudio,
                  size: 40,
                  color: tappedAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
