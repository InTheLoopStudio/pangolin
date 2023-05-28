import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/linkify.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    final database = context.read<DatabaseRepository>();
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
                                      None() => None(),
                                      Some(:final value) =>
                                        database.getServiceById(
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
                                title:
                                    state.visitedUser.id == booking.requesteeId
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
