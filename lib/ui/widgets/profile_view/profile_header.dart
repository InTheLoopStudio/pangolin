import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';
import 'package:intheloopapp/ui/widgets/profile_view/follow_button.dart';
import 'package:intheloopapp/ui/widgets/profile_view/follower_count.dart';
import 'package:intheloopapp/ui/widgets/profile_view/following_count.dart';
import 'package:intheloopapp/ui/widgets/profile_view/notification_icon_button.dart';
import 'package:intheloopapp/ui/widgets/profile_view/social_media_icons.dart';
import 'package:share_plus/share_plus.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dynamicLinkRepository =
        RepositoryProvider.of<DynamicLinkRepository>(context);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              height: 250,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                color: tappedAccent,
              ),
            ),
            if (state.currentUser.id == state.visitedUser.id)
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    child: NotificationIconButton(),
                  ),
                ],
              )
            else
              const SizedBox.shrink(),
            Container(
              transform: Matrix4.translationValues(0, 20, 0),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Stack(
                children: [
                  Card(
                    color: theme.colorScheme.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.visitedUser.username.toString(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: GestureDetector(
                                  onTap: () async {
                                    final link = await dynamicLinkRepository
                                        .getShareProfileDynamicLink(
                                      state.visitedUser,
                                    );
                                    await Share.share(
                                      'Check out this profile on Tapped $link',
                                    );
                                  },
                                  child: const Icon(Icons.share),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.visitedUser.bio,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const FollowButton(),
                          const SizedBox(height: 20),
                          const SocialMediaIcons(),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '${state.visitedUser.loopsCount} Loops',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const FollowerCount(),
                              const FollowingCount(),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    transform: Matrix4.translationValues(0, -40, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UserAvatar(
                          radius: 48,
                          backgroundImageUrl: state.visitedUser.profilePicture,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
