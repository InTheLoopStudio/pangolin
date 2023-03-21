import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';
import 'package:intheloopapp/ui/widgets/settings_view/settings_switch.dart';

class NotificationSettingsForm extends StatelessWidget {
  const NotificationSettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 10),
            const Row(
              children: [
                Text(
                  'Push Notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SettingsSwitch(
              label: 'New Likes',
              activated: state.pushNotificationsLikes,
              onChanged: (selected) =>
                  context.read<SettingsCubit>().changeNewLikesPush(
                        selected: selected,
                      ),
            ),
            SettingsSwitch(
              label: 'New Comment',
              activated: state.pushNotificationsComments,
              onChanged: (selected) =>
                  context.read<SettingsCubit>().changeNewCommentsPush(
                        selected: selected,
                      ),
            ),
            SettingsSwitch(
              label: 'New Followers',
              activated: state.pushNotificationsFollows,
              onChanged: (selected) =>
                  context.read<SettingsCubit>().changeNewFollowerPush(
                        selected: selected,
                      ),
            ),
            SettingsSwitch(
              label: 'New DMs',
              activated: state.pushNotificationsDirectMessages,
              onChanged: (selected) =>
                  context.read<SettingsCubit>().changeDirectMsgPush(
                        selected: selected,
                      ),
            ),
            SettingsSwitch(
              label: 'Tapped Updates',
              activated: state.pushNotificationsITLUpdates,
              onChanged: (selected) =>
                  context.read<SettingsCubit>().changeITLUpdatesPush(
                        selected: selected,
                      ),
            ),
            SettingsSwitch(
              label: 'All Push Notifications',
              activated: state.pushNotificationsLikes &&
                  state.pushNotificationsComments &&
                  state.pushNotificationsFollows &&
                  state.pushNotificationsDirectMessages &&
                  state.pushNotificationsITLUpdates,
              onChanged: (selected) =>
                  context.read<SettingsCubit>().changeAllPush(
                        selected: selected,
                      ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Text(
                  'Emails',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SettingsSwitch(
              label: 'New App Releases',
              activated: state.emailNotificationsAppReleases,
              onChanged: (selected) =>
                  context.read<SettingsCubit>().changeAppReleaseEmail(
                        selected: selected,
                      ),
            ),
            SettingsSwitch(
              label: 'Tapped Updates',
              activated: state.emailNotificationsITLUpdates,
              onChanged: (selected) =>
                  context.read<SettingsCubit>().changeITLUpdatesEmail(
                        selected: selected,
                      ),
            ),
            SettingsSwitch(
              label: 'All Emails',
              activated: state.emailNotificationsAppReleases &&
                  state.emailNotificationsITLUpdates,
              onChanged: (selected) =>
                  context.read<SettingsCubit>().changeAllEmail(
                        selected: selected,
                      ),
            ),
          ],
        );
      },
    );
  }
}
