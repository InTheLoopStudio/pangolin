import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:share_plus/share_plus.dart';

class ShareProfileButton extends StatelessWidget {
  const ShareProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamicLinkRepository =
        RepositoryProvider.of<DynamicLinkRepository>(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () async {
            final link =
                await dynamicLinkRepository.getShareProfileDynamicLink(
              state.visitedUser,
            );
            await Share.share('Check out this profile on Tapped $link');
          },
          icon: const Icon(
            Icons.ios_share_outlined,
          ),
        );
      },
    );
  }
}
