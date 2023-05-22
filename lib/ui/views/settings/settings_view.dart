import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/error/error_view.dart';
import 'package:intheloopapp/ui/views/settings/settings_cubit.dart';
import 'package:intheloopapp/ui/widgets/settings_view/action_menu.dart';
import 'package:intheloopapp/ui/widgets/settings_view/change_profile_image.dart';
import 'package:intheloopapp/ui/widgets/settings_view/connectivity_status.dart';
import 'package:intheloopapp/ui/widgets/settings_view/delete_account_button.dart';
import 'package:intheloopapp/ui/widgets/settings_view/dev_information.dart';
import 'package:intheloopapp/ui/widgets/settings_view/notification_settings_form.dart';
import 'package:intheloopapp/ui/widgets/settings_view/payment_settings_form.dart';
import 'package:intheloopapp/ui/widgets/settings_view/save_button.dart';
import 'package:intheloopapp/ui/widgets/settings_view/settings_form.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSelector<OnboardingBloc, OnboardingState, UserModel?>(
      selector: (state) => (state is Onboarded) ? state.currentUser : null,
      builder: (context, currentUser) {
        if (currentUser == null) {
          return const ErrorView();
        }

        return BlocProvider(
          create: (_) => SettingsCubit(
            authenticationBloc: context.read<AuthenticationBloc>(),
            onboardingBloc: context.read<OnboardingBloc>(),
            authRepository: context.read<AuthRepository>(),
            databaseRepository: context.read<DatabaseRepository>(),
            storageRepository: context.read<StorageRepository>(),
            navigationBloc: context.read<NavigationBloc>(),
            places: context.read<PlacesRepository>(),
            currentUser: currentUser,
          )
            ..initUserData()
            ..initServices()
            ..initPlace(),
          child: Scaffold(
            backgroundColor: theme.colorScheme.background,
            appBar: AppBar(
              title: Row(
                children: [
                  Text.rich(
                    TextSpan(
                      text: currentUser.artistName.isNotEmpty
                          ? currentUser.artistName
                          : currentUser.username.toString(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      children: const [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: ConnectivityStatus(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              elevation: 0,
            ),
            body: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                Stack(
                  children: [
                    Container(
                      height: 75,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Container(
                  transform: Matrix4.translationValues(0, -40, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ChangeProfileImage(),
                          SaveButton(),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Payments',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: 10),
                      PaymentSettingsForm(),
                      SizedBox(height: 20),
                      Text(
                        'Preferences',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: 10),
                      SettingsForm(),
                      SizedBox(height: 30),
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: 10),
                      NotificationSettingsForm(),
                      SizedBox(height: 30),
                      Text(
                        'More Options',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: 10),
                      ActionMenu(),
                      SizedBox(height: 20),
                      DevInformation(),
                      SizedBox(height: 40),
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
