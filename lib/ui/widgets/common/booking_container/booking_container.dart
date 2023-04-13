import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';
import 'package:skeletons/skeletons.dart';
import 'package:timeago/timeago.dart' as timeago;

class BookingContainer extends StatelessWidget {
  const BookingContainer({
    required this.booking,
    this.onConfirm,
    this.onDeny,
    super.key,
  });

  final Booking booking;
  final void Function(Booking)? onConfirm;
  final void Function(Booking)? onDeny;

  Widget venueTile(DatabaseRepository database) => FutureBuilder<UserModel?>(
        future: database.getUserById(booking.requesteeId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SkeletonListTile();
          }

          final requestee = snapshot.data;
          if (requestee == null) {
            return SkeletonListTile();
          }

          return FutureBuilder<bool>(
            future: database.isVerified(requestee.id),
            builder: (context, snapshot) {
              final isVerified = snapshot.data ?? false;

              return ListTile(
                onTap: () {
                  context.read<NavigationBloc>().add(PushBooking(booking));
                },
                enabled: booking.status != BookingStatus.canceled,
                leading: UserAvatar(
                  radius: 20,
                  backgroundImageUrl: requestee.profilePicture,
                  verified: isVerified,
                ),
                title: Text(requestee.displayName),
                subtitle: Text(
                  timeago.format(
                    booking.startTime,
                    allowFromNow: true,
                  ),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                trailing: FutureBuilder<bool>(
                  future: database.hasUserReviewedBooking(
                    requestee.id,
                    booking.id,
                  ),
                  builder: (context, snapshot) {
                    final hasReviewed = snapshot.data ?? true;

                    if (booking.isExpired &&
                        booking.isConfirmed &&
                        !hasReviewed) {
                      return FilledButton(
                        onPressed: () {
                          context.read<NavigationBloc>().add(
                                PushCreateReview(booking),
                              );
                        },
                        child: const Text('Review'),
                      );
                    }

                    return Text(
                      EnumToString.convertToString(booking.status),
                      style: TextStyle(
                        color: () {
                          switch (booking.status) {
                            case BookingStatus.pending:
                              return Colors.orange[300];
                            case BookingStatus.confirmed:
                              return Colors.green[300];
                            case BookingStatus.canceled:
                              return Colors.red[300];
                          }
                        }(),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      );

  Widget freeTile(DatabaseRepository database) => FutureBuilder<UserModel?>(
        future: database.getUserById(booking.requesterId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SkeletonListTile();
          }

          final requester = snapshot.data;
          if (requester == null) {
            return SkeletonListTile();
          }

          return FutureBuilder<bool>(
            future: database.isVerified(requester.id),
            builder: (context, snapshot) {
              final isVerified = snapshot.data ?? false;

              return ListTile(
                onTap: () {
                  context.read<NavigationBloc>().add(PushBooking(booking));
                },
                leading: UserAvatar(
                  radius: 20,
                  backgroundImageUrl: requester.profilePicture,
                  verified: isVerified,
                ),
                title: Text(requester.displayName),
                subtitle: Text(
                  timeago.format(
                    booking.startTime,
                    allowFromNow: true,
                  ),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                trailing: FutureBuilder<bool>(
                  future: database.hasUserReviewedBooking(
                    requester.id,
                    booking.id,
                  ),
                  builder: (context, snapshot) {
                    final hasReviewed = snapshot.data ?? true;

                    if (booking.isExpired &&
                        booking.isConfirmed &&
                        !hasReviewed) {
                      return FilledButton(
                        onPressed: () {
                          context.read<NavigationBloc>().add(
                                PushCreateReview(booking),
                              );
                        },
                        child: const Text('Review'),
                      );
                    }

                    return booking.status == BookingStatus.pending
                        ? GestureDetector(
                            child: const Icon(CupertinoIcons.ellipsis),
                            onTap: () => showCupertinoModalPopup<void>(
                              context: context,
                              builder: (BuildContext context) =>
                                  CupertinoActionSheet(
                                title: const Text('Booking Request'),
                                message:
                                    const Text('Accept or Deny the request'),
                                actions: <CupertinoActionSheetAction>[
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      final updated = booking.copyWith(
                                        status: BookingStatus.confirmed,
                                      );
                                      database.updateBooking(updated);
                                      onConfirm?.call(updated);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Accept'),
                                  ),
                                  CupertinoActionSheetAction(
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      final updated = booking.copyWith(
                                        status: BookingStatus.canceled,
                                      );
                                      database.updateBooking(updated);
                                      onDeny?.call(updated);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Deny'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Text(EnumToString.convertToString(booking.status));
                  },
                ),
              );
            },
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);

    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, state) {
        final currentUser = state.currentUser;

        return currentUser.id == booking.requesterId
            ? venueTile(databaseRepository)
            : freeTile(databaseRepository);
      },
    );
  }
}
