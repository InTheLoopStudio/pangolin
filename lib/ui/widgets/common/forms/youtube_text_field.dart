import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class YoutubeTextField extends StatelessWidget {
  const YoutubeTextField({
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
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_\.\-\$]')),
      ],
      initialValue: initialValue,
      decoration: const InputDecoration(
        prefixIcon: Icon(FontAwesomeIcons.youtube),
        prefixText: 'youtube.com/channel/',
        labelText: 'Youtube Channel',
      ),
      onChanged: (input) {
        input = input.trim();
        onChanged?.call(input);
      },
    );
  }
}
