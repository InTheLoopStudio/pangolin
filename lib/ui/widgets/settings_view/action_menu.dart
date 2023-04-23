import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';
import 'package:intheloopapp/ui/widgets/settings_view/settings_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ActionMenu extends StatelessWidget {
  const ActionMenu({super.key});

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            const Divider(),
            SettingsButton(
              icon: const Icon(FontAwesomeIcons.comments),
              label: 'Give us Feedback',
              onTap: () => launchUrl(
                Uri(
                  scheme: 'mailto',
                  path: 'intheloopstudios2021@gmail.com',
                  query: encodeQueryParameters(<String, String>{
                    'subject': 'Tapped User Feedback',
                  }),
                ),
              ),
            ),
            const Divider(),
            SettingsButton(
              icon: const Icon(
                FontAwesomeIcons.instagram,
                size: 20,
              ),
              label: 'Follow us on Instagram',
              onTap: () => launchUrl(
                Uri(
                  scheme: 'https',
                  path: 'www.instagram.com/tappednetwork/',
                ),
              ),
            ),
            const Divider(),
            SettingsButton(
              icon: const Icon(
                FontAwesomeIcons.userSecret,
                size: 20,
              ),
              label: 'Privacy Policy',
              onTap: () => launchUrl(
                Uri(
                  scheme: 'https',
                  path: 'tapped.jonaylor.xyz/privacy',
                ),
              ),
            ),
            const Divider(),
            SettingsButton(
              icon: const Icon(
                FontAwesomeIcons.fileContract,
                size: 20,
              ),
              label: 'Terms of Service',
              onTap: () => launchUrl(
                Uri(
                  scheme: 'https',
                  path: 'intheloopstudio.com/terms',
                ),
              ),
            ),
            const Divider(),
            SettingsButton(
              icon: const Icon(
                FontAwesomeIcons.rightFromBracket,
                size: 20,
              ),
              label: 'Sign Out',
              // onTap: context.read<SettingsCubit>().logout,
              onTap: () => showDialog<AlertDialog>(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                  title: const Text('Sign Out'),
                  content: const Text(
                    "Are you sure you'd like to sign out?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: Navigator.of(context).pop,
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      child: const Text('Continue'),
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
            const Divider(),
          ],
        );
      },
    );
  }
}
