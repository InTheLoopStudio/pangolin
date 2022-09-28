import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';

class PopoutMenu extends StatelessWidget {
  const PopoutMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return PopupMenuButton(
          icon: const Icon(
            Icons.more_horiz,
            color: Colors.white,
            size: 30,
          ),
          itemBuilder: (_) {
            return <PopupMenuItem<String>>[
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ];
          },
          onSelected: (selectedItem) {
            if (selectedItem == 'logout') {
              context.read<SettingsCubit>().logout();
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }
}
