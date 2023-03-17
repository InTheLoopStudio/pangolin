import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nav = RepositoryProvider.of<NavigationBloc>(context);
    return CupertinoButton(
      onPressed: () => {
        nav.add(const PushSignUp()),
      },
      child: const Text(
        'Sign Up',
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
