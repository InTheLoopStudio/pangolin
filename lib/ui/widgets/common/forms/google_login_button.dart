import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/ui/themes.dart';

class GoogleLoginButton extends StatelessWidget {
  GoogleLoginButton({Key? key, this.onPressed}) : super(key: key);

  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: const Text(
        'Sign in with Google',
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
      icon: const Icon(
        FontAwesomeIcons.google,
        color: itlAccent,
      ),
      onPressed: onPressed,
    );
  }
}
