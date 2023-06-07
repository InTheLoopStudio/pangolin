import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/app_logger.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_flow_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/forms/artist_name_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/bio_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/location_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/username_text_field.dart';
import 'package:intheloopapp/ui/widgets/onboarding/eula_button.dart';
import 'package:intheloopapp/ui/widgets/onboarding/profile_picture_uploader.dart';

class OnboardingForm extends StatelessWidget {
  const OnboardingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
      builder: (context, state) {
        if (state.status.isInProgress) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: state.formKey,
          child: Align(
            alignment: const Alignment(0, -1 / 3),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UsernameTextField(
                    onChanged: (input) => context
                        .read<OnboardingFlowCubit>()
                        .usernameChange(input ?? ''),
                    initialValue: state.username.value,
                  ),
                  const SizedBox(height: 20),
                  ArtistNameTextField(
                    onChanged: (input) => context
                        .read<OnboardingFlowCubit>()
                        .aristNameChange(input ?? ''),
                    initialValue: state.artistName.value,
                  ),
                  const SizedBox(height: 20),
                  LocationTextField(
                    initialPlaceId: state.placeId.asNullable(),
                    initialPlace: state.place.asNullable(),
                    onChanged: (place, placeId) => context
                        .read<OnboardingFlowCubit>()
                        .locationChange(place, placeId),
                  ),
                  const SizedBox(height: 20),
                  BioTextField(
                    initialValue: state.bio.value,
                    onChanged: (input) => context
                        .read<OnboardingFlowCubit>()
                        .bioChange(input ?? ''),
                  ),
                  const SizedBox(height: 20),
                  EULAButton(
                    initialValue: state.eula,
                    onChanged: (input) => context
                        .read<OnboardingFlowCubit>()
                        .eulaChange(input ?? false),
                  ),
                  const SizedBox(height: 50),
                  const ProfilePictureUploader(),
                  const SizedBox(height: 50),
                  FilledButton(
                    onPressed: () async {
                      try {
                        await context
                            .read<OnboardingFlowCubit>()
                            .finishOnboarding();
                      } catch (e, s) {
                        logger.error(
                          'Error completing onboarding',
                          error: e,
                          stackTrace: s,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },
                    child: const Text('Complete Onboarding'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(LoggedOut());
                    },
                    child: const Text(
                      'logout',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
