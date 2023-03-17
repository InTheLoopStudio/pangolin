import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/views/send_badge/send_badge_view.dart';
import 'package:intheloopapp/ui/widgets/common/badge_container/badge_container.dart';

class VenueDashboard extends StatefulWidget {
  const VenueDashboard({
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  VenueDashboardState createState() => VenueDashboardState();
}

class VenueDashboardState extends State<VenueDashboard> {
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
      if (_isBottom) _profileCubit.fetchMoreUserCreatedBadges();
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
        switch (state.userCreatedBadgeStatus) {
          case UserCreatedBadgesStatus.initial:
            return const EasterEggPlaceholder(
              text: 'Waiting for new badges...',
            );
          case UserCreatedBadgesStatus.failure:
            return const Center(child: Text('failed to fetch badges'));

          case UserCreatedBadgesStatus.success:
            if (state.userCreatedBadges.isEmpty ||
                state.visitedUser.deleted == true) {
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
              key: const PageStorageKey<String>('venue'),
              slivers: [
                SliverOverlapInjector(
                  // This is the flip side of the SliverOverlapAbsorber
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const Text(
                          'Created Badges',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute<SendBadgeView>(
                              builder: (context) => const SendBadgeView(),
                            ),
                          ),
                          child: const Text('Create Badge'),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    // itemExtent: 100,
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return BadgeContainer(
                          badge: state.userCreatedBadges[index],
                        );
                      },
                      childCount: state.userCreatedBadges.length,
                    ),
                  ),
                )
              ],
            );
        }
      },
    );
  }
}
