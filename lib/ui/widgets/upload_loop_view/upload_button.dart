import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/upload_loop/upload_loop_cubit.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadLoopCubit, UploadLoopState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : Material(
                elevation: 5,
                color: tappedAccent,
                borderRadius: BorderRadius.circular(30),
                child: MaterialButton(
                  onPressed: state.isValid
                      ? () => context.read<UploadLoopCubit>().uploadLoop()
                      : null,
                  minWidth: 120,
                  height: 50,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.upload,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Upload',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
