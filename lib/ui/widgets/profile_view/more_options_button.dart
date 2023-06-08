import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:share_plus/share_plus.dart';

class MoreOptionsButton extends StatelessWidget {
  const MoreOptionsButton({super.key});

  void _showActionSheet(
    BuildContext context,
    UserModel user,
    UserModel currentUser,
  ) {
    final dynamic = context.read<DynamicLinkRepository>();
    final database = context.read<DatabaseRepository>();
    final nav = context.read<NavigationBloc>();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(user.displayName),
        // message: Text(user.username.username),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              final link = await dynamic.getShareProfileDynamicLink(user);
              await Share.share('Check out this profile on Tapped $link');
              nav.add(const Pop());
            },
            child: const Text('Share'),
          ),
          if (user.id != currentUser.id)
            CupertinoActionSheetAction(
              onPressed: () {
                nav.add(const Pop());
                database
                    .reportUser(
                  reported: user,
                  reporter: currentUser,
                )
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User Reported'),
                    ),
                  );
                });
              },
              child: const Text('Report User'),
            ),
          if (user.id != currentUser.id)
            CupertinoActionSheetAction(
              /// This parameter indicates the action would perform
              /// a destructive action such as delete or exit and turns
              /// the action's text color to red.
              isDestructiveAction: true,
              onPressed: () {
                nav.add(const Pop());
                database
                    .blockUser(
                  currentUserId: currentUser.id,
                  blockedUserId: user.id,
                )
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User Blocked'),
                    ),
                  );
                });
              },
              child: const Text('Block User'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () => _showActionSheet(
            context,
            state.visitedUser,
            state.currentUser,
          ),
          icon: const Icon(
            CupertinoIcons.ellipsis,
          ),
        );
      },
    );
  }
}
