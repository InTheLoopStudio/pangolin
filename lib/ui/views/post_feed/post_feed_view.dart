import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/post_feed/post_feed_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/post_container/post_container.dart';

class PostFeedView extends StatelessWidget {
  const PostFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => PostFeedCubit(
            currentUserId: state.currentUser.id,
            databaseRepository: RepositoryProvider.of<DatabaseRepository>(
              context,
            ),
          )..initPosts(),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              title: const Row(
                children: [
                  Text(
                    'Gems',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(CupertinoIcons.add),
              onPressed: () => context.read<NavigationBloc>().add(
                    const PushCreatePost(),
                  ),
            ),
            body: RefreshIndicator(
              displacement: 20,
              onRefresh: () async {
                await context
                    .read<PostFeedCubit>()
                    .initPosts(clearPosts: false);
              },
              child: BlocBuilder<PostFeedCubit, PostFeedState>(
                builder: (context, state) {
                  switch (state.status) {
                    case PostFeedStatus.initial:
                      return const LoadingView();
                    case PostFeedStatus.success:
                      if (state.posts.isEmpty) {
                        return const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                EasterEggPlaceholder(
                                  text: 'No Posts',
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        );
                      }

                      return ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                PostContainer(
                                  post: state.posts[index],
                                ),
                                Container(
                                  color: Colors.black,
                                  height: 1,
                                )
                              ],
                            );
                          },
                          itemCount: state.posts.length,
                        );

                    case PostFeedStatus.failure:
                      return const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              EasterEggPlaceholder(
                                text: 'Error Fetching Posts :(',
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
