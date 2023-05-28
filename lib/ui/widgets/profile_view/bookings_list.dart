import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';

class BookingsList extends StatefulWidget {
  const BookingsList({
    required this.scrollController,
    super.key,
  });

  final ScrollController scrollController;

  @override
  BookingsListState createState() => BookingsListState();
}

class BookingsListState extends State<BookingsList> {
  late ProfileCubit _profileCubit;

  Timer? _debounce;
  ScrollController get _scrollController => widget.scrollController;

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (_isBottom) _profileCubit.fetchMoreBookings();
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _profileCubit = context.read<ProfileCubit>();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return switch (state.bookingsStatus) {
          BookingsStatus.initial => const Text(
              'Waiting for new bookings...',
            ),
          BookingsStatus.failure => const Center(
              child: Text('failed to fetch bookings'),
            ),
          BookingsStatus.success => () {
              if (state.userBookings.isEmpty || state.visitedUser.deleted) {
                return const Text('No Bookings Yet');
              }

              return CustomScrollView(
                // The "controller" and "primary" members should be left
                // unset, so that the NestedScrollView can control this
                // inner scroll view.
                // If the "controller" property is set, then this scroll
                // view will not be associated with the NestedScrollView.
                // The PageStorageKey should be unique to this ScrollView;
                // it allows the list to remember its scroll position when
                // the tab view is not on the screen.
                key: const PageStorageKey<String>('bookings'),
                slivers: [
                  SliverOverlapInjector(
                    // This is the flip side of the SliverOverlapAbsorber
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverList(
                      // itemExtent: 100,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final booking = state.userBookings[index];
                          return ListTile(
                            leading: const Icon(Icons.book),
                            title: Text('Collab Request'),
                            subtitle: booking.requesteeId == state.visitedUser.id 
                              ? Text('You requested ${state.visitedUser.displayName} to collab on ${booking.serviceId}')
                              : Text('${state.visitedUser.displayName} requested you to collab on ${booking.serviceId}'),
                            trailing: Text(booking.startTime.toIso8601String()),
                          );
                        },
                        childCount: state.userBookings.length,
                      ),
                    ),
                  ),
                ],
              );
            }(),
        };
      },
    );
  }
}
