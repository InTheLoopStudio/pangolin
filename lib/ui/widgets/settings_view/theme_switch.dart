import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeCubit, bool>(
      builder: (context, isDark) {
        return CupertinoSlidingSegmentedControl(
          groupValue: isDark,
          // backgroundColor: Colors.grey[300]!,
          backgroundColor: Theme.of(context).backgroundColor,
          thumbColor: const Color.fromARGB(255, 197, 228, 255),
          onValueChanged: (value) async {
            await context
                .read<AppThemeCubit>()
                .updateTheme(isDarkMode: value! as bool);
          },
          children: {
            false: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(
                    FontAwesomeIcons.solidSun,
                    color: tappedAccent,
                  ),
                  Text(
                    'Light',
                    style: TextStyle(
                      color: tappedAccent,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            true: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(
                    FontAwesomeIcons.solidMoon,
                    color: tappedAccent,
                  ),
                  Text(
                    'Dark',
                    style: TextStyle(
                      color: tappedAccent,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          },
          // value: isDark,
          // onChanged: (val) {
          //   context.read<AppThemeCubit>().updateTheme(val);
          // },
        );
      },
    );
  }
}
