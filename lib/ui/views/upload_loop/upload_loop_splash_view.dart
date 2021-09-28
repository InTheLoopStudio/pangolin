import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/upload_loop/upload_loop_cubit.dart';

class UploadLoopSplashView extends StatelessWidget {
  const UploadLoopSplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadLoopCubit, UploadLoopState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.fileUpload,
                    size: 150,
                  ),
                  const SizedBox(height: 50),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 50,
                    color: itlAccent,
                    textColor: Colors.white,
                    onPressed: () =>
                        context.read<UploadLoopCubit>().handleAudioFromFiles(),
                    child: Text(
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
