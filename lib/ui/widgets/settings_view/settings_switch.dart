import 'package:flutter/material.dart';

class SettingsSwitch extends StatelessWidget {
  const SettingsSwitch({
    required this.label,
    required this.activated,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final String label;
  final bool activated;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Switch(
          value: activated,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
