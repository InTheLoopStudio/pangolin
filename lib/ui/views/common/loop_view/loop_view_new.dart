import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/controllers/audio_controller.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/common/comments/comments_cubit.dart';
import 'package:intheloopapp/ui/views/common/loading/loop_loading_view.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';
import 'package:intheloopapp/ui/widgets/comments/comments_list.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/play_pause_button.dart';
import 'package:intheloopapp/ui/widgets/loop_view/loop_seek_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

class LoopViewNew extends StatelessWidget {
  const LoopViewNew({
    required this.loop,
    super.key,
  });

  final Loop loop;

  @override
  Widget build(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    final audioRepo = RepositoryProvider.of<AudioRepository>(context);
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, authState) {
        final currentUser = authState.currentUser;
        return FutureBuilder<UserModel?>(
          future: databaseRepository.getUserById(loop.userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LoopLoadingView();
            }

            final user = snapshot.data;
            if (user == null) {
              return const LoopLoadingView();
            }

            return FutureBuilder<AudioController>(
              future: AudioController.fromUrl(
                audioRepo: audioRepo,
                url: loop.audioPath,
                title: loop.title,
                artist: user.displayName,
                image: user.profilePicture,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const LoopLoadingView();
                }

                final audioController = snapshot.data;
                if (audioController == null) {
                  return const LoopLoadingView();
                }

                return BlocProvider<LoopViewCubit>(
                  create: (context) => LoopViewCubit(
                    databaseRepository: databaseRepository,
                    loop: loop,
                    currentUser: currentUser,
                    user: user,
                    audioController: audioController,
                  )
                    ..initLoopLikes()
                    ..checkVerified(),
                  child: BlocBuilder<LoopViewCubit, LoopViewState>(
                    builder: (context, state) {
                      return FutureBuilder<UserModel?>(
                        future: databaseRepository.getUserById(loop.userId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox.shrink();
                          }

                          final user = snapshot.data;
                          if (user == null) {
                            return const SizedBox.shrink();
                          }
                          return Scaffold(
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            floatingActionButton: FloatingActionButton(
                              // TODO: Add functionality
                              onPressed: () => {},
                              child: const Icon(Icons.edit),
                            ),
                            appBar: AppBar(
                              title: GestureDetector(
                                onTap: () =>
                                    navigationBloc.add(PushProfile(user.id)),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        // + User Avatar
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundImage:
                                              user.profilePicture.isEmpty
                                                  ? const AssetImage(
                                                      'assets/default_avatar.png',
                                                    ) as ImageProvider
                                                  : CachedNetworkImageProvider(
                                                      user.profilePicture,
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
                                        Row(
                                          children: [
                                            Text(
                                              user.artistName,
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
                                                size: 8,
                                                color: tappedAccent,
                                              )
                                          ],
                                        ),
                                        Text(
                                          '@${user.username}',
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
                            ),
                            body: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  Text(
                                    loop.description,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      PlayPauseButton(
                                        audioController: state.audioController,
                                      ),
                                      const SizedBox(width: 10),
                                      const LoopSeekBar(),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => context
                                            .read<LoopViewCubit>()
                                            .toggleLikeLoop(),
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
                                      const Icon(
                                        CupertinoIcons.bubble_middle_bottom,
                                        size: 18,
                                        color: Color(0xFF757575),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${state.commentsCount}',
                                        style: const TextStyle(
                                          color: Color(0xFF757575),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Divider(
                                    color: Color(0xFF757575),
                                    height: 10,
                                    thickness: 1,
                                  ),
                                  BlocProvider(
                                    create: (context) => CommentsCubit(
                                      currentUser: currentUser,
                                      databaseRepository: databaseRepository,
                                      loop: loop,
                                      loopViewCubit:
                                          context.read<LoopViewCubit>(),
                                    )..initComments(),
                                    child: CommentsList(
                                      scrollController: ScrollController(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
