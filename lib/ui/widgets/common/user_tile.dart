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
    this.subtitle,
    this.trailing,
    super.key,
  });

  final UserModel user;
  final bool showFollowButton;
  final Widget? subtitle;
  final Widget? trailing;

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  bool followingOverride = false;

  Widget _followButton(
    UserModel currentUser,
    DatabaseRepository database,
  ) =>
      (currentUser.id != widget.user.id) && widget.showFollowButton
          ? FutureBuilder<bool>(
              future: database.isFollowingUser(
                currentUser.id,
                widget.user.id,
              ),
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
          : const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    final database = context.read<DatabaseRepository>();

    if (widget.user.deleted) return const SizedBox.shrink();

    return BlocSelector<OnboardingBloc, OnboardingState, UserModel?>(
      selector: (state) => (state is Onboarded) ? state.currentUser : null,
      builder: (context, currentUser) {
        if (currentUser == null) {
          return const ListTile(
            leading: UserAvatar(
              radius: 25,
            ),
            title: Text('ERROR'),
            subtitle: Text("something isn't working right :/"),
          );
        }

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
              subtitle: widget.subtitle ??
                  Text(
                    '${widget.user.followerCount} followers',
                  ),
              trailing: widget.trailing ?? _followButton(
                currentUser,
                database,
              ),
              onTap: () => navigationBloc.add(PushProfile(widget.user.id)),
            );
          },
        );
      },
    );
  }
}
