import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';

class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.read<NavigationBloc>().add(const PushActivity()),
          child: badges.Badge(
            onTap: () =>
                context.read<NavigationBloc>().add(const PushActivity()),
            badgeContent: Text('${state.unreadActivitiesCount}'),
            showBadge: state.unreadActivities,
            child: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.outline,
              size: 30,
            ),
          ),
        );
      },
    );
  }
}
