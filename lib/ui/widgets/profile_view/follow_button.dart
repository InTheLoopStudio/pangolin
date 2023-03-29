import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
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
                        ? Theme.of(context).colorScheme.background
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
            : FilledButton.icon(
                onPressed: () async {
                  navigationBloc.add(const PushSettings());
                },
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
      },
    );
  }
}
