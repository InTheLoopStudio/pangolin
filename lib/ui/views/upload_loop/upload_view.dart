import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/upload_loop/upload_loop_cubit.dart';
import 'package:intheloopapp/ui/views/upload_loop/upload_loop_form_view.dart';
import 'package:intheloopapp/ui/views/upload_loop/upload_loop_splash_view.dart';

class UploadView extends StatelessWidget {
  UploadView({super.key});

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, userState) {
        final currentUser = userState.currentUser;

        return BlocProvider(
          create: (_) => UploadLoopCubit(
            audioRepo: context.read<AudioRepository>(),
            databaseRepository: context.read<DatabaseRepository>(),
            onboardingBloc: context.read<OnboardingBloc>(),
            currentUser: currentUser,
            navigationBloc: context.read<NavigationBloc>(),
            storageRepository: context.read<StorageRepository>(),
            scaffoldKey: _scaffoldKey,
          ),
          child: Scaffold(
            backgroundColor: theme.colorScheme.background,
            body: ScaffoldMessenger(
              key: _scaffoldKey,
              child: BlocBuilder<UploadLoopCubit, UploadLoopState>(
                builder: (context, state) {
                  return state.pickedAudio == null
                      ? const UploadLoopSplashView()
                      : const UploadLoopFormView();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
