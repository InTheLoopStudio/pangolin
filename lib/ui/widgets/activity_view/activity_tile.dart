import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityTile extends StatelessWidget {
  const ActivityTile({required this.activity, super.key});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    final databaseRepository = context.read<DatabaseRepository>();

    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        return FutureBuilder<UserModel?>(
          future: databaseRepository.getUserById(activity.fromUserId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            } else {
              final user = snapshot.data!;

              if (user.deleted) {
                return const SizedBox.shrink();
              }

              if (!activity.markedRead) {
                context
                    .read<ActivityBloc>()
                    .add(MarkActivityAsReadEvent(activity: activity));
              }

              return FutureBuilder<bool>(
                future: databaseRepository.isVerified(user.id),
                builder: (context, snapshot) {
                  final isVerified = snapshot.data ?? false;                  

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          navigationBloc.add(PushProfile(user.id));
                        },
                        child: ListTile(
                          leading: UserAvatar(
                            radius: 20,
                            backgroundImageUrl: user.profilePicture,
                            verified: isVerified,
                          ),
                          trailing: Text(
                            timeago.format(
                              activity.timestamp,
                              locale: 'en_short',
                            ),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          title: Text(
                            user.displayName,
                          ),
                          subtitle: () {
                            switch (activity.type) {
                              case ActivityType.follow:
                                return const Text('followed you 🤝');
                              case ActivityType.like:
                                return const Text('liked your loop ❤️');
                              case ActivityType.comment:
                                return const Text('commented on your loop 💬');
                              case ActivityType.bookingRequest:
                                return const Text('sent you a booking request 📩');
                              case ActivityType.bookingUpdate:
                                return const Text('updated your booking 📩');
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
                },
              );
            }
          },
        );
      },
    );
  }
}
