import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/themes.dart';

class BioTextField extends StatelessWidget {
  const BioTextField({
    Key? key,
    this.onSaved,
    this.onChanged,
    this.initialValue,
  }) : super(key: key);

  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.short_text_rounded),
        labelText: 'Bio',
      ),
      validator: (input) {
        if (input == null || input.trim().length < 2) {
          return "bio can't be empty";
        }

        if (input.trim().length > 256) {
          return "bio must be less than 256 characters";
        }

        return null;
      },
      onSaved: onSaved,
      onChanged: onChanged,
    );
  }
}
