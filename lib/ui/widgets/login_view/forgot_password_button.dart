import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = RepositoryProvider.of<NavigationBloc>(context);
    return CupertinoButton(
      onPressed: () => {
        nav.add(const PushForgotPassword()),
      },
      child: const Text(
        'Forgot password?',
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
