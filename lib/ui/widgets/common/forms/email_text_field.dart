import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    this.onChanged,
    this.labelText = 'Email',
  });

  final void Function(String?)? onChanged;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        labelText: labelText,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) => EmailValidator.validate(value ?? '')
          ? null
          : 'Please enter a valid email',
      onChanged: (input) async {
        onChanged?.call(input);
      },
    );
  }
}
