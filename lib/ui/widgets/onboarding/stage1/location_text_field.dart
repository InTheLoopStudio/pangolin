import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/themes.dart';

class LocationTextField extends StatelessWidget {
  const LocationTextField({
    Key? key,
    this.onChanged,
    this.initialValue,
  }) : super(key: key);

  final void Function(String?)? onChanged;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue ?? '',
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Location (Optional)',
        hintText: 'e.g. RVA, NYC, LA',
        labelStyle: TextStyle(color: itlAccent),
      ),
      onChanged: onChanged,
    );
  }
}
