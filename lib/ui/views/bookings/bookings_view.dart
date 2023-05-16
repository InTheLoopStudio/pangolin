import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/ui/views/messaging/messaging_view.dart';
import 'package:intheloopapp/ui/widgets/booking_view/bookings_list.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        context.read<BookingsBloc>().add(FetchBookings());
        return Future<void>(() => null);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        extendBodyBehindAppBar: true,
        // appBar: const TappedAppBar(title: 'Bookings'),
        body: BlocBuilder<BookingsBloc, BookingsState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  flexibleSpace: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 7,
                        sigmaY: 7,
                      ),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bookings',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder<int?>(
                        stream: StreamChat.of(context)
                            .client
                            .on()
                            .where((event) => event.unreadChannels != null)
                            .map(
                              (event) => event.unreadChannels,
                            ),
                        builder: (context, snapshot) {
                          final unreadMessagesCount = snapshot.data ?? 0;

                          return FilledButton.icon(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                Colors.grey.withOpacity(0.1),
                              ),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                Colors.white,
                              ),
                              overlayColor:
                                  MaterialStateProperty.all<Color>(
                                Colors.transparent,
                              ),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute<MessagingChannelListView>(
                                builder: (_) =>
                                    const MessagingChannelListView(),
                              ),
                            ),
                            label: Text('$unreadMessagesCount'),
                            icon: const Icon(
                              CupertinoIcons.bubble_left_fill,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 12),
                ),
                const SliverToBoxAdapter(
                  child: Text(
                    'Booking Requests',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                BookingsList(
                  bookings: state.pendingBookings,
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 12),
                ),
                const SliverToBoxAdapter(
                  child: Text(
                    'Upcoming Bookings',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                BookingsList(
                  bookings: state.upcomingBookings,
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 12),
                ),
                const SliverToBoxAdapter(
                  child: Text(
                    'Past Bookings',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                BookingsList(
                  bookings: state.pastBookings,
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 12),
                ),
                const SliverToBoxAdapter(
                  child: Text(
                    'Canceled Bookings',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                BookingsList(
                  bookings: state.canceledBookings,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
