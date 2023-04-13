import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';

class UsernameTextField extends StatelessWidget {
  const UsernameTextField({
    required this.currentUserId,
    super.key,
    this.onSaved,
    this.onChanged,
    this.initialValue,
    this.validateUniqueness = true,
  });

  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final String? initialValue;
  final String currentUserId;
  final bool validateUniqueness;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9_\.\-\$]')),
      ],
      initialValue: initialValue,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: 'Handle',
        hintText: 'tapped_network',
      ),
      validator: (input) {
        if (input!.trim().length < 2) {
          return 'please enter a valid handle';
        }

        return null;
      },
      onSaved: (input) {
        if (input == null || input.isEmpty) return;

        input = input.trim().toLowerCase();
        onSaved?.call(input);
      },
      onChanged: (input) {
        if (input.isEmpty) return;

        input = input.trim().toLowerCase();
        onChanged?.call(input);
      },
    );
  }
}
