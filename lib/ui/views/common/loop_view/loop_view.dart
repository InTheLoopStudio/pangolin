import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/linkify.dart';
import 'package:intheloopapp/ui/views/common/comments/comments_cubit.dart';
import 'package:intheloopapp/ui/views/common/loading/loop_loading_view.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';
import 'package:intheloopapp/ui/widgets/comments/comments_list.dart';
import 'package:intheloopapp/ui/widgets/comments/comments_text_field.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/attachments.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/like_button.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class LoopView extends StatelessWidget {
  const LoopView({
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
              return const LoopLoadingView();
            }

            final user = snapshot.data;
            if (user == null) {
              return const LoopLoadingView();
            }

            return BlocProvider<LoopViewCubit>(
              create: (context) => LoopViewCubit(
                databaseRepository: databaseRepository,
                loop: loop,
                currentUser: currentUser,
                user: user,
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
                        appBar: AppBar(
                          title: GestureDetector(
                            onTap: () =>
                                navigationBloc.add(PushProfile(user.id)),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    // + User Avatar
                                    UserAvatar(
                                      radius: 24,
                                      backgroundImageUrl: user.profilePicture,
                                      verified: state.isVerified,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 28,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.artistName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                        body: BlocProvider(
                          create: (context) => CommentsCubit(
                            currentUser: currentUser,
                            databaseRepository: databaseRepository,
                            loop: loop,
                            loopViewCubit: context.read<LoopViewCubit>(),
                          )..initComments(),
                          child: CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Linkify(
                                        text: loop.description,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Attachments(
                                        loop: loop,
                                        loopUser: user,
                                      ),
                                      Row(
                                        children: [
                                          LikeButton(
                                            onLike: () => context
                                                .read<LoopViewCubit>()
                                                .toggleLikeLoop,
                                            likeCount: state.likeCount,
                                            isLiked: state.isLiked,
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
                                    ],
                                  ),
                                ),
                              ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 8),
                              ),
                              const SliverToBoxAdapter(
                                child: CommentsTextField(),
                              ),
                              const CommentsList(),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 50),
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
  }
}
