import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/login/login_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/forms/email_text_field.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  bool linkSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Password Reset'),
      ),
      body: BlocProvider(
        create: (context) => LoginCubit(
          authRepository: context.read<AuthRepository>(),
          navigationBloc: context.read<NavigationBloc>(),
        ),
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Align(
                child: linkSent
                    ? const Text('Password reset link send to your email')
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EmailTextField(
                            onChanged: context.read<LoginCubit>().updateEmail,
                          ),
                          const SizedBox(height: 30),
                          CupertinoButton.filled(
                            child: const Text('Send Reset Link'),
                            onPressed: () {
                              context
                                  .read<LoginCubit>()
                                  .sendResetPasswordLink();
                              setState(() {
                                linkSent = true;
                              });
                            },
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
