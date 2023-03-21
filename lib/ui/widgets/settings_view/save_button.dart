import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<SettingsCubit>().saveProfile();
            // Navigator.pop(context);
          },
          child: Container(
            width: 100,
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: tappedAccent,
            ),
            child: const Center(
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
