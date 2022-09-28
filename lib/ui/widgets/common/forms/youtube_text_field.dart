import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class YoutubeTextField extends StatelessWidget {
  const YoutubeTextField({
    Key? key,
    this.onSaved,
    this.initialValue,
  }) : super(key: key);

  final void Function(String)? onSaved;
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
      onSaved: (input) {
        input = input?.trim();
        if (onSaved != null) onSaved!(input ?? '');
      },
    );
  }
}
