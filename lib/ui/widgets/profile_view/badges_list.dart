import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/badge_container/badge_container.dart';

class BadgesList extends StatefulWidget {
  const BadgesList({
    required this.scrollController,
    super.key,
  });

  final ScrollController scrollController;

  @override
  BadgesListState createState() => BadgesListState();
}

class BadgesListState extends State<BadgesList> {
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
      if (_isBottom) _profileCubit.fetchMoreBadges();
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
        switch (state.badgeStatus) {
          case BadgesStatus.initial:
            return const EasterEggPlaceholder(
              text: 'Waiting for new badges...',
            );
          case BadgesStatus.failure:
            return const Center(child: Text('failed to fetch badges'));

          case BadgesStatus.success:
            if (state.userBadges.isEmpty || state.visitedUser.deleted == true) {
              return const EasterEggPlaceholder(text: 'No Badges Yet');
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
              key: const PageStorageKey<String>('badges'),
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
                        return BadgeContainer(
                          badge: state.userBadges[index],
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
