import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/ui/widgets/common/booking_container/booking_container.dart';

class BookingsList extends StatelessWidget {
  const BookingsList({required this.bookings, super.key});

  final List<Booking> bookings;

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryIconTheme.color ?? Colors.black;

    return BlocBuilder<BookingsBloc, BookingsState>(
      builder: (context, state) {
        return bookings.isEmpty
            ? SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Nothing Yet',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: themeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return BookingContainer(
                      booking: bookings[index],
                      onConfirm: (booking) => context.read<BookingsBloc>().add(
                            ConfirmBooking(booking: booking),
                          ),
                      onDeny: (booking) => context.read<BookingsBloc>().add(
                            DenyBooking(booking: booking),
                          ),
                    );
                  },
                  childCount: bookings.length,
                ),
              );
      },
    );
  }
}
