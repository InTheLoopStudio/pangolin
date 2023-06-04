import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:timeago/timeago.dart' as timeago;

class SearchAppearanceActivityTile extends StatelessWidget {
  const SearchAppearanceActivityTile({
    required this.activity,
    super.key,
  });

  final SearchAppearance activity;

  @override
  Widget build(BuildContext context) {

    var markedRead = activity.markedRead;
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        if (!markedRead) {
          context
              .read<ActivityBloc>()
              .add(MarkActivityAsReadEvent(activity: activity));
          markedRead = true;
        }

        return Column(
          children: [
            ListTile(
              tileColor: markedRead ? null : Colors.grey[900],
              leading: const Icon(
                Icons.search_rounded,
                size: 28,
              ),
              trailing: Text(
                timeago.format(
                  activity.timestamp,
                  locale: 'en_short',
                ),
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: markedRead ? null : FontWeight.bold,
                ),
              ),
              title: Text(
                'People are finding you in search!',
                style: TextStyle(
                  fontWeight: markedRead ? null : FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "you've appeared in ${activity.count} searches recently",
                style: TextStyle(
                  fontWeight: markedRead ? null : FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
