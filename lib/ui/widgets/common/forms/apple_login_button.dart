import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/ui/themes.dart';

class AppleLoginButton extends StatelessWidget {
  const AppleLoginButton({Key? key, this.onPressed}) : super(key: key);

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: const Text(
        'Sign in with Apple',
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
      icon: const Icon(FontAwesomeIcons.apple, color: tappedAccent),
      onPressed: onPressed,
    );
  }
}
