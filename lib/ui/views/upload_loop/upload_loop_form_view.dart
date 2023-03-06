import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/ui/views/upload_loop/upload_loop_cubit.dart';
import 'package:intheloopapp/ui/widgets/upload_loop_view/audio_container.dart';
import 'package:intheloopapp/ui/widgets/upload_loop_view/title_input.dart';
import 'package:intheloopapp/ui/widgets/upload_loop_view/upload_button.dart';

class UploadLoopFormView extends StatelessWidget {
  const UploadLoopFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Upload Loop',
        ),
        actions: [
          TextButton(
            onPressed: () => context.read<UploadLoopCubit>().cancelUpload(),
            child: const Text('cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      floatingActionButton: const UploadButton(),
      body: BlocListener<UploadLoopCubit, UploadLoopState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Upload Failed'),
                ),
              );
          }
        },
        child: const Align(
          alignment: Alignment(0, -1 / 3),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AudioContainer(),
                  SizedBox(height: 40),
                  TitleInput(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
