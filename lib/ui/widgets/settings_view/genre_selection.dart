import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class GenreSelection extends StatelessWidget {
  const GenreSelection({
    required this.onConfirm,
    required this.initialValue,
    super.key,
  });

  final List<Genre> initialValue;
  final void Function(List<Genre?>) onConfirm;

  List<MultiSelectItem<Genre>> get _items => Genre.values
      .map((genre) => MultiSelectItem<Genre>(genre, genre.name))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6),
        MultiSelectBottomSheetField<Genre?>(
          initialChildSize: 0.4,
          listType: MultiSelectListType.CHIP,
          initialValue: initialValue,
          searchable: true,
          buttonText: const Text(
            'Select Genres',
            style: TextStyle(
              color: tappedAccent,
              fontSize: 16,
            ),
          ),
          title: const Text('Genres'),
          items: _items,
          onConfirm: onConfirm.call,
          chipDisplay: MultiSelectChipDisplay(
            items: initialValue
                .map((genre) => MultiSelectItem<Genre>(genre, genre.name))
                .toList(),
            // onTap: (value) {
            //   if (value != null) {
            //     context.read<SettingsCubit>().removeGenre(value);
            //   }
            // },
          ),
        ),
        const Divider(),
      ],
    );
  }
}
