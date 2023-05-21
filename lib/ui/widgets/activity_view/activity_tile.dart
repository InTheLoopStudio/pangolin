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

  Future<void> onFollow(BuildContext context, String userId) {
    context.read<NavigationBloc>().add(PushProfile(userId));
    return Future(() => null);
  }

  Future<void> onLike(
    BuildContext context,
    String? loopId,
    String fromUserId,
  ) async {
    final nav = context.read<NavigationBloc>();
    if (loopId == null) {
      nav.add(PushProfile(fromUserId));
      return;
    }

    final database = context.read<DatabaseRepository>();
    final loop = await database.getLoopById(loopId);
    if (loop == null) {
      return;
    }
    nav.add(PushLoop(loop));
  }

  Future<void> onComment(
    BuildContext context,
    String? loopId,
    String fromUserId,
  ) async {
    final nav = context.read<NavigationBloc>();
    if (loopId == null) {
      nav.add(PushProfile(fromUserId));
      return;
    }

    final database = context.read<DatabaseRepository>();
    final loop = await database.getLoopById(loopId);
    if (loop == null) {
      return;
    }
    nav.add(PushLoop(loop));
  }

  Future<void> onBookingRequest(
    BuildContext context,
    String? bookingId,
    String fromUserId,
  ) async {
    final nav = context.read<NavigationBloc>();
    if (bookingId == null) {
      nav.add(PushProfile(fromUserId));
      return;
    }

    final database = context.read<DatabaseRepository>();
    final booking = await database.getBookingById(bookingId);
    if (booking == null) {
      return;
    }

    nav.add(PushBooking(booking));
  }

  Future<void> onBookingUpdate(
    BuildContext context,
    String? bookingId,
    String fromUserId,
  ) async {
    final nav = context.read<NavigationBloc>();
    if (bookingId == null) {
      nav.add(PushProfile(fromUserId));
      return;
    }

    final database = context.read<DatabaseRepository>();
    final booking = await database.getBookingById(bookingId);
    if (booking == null) {
      return;
    }

    nav.add(PushBooking(booking));
  }

  Future<void> onLoopMention(
    BuildContext context,
    String? loopId,
    String fromUserId,
  ) async {
    final nav = context.read<NavigationBloc>();
    if (loopId == null) {
      nav.add(PushProfile(fromUserId));
      return;
    }

    final database = context.read<DatabaseRepository>();
    final loop = await database.getLoopById(loopId);
    if (loop == null) {
      return;
    }
    nav.add(PushLoop(loop));
  }

  Future<void> onCommentMention(
    BuildContext context,
    String? loopId,
  ) async {
    final nav = context.read<NavigationBloc>();
    if (loopId == null) {
      return;
    }

    final database = context.read<DatabaseRepository>();
    final loop = await database.getLoopById(loopId);
    if (loop == null) {
      return;
    }
    nav.add(PushLoop(loop));
  }

  Future<void> onCommentLike(
    BuildContext context,
    String? loopId,
    String fromUserId,
  ) async {
    final nav = context.read<NavigationBloc>();
    if (loopId == null) {
      nav.add(PushProfile(fromUserId));
      return;
    }

    final database = context.read<DatabaseRepository>();
    final loop = await database.getLoopById(loopId);
    if (loop == null) {
      return;
    }
    nav.add(PushLoop(loop));
  }

  @override
  Widget build(BuildContext context) {
    final databaseRepository = context.read<DatabaseRepository>();

    var markedRead = activity.markedRead;

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

              if (!markedRead) {
                context
                    .read<ActivityBloc>()
                    .add(MarkActivityAsReadEvent(activity: activity));
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
                          final _ = switch (activity) {
                            Follow(:final fromUserId) => onFollow(
                                context,
                                fromUserId,
                              ),
                            Like(:final loopId, :final fromUserId) => onLike(
                                context,
                                loopId,
                                fromUserId,
                              ),
                            CommentActivity(:final rootId, :final fromUserId) =>
                              onComment(
                                context,
                                rootId,
                                fromUserId,
                              ),
                            BookingRequest(
                              :final bookingId,
                              :final fromUserId,
                            ) =>
                              onBookingRequest(
                                context,
                                bookingId,
                                fromUserId,
                              ),
                            BookingUpdate(
                              :final bookingId,
                              :final fromUserId,
                            ) =>
                              onBookingUpdate(
                                context,
                                bookingId,
                                fromUserId,
                              ),
                            LoopMention(
                              :final loopId,
                              :final fromUserId,
                            ) =>
                              onLoopMention(
                                context,
                                loopId,
                                fromUserId,
                              ),
                            CommentMention(:final rootId) => onCommentMention(
                                context,
                                rootId,
                              ),
                            CommentLike(
                              :final rootId,
                              :final fromUserId,
                            ) =>
                              onCommentLike(
                                context,
                                rootId,
                                fromUserId,
                              ),
                          };
                        },
                        child: ListTile(
                          tileColor: markedRead ? null : Colors.grey[900],
                          leading: UserAvatar(
                            radius: 20,
                            imageUrl: user.profilePicture,
                            verified: isVerified,
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
                            user.displayName,
                            style: TextStyle(
                              fontWeight: markedRead ? null : FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            () {
                              switch (activity.type) {
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
                                case ActivityType.loopMention:
                                  return 'mentioned you in a loop 📣';
                                case ActivityType.commentMention:
                                  return 'mentioned you in a comment 📣';
                                case ActivityType.commentLike:
                                  return 'liked your comment ❤️';
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
