import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/profile/profile_view.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityTile extends StatelessWidget {
  const ActivityTile({Key? key, required this.activity}) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        DatabaseRepository databaseRepository =
            context.read<DatabaseRepository>();

        if (!activity.markedRead) {
          context
              .read<ActivityBloc>()
              .add(MarkActivityAsReadEvent(activity: activity));
        }

        return FutureBuilder(
          future: databaseRepository.getUser(activity.fromUserId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return SizedBox.shrink();
            } else {
              UserModel user = snapshot.data;

              if (user.deleted == true) {
                return SizedBox.shrink();
              }

              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileView(
                            visitedUserId: user.id,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: UserAvatar(
                        radius: 20,
                        backgroundImageUrl: user.profilePicture,
                      ),
                      trailing: Text(
                        timeago.format(
                          activity.timestamp.toDate(),
                          locale: 'en_short',
                        ),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      title: Text(
                        '${user.username}',
                      ),
                      subtitle: () {
                        switch (activity.type) {
                          case ActivityType.follow:
                            return Text('followed you 🤝');
                          case ActivityType.like:
                            return Text('liked your loop ❤️');
                          case ActivityType.comment:
                            return Text('commented on your loop 💬');
                        }
                      }(),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15),
                  //   child: Divider(
                  //     color: Colors.deepPurple,
                  //     thickness: 1,
                  //   ),
                  // ),
                ],
              );
            }
          },
        );
      },
    );
  }
}
