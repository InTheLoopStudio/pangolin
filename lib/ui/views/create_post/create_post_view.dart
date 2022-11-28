import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/create_post/cubit/create_post_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';
import 'package:intheloopapp/ui/widgets/create_post_view/post_description_text_field.dart';
import 'package:intheloopapp/ui/widgets/create_post_view/post_title_text_field.dart';
import 'package:intheloopapp/ui/widgets/create_post_view/submit_post_button.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatePostCubit(),
      child: BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
        selector: (state) => state as Onboarded,
        builder: (context, userState) {
          final currentUser = userState.currentUser;
          return SafeArea(
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Create Post',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .bottomNavigationBarTheme
                            .unselectedItemColor,
                        borderRadius: BorderRadius.circular(30.0 / 2),
                      ),
                      child: UserAvatar(
                        radius: 45,
                        backgroundImageUrl: currentUser.profilePicture,
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: const [
                  PostTitleTextField(),
                  PostDescriptionTextField(),
                ],
              ),
              bottomNavigationBar: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: SubmitPostButton(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
