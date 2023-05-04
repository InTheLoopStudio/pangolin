import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';

class UserTile extends StatefulWidget {
  const UserTile({
    required this.user,
    this.showFollowButton = true,
    super.key,
  });

  final UserModel user;
  final bool showFollowButton;

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  bool followingOverride = false;

  @override
  Widget build(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    final database = context.read<DatabaseRepository>();

    if (widget.user.deleted) return const SizedBox.shrink();

    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, state) {
        final currentUser = state.currentUser;

        return FutureBuilder<bool>(
          future: database.isVerified(widget.user.id),
          builder: (context, snapshot) {
            final verified = snapshot.data ?? false;

            return ListTile(
              leading: UserAvatar(
                radius: 25,
                imageUrl: widget.user.profilePicture,
                verified: verified,
              ),
              title: Text(widget.user.displayName),
              subtitle: Text(
                widget.user.bio,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: (currentUser.id != widget.user.id) &&
                      widget.showFollowButton
                  ? FutureBuilder<bool>(
                      future: database.isFollowingUser(
                          currentUser.id, widget.user.id),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const SizedBox.shrink();

                        final isFollowing = snapshot.data ?? false;

                        return CupertinoButton(
                          onPressed: (!isFollowing && !followingOverride)
                              ? () async {
                                  await database.followUser(
                                    currentUser.id,
                                    widget.user.id,
                                  );
                                  setState(() {
                                    followingOverride = true;
                                  });
                                }
                              : null,
                          child: (!isFollowing && !followingOverride)
                              ? const Text('Follow')
                              : const Text('Following'),
                        );
                      },
                    )
                  : const SizedBox.shrink(),
              onTap: () => navigationBloc.add(PushProfile(widget.user.id)),
            );
          },
        );
      },
    );
  }
}
