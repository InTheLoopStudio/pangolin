import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/ui/themes.dart';

class AppleLoginButton extends StatelessWidget {
  AppleLoginButton({Key? key, this.onPressed}) : super(key: key);

  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: const Text(
        'Sign in with Apple',
        style: TextStyle(
          color: itlAccent,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        primary: Colors.white,
      ),
      icon: const Icon(FontAwesomeIcons.apple, color: itlAccent),
      onPressed: onPressed,
    );
  }
}
