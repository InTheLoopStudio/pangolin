import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';
import 'package:intheloopapp/ui/widgets/settings_view/settings_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ActionMenu extends StatelessWidget {
  const ActionMenu({Key? key}) : super(key: key);

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(),
            SettingsButton(
              icon: Icon(FontAwesomeIcons.comments),
              label: 'Give us Feedback',
              onTap: () => launch(
                Uri(
                  scheme: 'mailto',
                  path: 'intheloopstudios2021@gmail.com',
                  query: encodeQueryParameters(<String, String>{
                    'subject': 'In The Loop User Feedback',
                  }),
                ).toString(),
              ),
            ),
            Divider(),
            SettingsButton(
              icon: Icon(
                FontAwesomeIcons.discord,
                size: 20,
              ),
              label: 'Join our Discord community',
              onTap: () => launch(
                Uri(
                  scheme: 'https',
                  path: 'discord.gg/ZwpPGx98Qc',
                ).toString(),
              ),
            ),
            Divider(),
            SettingsButton(
              icon: Icon(
                FontAwesomeIcons.spotify,
                size: 20,
              ),
              label: 'In The Loop Podcast',
              onTap: () => launch(
                Uri(
                  scheme: 'https',
                  path: 'https://open.spotify.com/show/6LQi6uQ5nEgIK9vo0am9PS',
                ).toString(),
              ),
            ),
            Divider(),
            SettingsButton(
              icon: Icon(
                FontAwesomeIcons.instagram,
                size: 20,
              ),
              label: 'Follow us on Instagram',
              onTap: () => launch(
                Uri(
                  scheme: 'https',
                  path: 'www.instagram.com/itl_studios/',
                ).toString(),
              ),
            ),
            Divider(),
            SettingsButton(
              icon: Icon(
                FontAwesomeIcons.userSecret,
                size: 20,
              ),
              label: 'Privacy Policy',
              onTap: () => launch(
                Uri(
                  scheme: 'https',
                  path: 'intheloopstudio.com/privacy',
                ).toString(),
              ),
            ),
            Divider(),
            SettingsButton(
              icon: Icon(
                FontAwesomeIcons.fileContract,
                size: 20,
              ),
              label: 'Terms of Service',
              onTap: () => launch(
                Uri(
                  scheme: 'https',
                  path: 'intheloopstudio.com/terms',
                ).toString(),
              ),
            ),
            Divider(),
            SettingsButton(
              icon: Icon(
                FontAwesomeIcons.signOutAlt,
                size: 20,
              ),
              label: 'Sign Out',
              // onTap: context.read<SettingsCubit>().logout,
              onTap: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  elevation: 5.0,
                  title: Text("Sign Out"),
                  content: Text(
                    "Are you sure you'd like to sign out?",
                  ),
                  actions: [
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: Navigator.of(context).pop,
                    ),
                    TextButton(
                      child: Text("Continue"),
                      onPressed: () {
                        context.read<SettingsCubit>().logout();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ),
            Divider(),
          ],
        );
      },
    );
  }
}
