import 'package:flutter/material.dart';

class BadgeNameTextField extends StatelessWidget {
  const BadgeNameTextField({
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
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: 'Badge Name',
        hintText: "what's the badge called?",
      ),
      validator: (input) {
        if (input!.trim().length < 2) {
          return 'please enter a valid badge name';
        }

        return null;
      },
      onSaved: (input) async {
        if (input == null || input.isEmpty) return;
        input = input.trim().toLowerCase();
        if (onSaved != null) {
          onSaved?.call(input);
        }
      },
      onChanged: (input) async {
        if (input.isEmpty) return;
        input = input.trim().toLowerCase();
        if (onChanged != null) {
          onChanged?.call(input);
        }
      },
    );
  }
}
