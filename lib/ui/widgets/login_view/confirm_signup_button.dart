import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/login/login_cubit.dart';

class ConfirmSignUpButton extends StatelessWidget {
  const ConfirmSignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return CupertinoButton.filled(
          child: const Text('Sign Up'),
          onPressed: () => context.read<LoginCubit>().signUpWithCredentials(),
        );
      },
    );
  }
}
