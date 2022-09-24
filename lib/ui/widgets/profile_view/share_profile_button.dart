import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:share_plus/share_plus.dart';

class ShareProfileButton extends StatelessWidget {
  const ShareProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DynamicLinkRepository dynamicLinkRepository =
        RepositoryProvider.of<DynamicLinkRepository>(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: GestureDetector(
            onTap: () async {
              final String link =
                  await dynamicLinkRepository.getShareProfileDynamicLink(
                state.visitedUser,
              );
              Share.share('Check out this profile on Tapped $link');
            },
            child: Icon(Icons.ios_share_outlined),
          ),
        );
      },
    );
  }
}
