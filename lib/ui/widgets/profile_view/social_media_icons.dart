import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaIcons extends StatelessWidget {
  const SocialMediaIcons({Key? key}) : super(key: key);

  Widget _socialMediaIcon(
    bool show, {
    required Icon icon,
    void Function()? onTap,
  }) {
    return show
        ? GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: icon,
            ),
          )
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialMediaIcon(
              state.visitedUser.twitterHandle.isNotEmpty,
              icon: Icon(FontAwesomeIcons.twitter),
              onTap: () {
                launch(
                  Uri(
                    scheme: 'https',
                    path: 'twitter.com/' + state.visitedUser.twitterHandle,
                  ).toString(),
                );
              },
            ),
            _socialMediaIcon(
              state.visitedUser.instagramHandle.isNotEmpty,
              icon: Icon(FontAwesomeIcons.instagram),
              onTap: () {
                launch(
                  Uri(
                    scheme: "https",
                    path: 'instagram.com/' + state.visitedUser.instagramHandle,
                  ).toString(),
                );
              },
            ),
            _socialMediaIcon(
              state.visitedUser.tiktokHandle.isNotEmpty,
              icon: Icon(FontAwesomeIcons.tiktok),
              onTap: () {
                launch(
                  Uri(
                    scheme: "https",
                    path: 'tiktok.com/@' + state.visitedUser.tiktokHandle,
                  ).toString(),
                );
              },
            ),
            _socialMediaIcon(
              state.visitedUser.soundcloudHandle.isNotEmpty,
              icon: Icon(FontAwesomeIcons.soundcloud),
              onTap: () {
                launch(
                  Uri(
                    scheme: "https",
                    path:
                        'soundcloud.com/' + state.visitedUser.soundcloudHandle,
                  ).toString(),
                );
              },
            ),
            _socialMediaIcon(
              state.visitedUser.youtubeChannelId.isNotEmpty,
              icon: Icon(FontAwesomeIcons.youtube),
              onTap: () {
                launch(
                  Uri(
                    scheme: "https",
                    path: 'youtube.com/channel/' +
                        state.visitedUser.youtubeChannelId,
                  ).toString(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
