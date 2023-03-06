import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/upload_loop/upload_loop_cubit.dart';

class TitleInput extends StatelessWidget {
  const TitleInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadLoopCubit, UploadLoopState>(
      builder: (context, state) {
        return TextField(
          maxLength: 15,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Title',
            hintText: state.loopTitle.value,
            errorText: state.loopTitle.isNotValid ? 'invalid' : null,
          ),
          onChanged: (title) =>
              context.read<UploadLoopCubit>().titleChanged(title),
        );
      },
    );
  }
}
