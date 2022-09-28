import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/views/settings/settings_view.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return state.currentUser.id != state.visitedUser.id
            ? GestureDetector(
                onTap: () => context.read<ProfileCubit>()
                  ..toggleFollow(state.currentUser.id, state.visitedUser.id),
                child: Container(
                  width: 110,
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: state.isFollowing
                        ? Theme.of(context).backgroundColor
                        : tappedAccent,
                    border: Border.all(color: tappedAccent),
                  ),
                  child: Center(
                    child: Text(
                      state.isFollowing ? 'Following' : 'Follow',
                      style: TextStyle(
                        fontSize: 17,
                        color: state.isFollowing ? tappedAccent : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            : OutlinedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsView(),
                    ),
                  );
                },
                icon: const Icon(
                  CupertinoIcons.gear,
                  color: tappedAccent,
                ),
                label: const Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 20,
                    color: tappedAccent,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              );
      },
    );
  }
}
