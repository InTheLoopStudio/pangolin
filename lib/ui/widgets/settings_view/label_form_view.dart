import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intheloopapp/domains/models/label.dart';

class LabelFormView extends StatefulWidget {
  const LabelFormView({
    required this.onChange,
    required this.initialValue,
    super.key,
  });

  final void Function(String?) onChange;
  final String? initialValue;

  @override
  State<LabelFormView> createState() => _LabelFormViewState();
}

class _LabelFormViewState extends State<LabelFormView> {
  String _groupValue = '';

  @override
  void initState() {
    setState(() {
      _groupValue = widget.initialValue ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: RadioGroup<String>.builder(
          groupValue: _groupValue,
          onChanged: (value) {
            setState(() {
              _groupValue = value ?? '';
            });
            widget.onChange.call(value);
          },
          items: labels..add('None'),
          itemBuilder: RadioButtonBuilder.new,
        ),
      ),
    );
  }
}
