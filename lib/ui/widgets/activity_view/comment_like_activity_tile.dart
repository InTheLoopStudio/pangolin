import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentLikeActivityTile extends StatelessWidget {
  const CommentLikeActivityTile({
    required this.activity,
    super.key,
  });

  final CommentLike activity;

  Future<void> onClick(BuildContext context) async {
    final nav = context.read<NavigationBloc>();

    final database = context.read<DatabaseRepository>();
    final loop = await database.getLoopById(activity.rootId);
    if (loop.isNone) {
      return;
    }

    nav.add(PushLoop(loop.unwrap));
  }

  @override
  Widget build(BuildContext context) {
    final databaseRepository = context.read<DatabaseRepository>();

    var markedRead = activity.markedRead;

    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        return FutureBuilder<Option<UserModel>>(
          future: databaseRepository.getUserById(
            activity.fromUserId,
          ),
          builder: (context, snapshot) {
            final user = snapshot.data;
            return switch (user) {
              null => const SizedBox.shrink(),
              None() => const SizedBox.shrink(),
              Some(:final value) => () {
                  if (value.deleted) {
                    return const SizedBox.shrink();
                  }

                  if (!markedRead) {
                    context
                        .read<ActivityBloc>()
                        .add(MarkActivityAsReadEvent(activity: activity));
                    markedRead = true;
                  }

                  return FutureBuilder<bool>(
                    future: databaseRepository.isVerified(value.id),
                    builder: (context, snapshot) {
                      final isVerified = snapshot.data ?? false;

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => onClick(
                              context,
                            ),
                            child: ListTile(
                              tileColor: markedRead ? null : Colors.grey[900],
                              leading: UserAvatar(
                                radius: 20,
                                pushId: activity.fromUserId,
                                imageUrl: value.profilePicture,
                                verified: isVerified,
                              ),
                              trailing: Text(
                                timeago.format(
                                  activity.timestamp,
                                  locale: 'en_short',
                                ),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight:
                                      markedRead ? null : FontWeight.bold,
                                ),
                              ),
                              title: Text(
                                value.displayName,
                                style: TextStyle(
                                  fontWeight:
                                      markedRead ? null : FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'liked your comment ❤️',
                                style: TextStyle(
                                  fontWeight:
                                      markedRead ? null : FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }(),
            };
          },
        );
      },
    );
  }
}
