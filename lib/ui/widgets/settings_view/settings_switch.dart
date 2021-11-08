import 'package:flutter/material.dart';

class SettingsSwitch extends StatelessWidget {
  const SettingsSwitch({
    Key? key,
    required this.label,
    required this.activated,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final bool activated;
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
