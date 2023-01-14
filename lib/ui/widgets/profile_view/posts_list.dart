import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/widgets/post_feed_view/post_container.dart';

class PostsList extends StatefulWidget {
  const PostsList({Key? key, required this.scrollController})
      : super(key: key);

  final ScrollController scrollController;

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  late ProfileCubit _profileCubit;

  Timer? _debounce;
  ScrollController get _scrollController => widget.scrollController;


  bool get _isBottom {
    if (!_scrollController.hasClients) return false;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (_isBottom) _profileCubit.fetchMoreLoops();
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _profileCubit = context.read<ProfileCubit>();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        switch (state.postStatus) {
          case PostStatus.initial:
            return const EasterEggPlaceholder(
              text: 'Waiting for new posts...',
            );
          case PostStatus.failure:
            return const Center(child: Text('failed to fetch posts'));

          case PostStatus.success:
            if (state.userBadges.isEmpty || state.visitedUser.deleted == true) {
              return const EasterEggPlaceholder(text: 'No Posts Yet');
            }

            return CustomScrollView(
              // The "controller" and "primary" members should be left
              // unset, so that the NestedScrollView can control this
              // inner scroll view.
              // If the "controller" property is set, then this scroll
              // view will not be associated with the NestedScrollView.
              // The PageStorageKey should be unique to this ScrollView;
              // it allows the list to remember its scroll position when
              // the tab view is not on the screen.
              key: const PageStorageKey<String>('posts'),
              slivers: [
                SliverOverlapInjector(
                  // This is the flip side of the SliverOverlapAbsorber
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    // itemExtent: 100,
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return PostContainer(
                          post: state.userPosts[index],
                        );
                      },
                      childCount: state.userBadges.length,
                    ),
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}
