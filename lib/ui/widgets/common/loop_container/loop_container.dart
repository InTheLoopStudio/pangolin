import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/controllers/audio_controller.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/control_buttons.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_seek_bar.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/play_pause_button.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/title_text.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/user_info.dart';
import 'package:linkify_text/linkify_text.dart';
import 'package:skeletons/skeletons.dart';

class LoopContainer extends StatelessWidget {
  const LoopContainer({
    required this.loop,
    super.key,
  });

  final Loop loop;

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
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SkeletonListTile();
            }

            final loopUser = snapshot.data;
            if (loopUser == null) {
              return const SizedBox.shrink();
            }
            return FutureBuilder<AudioController>(
              future: AudioController.fromUrl(
                audioRepo: context.read<AudioRepository>(),
                url: loop.audioPath,
                title: loop.title,
                artist: loopUser.displayName,
                image: currentUser.profilePicture,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SkeletonListTile();
                }

                final audioController = snapshot.data!;

                return BlocProvider<LoopContainerCubit>(
                  create: (context) => LoopContainerCubit(
                    databaseRepository: databaseRepository,
                    loop: loop,
                    currentUser: currentUser,
                    audioController: audioController,
                  )
                    ..initLoopLikes(),
                  child: BlocBuilder<LoopContainerCubit, LoopContainerState>(
                    builder: (context, state) {
                      return Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            if (currentUser.id == loop.userId)
                              SlidableAction(
                                    onPressed: (context) {
                                      context
                                          .read<LoopContainerCubit>()
                                          .deleteLoop();
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
                        child: GestureDetector(
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
                                      LinkifyText(
                                        loop.description,
                                        fontSize: 14,
                                      ),
                                      const SizedBox(height: 14),
                                    ],
                                  )
                                else
                                  const SizedBox.shrink(),
                                if (loop.audioPath.isNotEmpty)
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          PlayPauseButton(
                                            audioController:
                                                state.audioController,
                                          ),
                                          const Expanded(child: LoopSeekBar()),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                    ],
                                  )
                                else
                                  const SizedBox.shrink(),
                                const ControlButtons(),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
