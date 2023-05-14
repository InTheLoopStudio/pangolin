import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaIcons extends StatelessWidget {
  const SocialMediaIcons({super.key});

  Widget? _socialMediaIcon(
    bool show, {
    required Color color,
    required Icon icon,
    void Function()? onTap,
  }) {
    return show
        ? GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: color.withOpacity(0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: icon,
                ),
              ),
            ),
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _socialMediaIcon(
                state.visitedUser.twitterHandle != null,
                color: tappedAccent,
                icon: const Icon(
                  FontAwesomeIcons.twitter,
                  color: tappedAccent,
                ),
                onTap: () {
                  launchUrl(
                    Uri(
                      scheme: 'https',
                      path: 'twitter.com/${state.visitedUser.twitterHandle}',
                    ),
                  );
                },
              ),
              _socialMediaIcon(
                state.visitedUser.instagramHandle != null,
                color: Colors.pink,
                icon: const Icon(
                  FontAwesomeIcons.instagram,
                  color: Colors.pink,
                ),
                onTap: () {
                  launchUrl(
                    Uri(
                      scheme: 'https',
                      path:
                          'instagram.com/${state.visitedUser.instagramHandle}',
                    ),
                  );
                },
              ),
              _socialMediaIcon(
                state.visitedUser.tiktokHandle != null,
                color: Colors.black,
                icon: const Icon(FontAwesomeIcons.tiktok),
                onTap: () {
                  launchUrl(
                    Uri(
                      scheme: 'https',
                      path: 'tiktok.com/@${state.visitedUser.tiktokHandle}',
                    ),
                  );
                },
              ),
              _socialMediaIcon(
                state.visitedUser.youtubeChannelId != null,
                color: Colors.red,
                icon:  Icon(
                  FontAwesomeIcons.youtube,
                  color: Colors.red.shade700,
                ),
                onTap: () {
                  launchUrl(
                    Uri(
                      scheme: 'https',
                      path:
                          'youtube.com/channel/${state.visitedUser.youtubeChannelId}',
                    ),
                  );
                },
              ),
              _socialMediaIcon(
                state.visitedUser.spotifyId != null,
                color: Colors.green,
                icon: const Icon(
                  FontAwesomeIcons.spotify,
                  color: Colors.green,
                ),
                onTap: () {
                  launchUrl(
                    Uri(
                      scheme: 'https',
                      path:
                          'open.spotify.com/artist/${state.visitedUser.spotifyId}',
                    ),
                  );
                },
              ),
            ].where((element) => element != null).whereType<Widget>().toList(),
          ),
        );
      },
    );
  }
}
