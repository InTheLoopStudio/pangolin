import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';
import 'package:intheloopapp/ui/widgets/settings_view/label_form_view.dart';

class LabelSelection extends StatelessWidget {
  const LabelSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final onChange = context.read<SettingsCubit>().changeLabel;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<LabelFormView>(
                builder: (context) {
                  return LabelFormView(
                    onChange: onChange,
                    initialValue: state.label,
                  );
                },
              ),
            );
          },
          child: Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.business),
                  ),
                  Text(
                    (state.label != null && state.label != 'None')
                        ? state.label ?? 'Select a label'
                        : 'Select a label',
                    style: const TextStyle(
                      color: tappedAccent,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}
