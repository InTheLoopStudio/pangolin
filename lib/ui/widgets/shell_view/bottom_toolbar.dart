import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';

class BottomToolbar extends StatelessWidget {
  BottomToolbar({
    required this.user,
    required this.searchFocusNode,
    super.key,
  });

  final UserModel user;
  final FocusNode searchFocusNode;

  final cupertinoTabController = CupertinoTabController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return CupertinoTabBar(
          onTap: (index) {
            context.read<NavigationBloc>().add(
                  ChangeTab(selectedTab: index),
                );
          },
          activeColor: theme.primaryColor,
          inactiveColor:
              theme.bottomNavigationBarTheme.unselectedItemColor ?? Colors.grey,
          backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
          // backgroundColor: Colors.transparent,
          // inactiveColor: Colors.white,
          currentIndex: state.selectedTab,
          items: [
            // const BottomNavigationBarItem(
            //   icon: Icon(CupertinoIcons.waveform),
            // ),
            const BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.waveform,
              ),
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onDoubleTap: searchFocusNode.requestFocus,
                child: const Icon(CupertinoIcons.search),
              ),
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.tickets),
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bubble_right),
            ),
            // BottomNavigationBarItem(icon: Icon(Icons.person)),
            BottomNavigationBarItem(
              activeIcon: Container(
                height: 35,
                width: 35,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: tappedAccent,
                  borderRadius: BorderRadius.circular(35.0 / 2),
                ),
                child: UserAvatar(
                  radius: 45,
                  backgroundImageUrl: user.profilePicture,
                ),
              ),
              icon: Container(
                height: 30,
                width: 30,
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: theme.bottomNavigationBarTheme.unselectedItemColor,
                  borderRadius: BorderRadius.circular(30.0 / 2),
                ),
                child: UserAvatar(
                  radius: 45,
                  backgroundImageUrl: user.profilePicture,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
