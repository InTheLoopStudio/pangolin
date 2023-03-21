import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/upload_loop/upload_loop_cubit.dart';

class UploadLoopSplashView extends StatelessWidget {
  const UploadLoopSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadLoopCubit, UploadLoopState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.fileArrowUp,
                    size: 150,
                  ),
                  const SizedBox(height: 50),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 50,
                    color: tappedAccent,
                    textColor: Colors.white,
                    onPressed: () =>
                        context.read<UploadLoopCubit>().handleAudioFromFiles(),
                    child: const Text(
                      'Upload New Loop',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
