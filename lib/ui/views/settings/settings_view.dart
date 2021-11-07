import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';
import 'package:intheloopapp/ui/widgets/settings_view/action_menu.dart';
import 'package:intheloopapp/ui/widgets/settings_view/change_profile_image.dart';
import 'package:intheloopapp/ui/widgets/settings_view/connectivity_status.dart';
import 'package:intheloopapp/ui/widgets/settings_view/delete_account_button.dart';
import 'package:intheloopapp/ui/widgets/settings_view/dev_information.dart';
import 'package:intheloopapp/ui/widgets/settings_view/notification_settings_form.dart';
import 'package:intheloopapp/ui/widgets/settings_view/save_button.dart';
import 'package:intheloopapp/ui/widgets/settings_view/settings_form.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSelector<AuthenticationBloc, AuthenticationState, Authenticated>(
      selector: (state) => state as Authenticated,
      builder: (context, state) {
        UserModel currentUser = state.currentUser;

        return BlocProvider(
          create: (_) => SettingsCubit(
            authenticationBloc: context.read<AuthenticationBloc>(),
            authRepository: context.read<AuthRepository>(),
            databaseRepository: context.read<DatabaseRepository>(),
            storageRepository: context.read<StorageRepository>(),
            navigationBloc: context.read<NavigationBloc>(),
            currentUser: currentUser,
          )..initUserData(),
          child: Scaffold(
            backgroundColor: theme.backgroundColor,
            appBar: AppBar(
              title: Text(currentUser.username),
              elevation: 0,
              actions: [
                ConnectivityStatus(),
              ],
            ),
            body: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                Stack(
                  children: [
                    Container(
                      height: 75,
                      decoration: BoxDecoration(
                        color: itlAccent,
                        image: null,
                      ),
                    ),
                  ],
                ),
                Container(
                  transform: Matrix4.translationValues(0, -40, 0),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ChangeProfileImage(),
                          SaveButton(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Preferences",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SettingsForm(),
                      const SizedBox(height: 30),
                      Text(
                        "Notifications",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 10),
                      NotificationSettingsForm(),
                      const SizedBox(height: 30),
                      Text(
                        "More Options",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ActionMenu(),
                      const SizedBox(height: 20),
                      DevInformation(),
                      const SizedBox(height: 40),
                      DeleteAccountButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
