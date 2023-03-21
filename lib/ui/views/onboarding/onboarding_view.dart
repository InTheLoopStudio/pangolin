import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_flow_cubit.dart';
import 'package:intheloopapp/ui/widgets/onboarding/control_buttons.dart';
import 'package:intheloopapp/ui/widgets/onboarding/onboarding_form.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthenticationBloc, AuthenticationState, Authenticated>(
      selector: (state) => state as Authenticated,
      builder: (context, state) {
        final userId = state.currentUserId;

        return BlocProvider(
          create: (context) => OnboardingFlowCubit(
            currentUserId: userId,
            onboardingBloc: context.read<OnboardingBloc>(),
            navigationBloc: context.read<NavigationBloc>(),
            authenticationBloc: context.read<AuthenticationBloc>(),
            storageRepository: context.read<StorageRepository>(),
            databaseRepository: context.read<DatabaseRepository>(),
          )
            ..initFollowRecommendations(),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              title: const Center(child: Text('Onboarding')),
            ),
            floatingActionButton: const ControlButtons(),
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
