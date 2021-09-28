import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';

class BottomToolbar extends StatelessWidget {
  const BottomToolbar({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return CupertinoTabBar(
          onTap: (index) =>
              context.read<NavigationBloc>().add(ChangeTab(selectedTab: index)),
          activeColor: theme.primaryColor,
          inactiveColor:
              theme.bottomNavigationBarTheme.unselectedItemColor ?? Colors.grey,
          backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
          // inactiveColor: Colors.white,
          currentIndex: state.selectedTab,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.headphones_outlined),
              activeIcon: Icon(Icons.headphones_rounded),
            ),
            BottomNavigationBarItem(icon: Icon(Icons.search)),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              activeIcon: Icon(Icons.add_box)
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.comment_outlined),
              activeIcon: Icon(Icons.comment),
            ),
            // BottomNavigationBarItem(icon: Icon(Icons.person)),
            BottomNavigationBarItem(
              activeIcon: Container(
                height: 35.0,
                width: 35.0,
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: itlAccent,
                  borderRadius: BorderRadius.circular(35.0 / 2),
                ),
                child: UserAvatar(
                  radius: 45,
                  backgroundImageUrl: user.profilePicture,
                ),
              ),
              icon: Container(
                height: 30.0,
                width: 30.0,
                padding: EdgeInsets.all(1.0),
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
