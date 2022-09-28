import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/forms/bio_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/forms/username_text_field.dart';
import 'package:intheloopapp/ui/widgets/onboarding/stage1/location_text_field.dart';
import 'package:intheloopapp/ui/widgets/onboarding/stage1/profile_picture_uploader.dart';

class Stage1 extends StatelessWidget {
  const Stage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: RepositoryProvider.of<AuthRepository>(context).user,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final currentUser = snapshot.data!;

        return BlocBuilder<OnboardingCubit, OnboardingState>(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
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
                            .read<OnboardingCubit>()
                            .usernameChange(input ?? ''),
                        initialValue: state.username,
                        currentUserId: currentUser.id,
                      ),
                      const SizedBox(height: 20),
                      LocationTextField(
                        initialValue: state.location,
                        onChanged: (input) => context
                            .read<OnboardingCubit>()
                            .locationChange(input ?? ''),
                      ),
                      const SizedBox(height: 20),
                      BioTextField(
                        initialValue: state.bio,
                        onChanged: (input) => context
                            .read<OnboardingCubit>()
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
