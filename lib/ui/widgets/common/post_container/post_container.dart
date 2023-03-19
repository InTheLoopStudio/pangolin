import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/post.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/widgets/common/post_container/post_container_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostContainer extends StatelessWidget {
  const PostContainer({
    required this.post,
    Key? key,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, authState) {
        final currentUser = authState.currentUser;
        return BlocProvider<PostContainerCubit>(
          create: (context) => PostContainerCubit(
            databaseRepository: databaseRepository,
            post: post,
            currentUser: currentUser,
          )
            ..initPostLikes()
            ..checkVerified(),
          child: BlocBuilder<PostContainerCubit, PostContainerState>(
            builder: (context, state) {
              return FutureBuilder<UserModel?>(
                future: databaseRepository.getUserById(post.userId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  final user = snapshot.data;
                  if (user == null) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => navigationBloc.add(PushProfile(user.id)),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  // + User Avatar
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage: user.profilePicture.isEmpty
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          size: 14,
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
                                      post.timestamp,
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
                        if (post.title.isNotEmpty) const SizedBox(height: 14),
                        if (post.title.isNotEmpty)
                          Text(
                            post.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 14),
                        Text(
                          post.description,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => context
                                  .read<PostContainerCubit>()
                                  .togglePostLike(),
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
                                PushPost(post),
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
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
