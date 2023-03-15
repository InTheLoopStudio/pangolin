import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_flow_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/forms/artist_name_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/bio_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/location_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/username_text_field.dart';
import 'package:intheloopapp/ui/widgets/onboarding/stage1/profile_picture_uploader.dart';

const rvaPlaceId = 'ChIJ7cmZVwkRsYkRxTxC4m0-2L8';
const rvaLat = 37.5407246;
const rvaLng = -77.43604809999999;
const initialPlace = Place(
  latLng: LatLng(lat: rvaLat, lng: rvaLng),
);

class Stage1 extends StatelessWidget {
  const Stage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthenticationBloc, AuthenticationState, Authenticated>(
      selector: (state) => state as Authenticated,
      builder: (context, userState) {
        final currentUserId = userState.currentUserId;

        return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
          builder: (context, state) {
            return Form(
              key: state.formKey,
              child: Align(
                alignment: const Alignment(0, -1 / 3),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 100),
                          Text(
                            'Complete Your Profile',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      UsernameTextField(
                        onChanged: (input) => context
                            .read<OnboardingFlowCubit>()
                            .usernameChange(input ?? ''),
                        initialValue: state.username,
                        currentUserId: currentUserId,
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
                        initialPlaceId: rvaPlaceId,
                        initialPlace: initialPlace,
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
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
