import 'package:flutter/material.dart';

class BadgeDescriptionTextField extends StatelessWidget {
  const BadgeDescriptionTextField({
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
        labelText: 'Badge Description',
        hintText: 'give a brief description of the badge',
      ),
      validator: (input) {
        if (input!.trim().isEmpty || input.trim().length > 256) {
          return 'please enter a valid badge description';
        }

        return null;
      },
      onSaved: (input) async {
        if (input == null || input.isEmpty) return;
        input = input.trim().toLowerCase();
        onSaved?.call(input);
      },
      onChanged: (input) async {
        if (input.isEmpty) return;
        input = input.trim().toLowerCase();
        onChanged?.call(input);
      },
    );
  }
}
