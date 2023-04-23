import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/ui/views/create_loop/cubit/create_loop_cubit.dart';

class SubmitLoopButton extends StatelessWidget {
  const SubmitLoopButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateLoopCubit, CreateLoopState>(
      builder: (context, state) {
        return FloatingActionButton.extended(
          // color: tappedAccent,
          heroTag: 'submitLoopButton',
          onPressed: () {
            try {
              context.read<CreateLoopCubit>().createLoop();
            } on Exception {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Error Uploading Loop'),
                ),
              );
            }
          },
          icon: const Icon(
            Icons.edit_outlined,
          ),
          label: state.status.isInProgress
              ? const CircularProgressIndicator(
                color: Colors.white,
              )
              : const Text('Create Loop'),
        );
      },
    );
  }
}
