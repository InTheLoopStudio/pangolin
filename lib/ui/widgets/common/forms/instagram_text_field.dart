import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InstagramTextField extends StatelessWidget {
  const InstagramTextField({
    super.key,
    this.onChanged,
    this.initialValue,
  });

  final void Function(String)? onChanged;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        // is able to enter lowercase letters
        FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9_\.\-\$]')),
      ],
      initialValue: initialValue,
      decoration: const InputDecoration(
        prefixIcon: Icon(FontAwesomeIcons.instagram),
        prefixText: '@ ',
        labelText: 'Instagram',
      ),
      onChanged: (input) {
        input = input.trim().toLowerCase();
        onChanged?.call(input);
      },
    );
  }
}
