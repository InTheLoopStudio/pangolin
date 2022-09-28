import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/ui/themes.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({Key? key, this.onPressed}) : super(key: key);

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: const Text(
        'Sign in with Google',
        style: TextStyle(
          color: tappedAccent,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.white,
      ),
      icon: const Icon(
        FontAwesomeIcons.google,
        color: tappedAccent,
      ),
      onPressed: onPressed,
    );
  }
}
