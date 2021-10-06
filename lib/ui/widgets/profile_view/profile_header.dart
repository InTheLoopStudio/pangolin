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
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    DynamicLinkRepository dynamicLinkRepository =
        RepositoryProvider.of<DynamicLinkRepository>(context);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
                color: itlAccent,
                image: null,
              ),
            ),
            state.currentUser.id == state.visitedUser.id
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0,
                        ),
                        child: GestureDetector(
                          onTap: () => context
                              .read<NavigationBloc>()
                              .add(PushActivity()),
                          child: NotificationIconButton(),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            Container(
              transform: Matrix4.translationValues(0.0, 20.0, 0.0),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Stack(
                children: [
                  Card(
                    color: theme.colorScheme.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.visitedUser.username,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    final String link =
                                        await dynamicLinkRepository
                                            .getShareProfileDynamicLink(
                                      state.visitedUser,
                                    );
                                    Share.share(
                                        'Check out this profile on In The Loop $link');
                                  },
                                  child: Icon(Icons.share),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            state.visitedUser.bio,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),
                          FollowButton(),
                          SizedBox(height: 20),
                          SocialMediaIcons(),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                (state.visitedUser.loopsCount).toString() +
                                    ' Loops',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              FollowerCount(),
                              FollowingCount(),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    transform: Matrix4.translationValues(0.0, -40.0, 0.0),
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
