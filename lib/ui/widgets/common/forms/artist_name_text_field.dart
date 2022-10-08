import 'package:flutter/material.dart';

class ArtistNameTextField extends StatelessWidget {
  const ArtistNameTextField({
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
        labelText: 'Artist Name',
        hintText: 'Tapped Network',
      ),
      validator: (input) {
        if (input!.trim().isEmpty) {
          return 'please enter a valid handle';
        }

        return null;
      },
      onSaved: (input) async {
        if (input == null || input.isEmpty) return;

        input = input.trim();
        if (onSaved != null) {
          onSaved!(input);
        }
      },
      onChanged: (input) async {
        if (input.isEmpty) return;

        input = input.trim();
        if (onChanged != null) {
          onChanged!(input);
        }
      },
    );
  }
}
