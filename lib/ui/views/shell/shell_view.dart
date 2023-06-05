import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/bookings/bookings_view.dart';
import 'package:intheloopapp/ui/views/error/error_view.dart';
import 'package:intheloopapp/ui/views/loops_feeds_list/loop_feeds_list_view.dart';
import 'package:intheloopapp/ui/views/profile/new_profile_view.dart';
import 'package:intheloopapp/ui/views/profile/profile_view.dart';
import 'package:intheloopapp/ui/views/search/search_view.dart';
import 'package:intheloopapp/ui/widgets/shell_view/bottom_toolbar.dart';

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
    return BlocSelector<OnboardingBloc, OnboardingState, UserModel?>(
      selector: (state) => (state is Onboarded) ? state.currentUser : null,
      builder: (context, currentUser) {
        if (currentUser == null) {
          return const ErrorView();
        }

        return BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            return Scaffold(
              body: IndexedStack(
                index: state.selectedTab,
                children: [
                  const LoopFeedsListView(), // getstream.io activity feed?
                  SearchView(
                    searchFocusNode: searchFocusNode,
                  ),
                  const BookingsView(),
                  NewProfileView(visitedUserId: currentUser.id),
                  // ProfileView(visitedUserId: currentUser.id),
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
  }
}
