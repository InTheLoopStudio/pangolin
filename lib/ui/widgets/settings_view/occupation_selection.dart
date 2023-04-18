import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/occupation.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class OccupationSelection extends StatelessWidget {
  const OccupationSelection({super.key});

  List<MultiSelectItem<String>> get _items => occupations
      .map((occupation) => MultiSelectItem<String>(occupation, occupation))
      .toList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 6),
            MultiSelectBottomSheetField<String?>(
              initialChildSize: 0.4,
              listType: MultiSelectListType.CHIP,
              initialValue: state.occupations,
              searchable: true,
              buttonText: const Text(
                'Select Occupation',
                style: TextStyle(
                  color: tappedAccent,
                  fontSize: 16,
                ),
              ),
              title: const Text('Occupations'),
              items: _items,
              onConfirm: (values) {
                context.read<SettingsCubit>().changeOccupations(
                      values
                          .where(
                            (element) => element != null,
                          )
                          .whereType<String>()
                          .toList(),
                    );
              },
              chipDisplay: MultiSelectChipDisplay(
                items: state.occupations
                    .map(
                      (occupation) => MultiSelectItem<String>(
                        occupation,
                        occupation,
                      ),
                    )
                    .toList(),
                // onTap: (value) {
                //   if (value != null) {
                //     context.read<SettingsCubit>().removeOccupation(value);
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
