import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/linkify.dart';
import 'package:timeago/timeago.dart' as timeago;

class BookingTile extends StatelessWidget {
  const BookingTile({
    required this.booking,
    required this.visitedUser,
    super.key,
  });

  final Booking booking;
  final UserModel visitedUser;

  @override
  Widget build(BuildContext context) {
    final database = context.read<DatabaseRepository>();
    return FutureBuilder<
        (
          Option<UserModel>,
          Option<UserModel>,
          Option<Service>,
        )>(
      future: () async {
        final [
          requester as Option<UserModel>,
          requestee as Option<UserModel>,
          service as Option<Service>,
        ] = await Future.wait(
          [
            database.getUserById(booking.requesterId),
            database.getUserById(booking.requesteeId),
            () async {
              return switch (booking.serviceId) {
                None() => const None<Service>(),
                Some(:final value) => database.getServiceById(
                    booking.requesteeId,
                    value,
                  ),
              };
            }(),
          ],
        );

        return (requester, requestee, service);
      }(),
      builder: (context, snapshot) {
        final (
          Option<UserModel> requester,
          Option<UserModel> requestee,
          Option<Service> service,
        ) = snapshot.data ??
            (
              const None(),
              const None(),
              const None(),
            );

        final requesterUsername = switch (requester) {
          None() => 'UNKNOWN',
          Some(:final value) => '@${value.username}',
        };

        final requesteeUsername = switch (requestee) {
          None() => 'UNKNOWN',
          Some(:final value) => '@${value.username}',
        };

        final serviceTitle = switch (service) {
          None() => 'UNKNOWN',
          Some(:final value) => value.title,
        };

        return ListTile(
          leading: const Icon(Icons.book),
          title: visitedUser.id == booking.requesteeId
              ? const Text(
                  'Performer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const Text(
                  'Booker',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          subtitle: Linkify(
            text:
                // ignore: lines_longer_than_80_chars
                '$requesterUsername booked $requesteeUsername for service "$serviceTitle"',
          ),
          trailing: Text(
            timeago.format(
              booking.startTime,
              allowFromNow: true,
            ),
          ),
        );
      },
    );
  }
}
