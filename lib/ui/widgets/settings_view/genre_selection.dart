import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class GenreSelection extends StatefulWidget {
  const GenreSelection({super.key});

  @override
  State<GenreSelection> createState() => _GenreSelectionState();
}

class _GenreSelectionState extends State<GenreSelection> {
  List<Genre?> _selectedGenres = [];

  final _items = Genre.values
      .map((genre) => MultiSelectItem<Genre>(genre, genre.name))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 6),
        MultiSelectBottomSheetField<Genre?>(
          initialChildSize: 0.4,
          listType: MultiSelectListType.CHIP,
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
          onConfirm: (values) {
            setState(() {
              _selectedGenres = values;
            });
          },
          chipDisplay: MultiSelectChipDisplay(
            onTap: (value) {
              setState(() {
                _selectedGenres.remove(value);
              });
            },
          ),
        ),
        const Divider(),
      ],
    );
  }
}
