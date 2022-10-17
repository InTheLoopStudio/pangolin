import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/ui/views/login/login_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/forms/apple_login_button.dart';
import 'package:intheloopapp/ui/widgets/common/forms/google_login_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key, this.authenticationBloc}) : super(key: key);
  final AuthenticationBloc? authenticationBloc;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Authentication Failure'),
              ),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/tapped_logo_reversed.png',
                ),
                const SizedBox(height: 80),
                GoogleLoginButton(
                  onPressed: context.read<LoginCubit>().signInWithGoogle,
                ),
                const SizedBox(height: 20),
                if (Platform.isIOS)
                  AppleLoginButton(
                    onPressed: context.read<LoginCubit>().signInWithApple,
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
