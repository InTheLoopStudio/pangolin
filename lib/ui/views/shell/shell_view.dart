import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/bookings/bookings_view.dart';
import 'package:intheloopapp/ui/views/loops_feeds_list/loop_feeds_list_view.dart';
import 'package:intheloopapp/ui/views/messaging/messaging_view.dart';
import 'package:intheloopapp/ui/views/profile/profile_view.dart';
import 'package:intheloopapp/ui/views/search/search_view.dart';
import 'package:intheloopapp/ui/widgets/shell_view/bottom_toolbar.dart';

class ShellView extends StatelessWidget {
  const ShellView({
    super.key,
    this.initialTab = 0,
  });

  final int initialTab;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, userState) {
        final currentUser = userState.currentUser;

        return BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            return Scaffold(
              body: IndexedStack(
                index: state.selectedTab,
                children: [
                  const LoopFeedsListView(), // getstream.io activity feed?
                  const SearchView(),
                  const BookingsView(),
                  const MessagingChannelListView(),
                  ProfileView(visitedUserId: currentUser.id),
                ],
              ),
              bottomNavigationBar: BottomToolbar(
                user: currentUser,
              ),
            );
          },
        );
      },
    );
  }
}
