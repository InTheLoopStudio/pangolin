import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_container.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/audio_controls.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/control_buttons.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/title_text.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/user_info.dart';

class LoopContainer extends StatelessWidget {
  const LoopContainer({
    required this.loop,
    super.key,
  });

  final Loop loop;

  Widget _loopContainer({
    required NavigationBloc navigationBloc,
    required UserModel loopUser,
    required String currentUserId,
  }) =>
      GestureDetector(
        onTap: () => navigationBloc.add(
          PushLoop(loop),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfo(
                loopUser: loopUser,
                timestamp: loop.timestamp,
              ),
              TitleText(title: loop.title),
              const SizedBox(height: 14),
              if (loop.description.isNotEmpty)
                Column(
                  children: [
                    Linkify(
                      text: loop.description,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                )
              else
                const SizedBox.shrink(),
              AudioControls(
                audioPath: loop.audioPath,
                title: loop.title,
                artist: loopUser.displayName,
                profilePicture: loopUser.profilePicture,
              ),
              ControlButtons(
                loopId: loop.id,
                currentUserId: currentUserId,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);

    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, authState) {
        final currentUser = authState.currentUser;

        return FutureBuilder<UserModel?>(
          future: databaseRepository.getUserById(loop.userId),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) {
              return const LoadingContainer();
            }

            final loopUser = userSnapshot.data;
            if (loopUser == null) {
              return const LoadingContainer();
            }

            return BlocProvider<LoopContainerCubit>(
              create: (context) => LoopContainerCubit(
                databaseRepository: databaseRepository,
                loop: loop,
                currentUser: currentUser,
                audioRepo: context.read<AudioRepository>(),
              ),
              child: BlocBuilder<LoopContainerCubit, LoopContainerState>(
                builder: (context, state) {
                  if (currentUser.id == loop.userId) {
                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          if (currentUser.id == loop.userId)
                            SlidableAction(
                              onPressed: (context) {
                                context.read<LoopContainerCubit>().deleteLoop();
                              },
                              backgroundColor: Colors.red[600]!,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            )
                          else
                            const SizedBox.shrink(),
                        ],
                      ),
                      child: _loopContainer(
                        navigationBloc: navigationBloc,
                        loopUser: loopUser,
                        currentUserId: currentUser.id,
                      ),
                    );
                  }

                  return _loopContainer(
                    navigationBloc: navigationBloc,
                    loopUser: loopUser,
                    currentUserId: currentUser.id,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
