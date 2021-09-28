import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/themes.dart';

class LocationTextField extends StatelessWidget {
  const LocationTextField({
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
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.map_rounded),
        labelText: 'Location',
      ),
      validator: (input) => input!.trim().length > 256
          ? 'location must be less than 256 characters'
          : null,
      onSaved: onSaved,
      onChanged: onChanged,
    );
  }
}
