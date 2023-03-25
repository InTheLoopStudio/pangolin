import 'package:flutter/material.dart';

class ArtistNameTextField extends StatelessWidget {
  const ArtistNameTextField({
    super.key,
    this.onSaved,
    this.onChanged,
    this.initialValue,
  });

  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: 'Username',
        hintText: 'Tapped Network',
      ),
      validator: (input) {
        if (input!.trim().isEmpty) {
          return 'please enter a valid username';
        }

        return null;
      },
      onSaved: (input) async {
        if (input == null || input.isEmpty) return;

        input = input.trim();
        onSaved?.call(input);
      },
      onChanged: (input) async {
        if (input.isEmpty) return;

        input = input.trim();
        onChanged?.call(input);
      },
    );
  }
}
