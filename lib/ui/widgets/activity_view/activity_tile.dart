import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityTile extends StatefulWidget {
  const ActivityTile({required this.activity, super.key});

  final Activity activity;

  @override
  State<ActivityTile> createState() => _ActivityTileState();
}

class _ActivityTileState extends State<ActivityTile>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final navigationBloc = context.read<NavigationBloc>();
    final databaseRepository = context.read<DatabaseRepository>();

    var markedRead = widget.activity.markedRead;

    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        return FutureBuilder<UserModel?>(
          future: databaseRepository.getUserById(widget.activity.fromUserId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            } else {
              final user = snapshot.data!;

              if (user.deleted) {
                return const SizedBox.shrink();
              }

              if (!markedRead) {
                context
                    .read<ActivityBloc>()
                    .add(MarkActivityAsReadEvent(activity: widget.activity));
                markedRead = true;
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
                          tileColor: markedRead ? null : Colors.grey[900],
                          leading: UserAvatar(
                            radius: 20,
                            backgroundImageUrl: user.profilePicture,
                            verified: isVerified,
                          ),
                          trailing: Text(
                            timeago.format(
                              widget.activity.timestamp,
                              locale: 'en_short',
                            ),
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: markedRead ? null : FontWeight.bold,
                            ),
                          ),
                          title: Text(
                            user.displayName,
                            style: TextStyle(
                              fontWeight: markedRead ? null : FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            () {
                              switch (widget.activity.type) {
                                case ActivityType.follow:
                                  return 'followed you 🤝';
                                case ActivityType.like:
                                  return 'liked your loop ❤️';
                                case ActivityType.comment:
                                  return 'commented on your loop 💬';
                                case ActivityType.bookingRequest:
                                  return 'sent you a booking request 📩';
                                case ActivityType.bookingUpdate:
                                  return 'updated your booking 📩';
                                case ActivityType.mention:
                                  return 'mentioned you in a loop 📣';
                              }
                            }(),
                            style: TextStyle(
                              fontWeight: markedRead ? null : FontWeight.bold,
                            ),
                          ),
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
