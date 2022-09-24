import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/forms/apple_login_button.dart';
import 'package:intheloopapp/ui/widgets/common/forms/google_login_button.dart';

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return TextButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              elevation: 5.0,
              title: Text('Reauthenticate'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: state.status.isSubmissionInProgress
                    ? [CircularProgressIndicator()]
                    : [
                        Text(
                          'Warning: this cannot be undone',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20.0),
                        GoogleLoginButton(
                          onPressed:
                              context.read<SettingsCubit>().reauthWithGoogle,
                        ),
                        const SizedBox(height: 10.0),
                        Platform.isIOS
                            ? AppleLoginButton(
                                onPressed: context
                                    .read<SettingsCubit>()
                                    .reauthWithApple,
                              )
                            : SizedBox.shrink(),
                      ],
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: Navigator.of(context).pop,
                )
              ],
            ),
          ),
          child: Text(
            'Delete Account',
            style: TextStyle(
              color: Colors.red[300],
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
