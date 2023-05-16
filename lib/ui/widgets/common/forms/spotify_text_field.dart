import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SpotifyTextField extends StatelessWidget {
  const SpotifyTextField({
    super.key,
    this.onChanged,
    this.initialValue,
  });

  final void Function(String)? onChanged;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: const InputDecoration(
        prefixIcon: Icon(FontAwesomeIcons.spotify),
        labelText: 'Spotify Id',
      ),
      onChanged: (input) {
        onChanged?.call(input);
      },
    );
  }
}
