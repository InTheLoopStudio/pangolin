import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/bookings/bookings_view.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/loops_feeds_list/loop_feeds_list_view.dart';
import 'package:intheloopapp/ui/views/messaging/messaging_view.dart';
import 'package:intheloopapp/ui/views/profile/profile_view.dart';
import 'package:intheloopapp/ui/views/search/search_view.dart';
import 'package:intheloopapp/ui/views/user_feed_view/timeline_page.dart';
import 'package:intheloopapp/ui/views/user_feed_view/user_feed_view.dart';
import 'package:intheloopapp/ui/widgets/shell_view/bottom_toolbar.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ShellView extends StatefulWidget {
  const ShellView({
    super.key,
    this.initialTab = 0,
  });

  final int initialTab;

  @override
  State<ShellView> createState() => _ShellViewState();
}

class _ShellViewState extends State<ShellView> {
  late final FocusNode searchFocusNode;

  @override
  void initState() {
    searchFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, userState) {
        final currentUser = userState.currentUser;

        return BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            return FutureBuilder<void>(
              future: context.feedClient.setUser(
                User(
                  id: 'johannes',
                  data: {
                    'handle': 'johannes',
                    'username': 'johannes',
                    'name': 'Johannes',
                    'image':
                        'https://avatars.githubusercontent.com/u/13705472?v=4',
                  },
                ),
                Token(
                    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiam9oYW5uZXMifQ.pediWm9mqFAvKTGEV31MzG7-tarqJtnFcGeu6MEBqgM'),
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return LoadingView();
                }

                return Scaffold(
                  body: IndexedStack(
                    index: state.selectedTab,
                    children: [
                      const TimelinePage(),
                      const UserFeedView(),
                      const LoopFeedsListView(), // getstream.io activity feed?h
                      SearchView(
                        searchFocusNode: searchFocusNode,
                      ),
                      const BookingsView(),
                      const MessagingChannelListView(),
                      ProfileView(visitedUserId: currentUser.id),
                    ],
                  ),
                  bottomNavigationBar: BottomToolbar(
                    user: currentUser,
                    searchFocusNode: searchFocusNode,
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
