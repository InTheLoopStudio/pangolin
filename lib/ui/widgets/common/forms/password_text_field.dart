import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    this.onSaved,
    this.onChanged,
    this.labelText = 'Password',
  });

  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        labelText: labelText,
      ),
      validator: (input) {
        if (input!.trim().length < 8) {
          return 'please enter a valid handle';
        }

        return null;
      },
      onChanged: (input) async {
        onChanged?.call(input);
      },
    );
  }
}
