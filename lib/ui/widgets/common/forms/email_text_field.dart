import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    Key? key,
    this.onChanged,
    this.labelText = 'Email',
  }) : super(key: key);

  final void Function(String?)? onChanged;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        labelText: labelText,
      ),
      validator: (value) => EmailValidator.validate(value ?? '')
          ? null
          : 'Please enter a valid email',
      onChanged: (input) async {
        onChanged?.call(input);
      },
    );
  }
}
