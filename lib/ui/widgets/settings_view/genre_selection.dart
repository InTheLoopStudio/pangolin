import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class GenreSelection extends StatelessWidget {
  const GenreSelection({super.key});

  List<MultiSelectItem<Genre>> get _items => Genre.values
      .map((genre) => MultiSelectItem<Genre>(genre, genre.name))
      .toList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 6),
            MultiSelectBottomSheetField<Genre?>(
              initialChildSize: 0.4,
              listType: MultiSelectListType.CHIP,
              initialValue: state.genres,
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
                context.read<SettingsCubit>().changeGenres(
                      values
                          .where(
                            (element) => element != null,
                          )
                          .whereType<Genre>()
                          .toList(),
                    );
              },
              chipDisplay: MultiSelectChipDisplay(
                items: state.genres
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
      },
    );
  }
}
