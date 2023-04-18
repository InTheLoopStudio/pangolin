import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';
import 'package:intheloopapp/ui/widgets/loop_view/follow_icon.dart';

class FollowActionButton extends StatelessWidget {
  const FollowActionButton({super.key});

  static const double actionWidgetSize = 60;
  static const double actionIconSize = 35;
  static const double profileImageSize = 50;
  static const double plusIconSize = 20;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, userState) {
        final currentUser = userState.currentUser;

        return BlocBuilder<LoopViewCubit, LoopViewState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: context.read<LoopViewCubit>().toggleFollow,
              child: SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  children: [
                    Positioned(
                      left: (actionWidgetSize / 2) - (profileImageSize / 2),
                      child: Container(
                        height: profileImageSize,
                        width: profileImageSize,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(profileImageSize / 2),
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: state.user.profilePicture == null
                              ? const AssetImage('assets/default_avatar.png')
                                  as ImageProvider
                              : CachedNetworkImageProvider(
                                  state.user.profilePicture!,
                                ),
                        ),
                      ),
                    ),
                    if (currentUser.id == state.user.id)
                      const SizedBox.shrink()
                    else
                      const FollowIcon(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
