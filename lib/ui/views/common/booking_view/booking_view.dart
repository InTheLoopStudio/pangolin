import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/user_tile.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class BookingView extends StatelessWidget {
  const BookingView({
    required this.booking,
    this.onConfirm,
    this.onDeny,
    Key? key,
  }) : super(key: key);

  final Booking booking;
  final void Function(Booking)? onConfirm;
  final void Function(Booking)? onDeny;

  String get formattedDate {
    final outputFormat = DateFormat('MM/dd/yyyy');
    final outputDate = outputFormat.format(booking.startTime);
    return outputDate;
  }

  String formattedTime(DateTime time) {
    final outputFormat = DateFormat('HH:mm');
    final outputTime = outputFormat.format(time);
    return outputTime;
  }

  String formattedDuration(Duration d) {
    return d.toString().split('.').first.padLeft(8, '0');
  }

  @override
  Widget build(BuildContext context) {
    final database = RepositoryProvider.of<DatabaseRepository>(context);
    final navigationBloc = context.read<NavigationBloc>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'Booking',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Text(
                'Booker',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder<UserModel?>(
                future: database.getUserById(booking.requesterId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
      
                  final requester = snapshot.data;
                  if (requester == null) {
                    return const CircularProgressIndicator();
                  }
                  return UserTile(user: requester);
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
            const SliverToBoxAdapter(
              child: Text(
                'Band',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder<UserModel?>(
                future: database.getUserById(booking.requesteeId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
      
                  final requestee = snapshot.data;
                  if (requestee == null) {
                    return const CircularProgressIndicator();
                  }
                  return UserTile(user: requestee);
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
            const SliverToBoxAdapter(
              child: Text(
                'Date',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                '${timeago.format(
                  booking.startTime,
                  allowFromNow: true,
                )} on $formattedDate',
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
            const SliverToBoxAdapter(
              child: Text(
                'Duration',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                formattedDuration(booking.endTime.difference(booking.startTime)),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
            const SliverToBoxAdapter(
              child: Text(
                'Start Time',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                formattedTime(booking.startTime),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
            const SliverToBoxAdapter(
              child: Text(
                'End Time',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                formattedTime(booking.endTime),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
            SliverToBoxAdapter(
              child: booking.isPending
                  ? CupertinoButton.filled(
                      onPressed: () {
                        final updated = booking.copyWith(
                          status: BookingStatus.confirmed,
                        );
                        database.updateBooking(updated);
                        onConfirm?.call(updated);
                        Navigator.pop(context);
                      },
                      child: const Text('Confirm Booking'),
                    )
                  : const SizedBox.shrink(),
            ),
            SliverToBoxAdapter(
              child: CupertinoButton(
                onPressed: () {
                  final updated = booking.copyWith(
                    status: BookingStatus.canceled,
                  );
                  database.updateBooking(updated);
                  onDeny?.call(updated);
                  navigationBloc.add(const Pop());
                },
                child: const Text(
                  'Cancel Booking',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
