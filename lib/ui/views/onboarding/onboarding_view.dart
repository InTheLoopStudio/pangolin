import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_flow_cubit.dart';
import 'package:intheloopapp/ui/widgets/onboarding/onboarding_form.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthenticationBloc, AuthenticationState, Option<User>>(
      selector: (state) =>
          state is Authenticated ? Some(state.currentAuthUser) : const None(),
      builder: (context, user) {
        return BlocProvider(
          create: (context) => OnboardingFlowCubit(
            currentAuthUser: user.unwrap,
            onboardingBloc: context.read<OnboardingBloc>(),
            navigationBloc: context.read<NavigationBloc>(),
            authenticationBloc: context.read<AuthenticationBloc>(),
            storageRepository: context.read<StorageRepository>(),
            databaseRepository: context.read<DatabaseRepository>(),
          ),
          // ..initFollowRecommendations(),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: const TappedAppBar(
              title: 'Onboarding',
            ),
            // floatingActionButton: const ControlButtons(),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: OnboardingForm(),
              ),
            ),
          ),
        );
      },
    );
  }
}
