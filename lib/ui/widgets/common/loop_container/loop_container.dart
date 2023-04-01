import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/dynamic_link_repository.dart';
import 'package:intheloopapp/domains/controllers/audio_controller.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_seek_bar.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/play_pause_button.dart';
import 'package:linkify_text/linkify_text.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletons/skeletons.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    final dynamicLinkRepo = context.read<DynamicLinkRepository>();
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
                artist: loopUser.username.toString(),
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
                    ..initLoopLikes()
                    ..checkVerified(),
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
                            SlidableAction(
                              onPressed: (context) async {
                                final link = await context
                                    .read<DynamicLinkRepository>()
                                    .getShareLoopDynamicLink(loop);
                                await Share.share(
                                  'Check out this loop on Tapped $link',
                                );
                              },
                              backgroundColor: tappedAccent,
                              foregroundColor: Colors.white,
                              icon: Icons.share,
                              label: 'Share',
                            ),
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
                                GestureDetector(
                                  onTap: () => navigationBloc
                                      .add(PushProfile(loopUser.id)),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          // + User Avatar
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundImage: loopUser
                                                    .profilePicture.isEmpty
                                                ? const AssetImage(
                                                    'assets/default_avatar.png',
                                                  ) as ImageProvider
                                                : CachedNetworkImageProvider(
                                                    loopUser.profilePicture,
                                                  ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 28,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (loopUser.artistName.isNotEmpty)
                                            Row(
                                              children: [
                                                Text(
                                                  loopUser.artistName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                if (state.isVerified)
                                                  const Icon(
                                                    Icons.verified,
                                                    size: 14,
                                                    color: tappedAccent,
                                                  )
                                              ],
                                            )
                                          else
                                            const SizedBox.shrink(),
                                          Text(
                                            '@${loopUser.username}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            timeago.format(
                                              loop.timestamp,
                                              locale: 'en_short',
                                            ),
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (loop.title.isNotEmpty)
                                  const SizedBox(height: 14),
                                if (loop.title.isNotEmpty)
                                  Text(
                                    loop.title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => context
                                          .read<LoopContainerCubit>()
                                          .toggleLoopLike(),
                                      child: state.isLiked
                                          ? const Icon(
                                              CupertinoIcons.heart_fill,
                                              size: 18,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              CupertinoIcons.heart,
                                              size: 18,
                                              color: Color(0xFF757575),
                                            ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${state.likeCount}',
                                      style: TextStyle(
                                        color: state.isLiked
                                            ? Colors.red
                                            : const Color(0xFF757575),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () => navigationBloc.add(
                                        PushLoop(
                                          loop,
                                          showComments: true,
                                          autoPlay: false,
                                        ),
                                      ),
                                      child: const Icon(
                                        CupertinoIcons.bubble_middle_bottom,
                                        size: 18,
                                        color: Color(0xFF757575),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${state.commentCount}',
                                      style: const TextStyle(
                                        color: Color(0xFF757575),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () async {
                                        await context
                                            .read<LoopContainerCubit>()
                                            .incrementShares();

                                        final link = await dynamicLinkRepo
                                            .getShareLoopDynamicLink(loop);

                                        await Share.share(
                                          'Check out this loop on Tapped $link',
                                        );
                                      },
                                      child: const Icon(
                                        CupertinoIcons.share,
                                        size: 18,
                                        color: Color(0xFF757575),
                                      ),
                                    ),
                                  ],
                                ),
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
