import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class BookingContainer extends StatelessWidget {
  const BookingContainer({
    required this.booking,
    required this.onConfirm,
    required this.onDeny,
    Key? key,
  }) : super(key: key);

  final Booking booking;
  final void Function(Booking) onConfirm;
  final void Function(Booking) onDeny;

  Widget venueTile(DatabaseRepository database) => FutureBuilder<UserModel?>(
        future: database.getUserById(booking.requesteeId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final requestee = snapshot.data;
          if (requestee == null) {
            return const CircularProgressIndicator();
          }

          return ListTile(
            leading: UserAvatar(
              radius: 20,
              backgroundImageUrl: requestee.profilePicture,
            ),
            title: Text(requestee.username.toString()),
            subtitle: Text(
              timeago.format(
                booking.bookingDate,
                allowFromNow: true,
              ),
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: Text(
              EnumToString.convertToString(booking.status),
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          );
        },
      );

  Widget freeTile(DatabaseRepository database) => FutureBuilder<UserModel?>(
        future: database.getUserById(booking.requesterId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final requester = snapshot.data;
          if (requester == null) {
            return const CircularProgressIndicator();
          }

          return ListTile(
            leading: UserAvatar(
              radius: 20,
              backgroundImageUrl: requester.profilePicture,
            ),
            title: Text(requester.username.toString()),
            subtitle: Text(
              timeago.format(
                booking.bookingDate,
                allowFromNow: true,
              ),
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: booking.status == BookingStatus.pending
                ? GestureDetector(
                    child: const Icon(CupertinoIcons.ellipsis),
                    onTap: () => showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(
                        title: const Text('Booking Request'),
                        message: const Text('Accept or Deny the request'),
                        actions: <CupertinoActionSheetAction>[
                          CupertinoActionSheetAction(
                            onPressed: () {
                              final updated = booking.copyWith(
                                status: BookingStatus.confirmed,
                              );
                              database.updateBooking(updated);
                              onConfirm(updated);
                              Navigator.pop(context);
                            },
                            child: const Text('Accept'),
                          ),
                          CupertinoActionSheetAction(
                            isDestructiveAction: true,
                            onPressed: () {
                              final updated = booking.copyWith(
                                status: BookingStatus.confirmed,
                              );
                              database.updateBooking(updated);
                              onDeny(updated);
                              Navigator.pop(context);
                            },
                            child: const Text('Deny'),
                          ),
                        ],
                      ),
                    ),
                  )
                : Text(EnumToString.convertToString(booking.status)),
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
        switch (currentUser.accountType) {
          case AccountType.venue:
            return venueTile(databaseRepository);
          case AccountType.free:
            return freeTile(databaseRepository);
        }
      },
    );
  }
}
