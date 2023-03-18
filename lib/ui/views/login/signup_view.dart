import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/login/login_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/forms/apple_login_button.dart';
import 'package:intheloopapp/ui/widgets/common/forms/email_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/google_login_button.dart';
import 'package:intheloopapp/ui/widgets/common/forms/password_text_field.dart';
import 'package:intheloopapp/ui/widgets/login_view/confirm_signup_button.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocProvider(
        create: (context) => LoginCubit(
          authRepository: context.read<AuthRepository>(),
          navigationBloc: context.read<NavigationBloc>(),
        ),
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return Align(
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
                        height: 96,
                      ),
                      const SizedBox(height: 50),
                      EmailTextField(
                        onChanged: (input) => context
                            .read<LoginCubit>()
                            .updateEmail(input ?? ''),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PasswordTextField(
                        onChanged: (input) => context
                            .read<LoginCubit>()
                            .updatePassword(input ?? ''),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      PasswordTextField(
                        labelText: 'Confirm Password', 
                        onChanged: (input) => context
                            .read<LoginCubit>()
                            .updateConfirmPassword(input ?? ''),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const ConfirmSignUpButton(),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GoogleLoginButton(
                            onPressed:
                                context.read<LoginCubit>().signInWithGoogle,
                          ),
                          const SizedBox(width: 20),
                          if (Platform.isIOS)
                            AppleLoginButton(
                              onPressed:
                                  context.read<LoginCubit>().signInWithApple,
                            )
                          else
                            const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
