import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_flow_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/forms/artist_name_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/bio_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/location_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/username_text_field.dart';
import 'package:intheloopapp/ui/widgets/onboarding/stage1/profile_picture_uploader.dart';


class OnboardingForm extends StatelessWidget {
  const OnboardingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
      builder: (context, state) {
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
                    initialValue: state.username,
                  ),
                  const SizedBox(height: 20),
                  ArtistNameTextField(
                    onChanged: (input) => context
                        .read<OnboardingFlowCubit>()
                        .aristNameChange(input ?? ''),
                    initialValue: state.artistName,
                  ),
                  const SizedBox(height: 20),
                  LocationTextField(
                    initialPlaceId: state.placeId,
                    initialPlace: state.place,
                    onChanged: (place, placeId) => context
                        .read<OnboardingFlowCubit>()
                        .locationChange(place, placeId),
                  ),
                  const SizedBox(height: 20),
                  BioTextField(
                    initialValue: state.bio,
                    onChanged: (input) => context
                        .read<OnboardingFlowCubit>()
                        .bioChange(input ?? ''),
                  ),
                  const SizedBox(height: 50),
                  const ProfilePictureUploader(),
                  const SizedBox(height: 50),
                  FilledButton(
                    onPressed: () => context
                        .read<OnboardingFlowCubit>()
                        .finishOnboarding(),
                    child: const Text('Complete Onboarding'),
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
