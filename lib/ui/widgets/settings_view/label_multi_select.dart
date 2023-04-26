import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/domains/models/label.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class LabelMultiSelect extends StatelessWidget {
  const LabelMultiSelect({
    required this.onConfirm,
    required this.initialValue,
    super.key,
  });

  final List<String> initialValue;
  final void Function(List<String?>) onConfirm;

  List<MultiSelectItem<String>> get _items => labels
      .map((label) => MultiSelectItem<String>(label, label))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6),
        MultiSelectBottomSheetField<String?>(
          initialChildSize: 0.4,
          listType: MultiSelectListType.CHIP,
          initialValue: initialValue,
          searchable: true,
          buttonText: const Text(
            'Select Labels',
            style: TextStyle(
              color: tappedAccent,
              fontSize: 16,
            ),
          ),
          title: const Text('Labels'),
          items: _items,
          onConfirm: onConfirm.call,
          chipDisplay: MultiSelectChipDisplay(
            items: initialValue
                .map((label) => MultiSelectItem<String>(label, label))
                .toList(),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
