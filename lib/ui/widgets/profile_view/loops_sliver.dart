import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container.dart';

class LoopsSliver extends StatelessWidget {
  const LoopsSliver({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.read<NavigationBloc>();
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.userLoops.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: GestureDetector(
                onTap: () {
                  nav.add(
                    PushLoops(userId: state.visitedUser.id),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'Latest Loop',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'see all',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: tappedAccent,
                      ),
                    ),
                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 16,
                      color: tappedAccent,
                    ),
                  ],
                ),
              ),
            ),
            LoopContainer(
              loop: state.userLoops.first,
            ),
          ],
        );
      },
    );
  }
}
