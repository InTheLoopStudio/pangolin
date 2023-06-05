import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/app_logger.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/widgets/profile_view/booking_tile.dart';
import 'package:rxdart/rxdart.dart';

class UserBookingsFeed extends StatefulWidget {
  const UserBookingsFeed({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  State<UserBookingsFeed> createState() => _UserBookingsFeedState();
}

class _UserBookingsFeedState extends State<UserBookingsFeed> {
  String get _userId => widget.userId;
  Timer? _debounce;
  final _scrollController = ScrollController();
  List<Booking> _userBookings = const [];
  bool _hasReachedMaxBookings = false;
  BookingsStatus _bookingsStatus = BookingsStatus.initial;
  StreamSubscription<Booking>? _bookingListener;
  late DatabaseRepository _databaseRepository;

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _initBookings({bool clearBookings = true}) async {
    final trace = logger.createTrace('initBookings');
    await trace.start();
    try {
      logger.debug(
        'initBookings $_userId',
      );
      await _bookingListener?.cancel();
      if (clearBookings) {
        setState(() {
          _bookingsStatus = BookingsStatus.initial;
          _userBookings = [];
          _hasReachedMaxBookings = false;
        });
      }

      setState(() {
        _bookingsStatus = BookingsStatus.success;
      });

      _bookingListener = Rx.merge([
        _databaseRepository.getBookingsByRequesteeObserver(
          _userId,
        ),
        _databaseRepository.getBookingsByRequesterObserver(
          _userId,
        ),
      ]).listen((Booking event) {
        logger.debug('booking { ${event.id} : ${event.name} }');
        try {
          if (event.status != BookingStatus.confirmed) {
            return;
          }

          setState(() {
            _bookingsStatus = BookingsStatus.success;
            _userBookings = List.of(_userBookings)..add(event);
            _hasReachedMaxBookings = _userBookings.length < 20;
          });
        } catch (e, s) {
          logger.error('initBookings error', error: e, stackTrace: s);
        }
      });
    } catch (e, s) {
      logger.error('initBookings error', error: e, stackTrace: s);
    } finally {
      await trace.stop();
    }
  }

  Future<void> _fetchMoreBookings() async {
    if (_hasReachedMaxBookings) return;

    final trace = logger.createTrace('fetchMoreBookings');
    await trace.start();
    try {
      if (_bookingsStatus == BookingsStatus.initial) {
        await _initBookings();
      }

      final bookingsRequestee =
          await _databaseRepository.getBookingsByRequestee(
        _userId,
        limit: 10,
        lastBookingRequestId:
            _userBookings.where((e) => e.requesteeId == _userId).last.id,
      );
      final bookingsRequester =
          await _databaseRepository.getBookingsByRequester(
        _userId,
        limit: 10,
        lastBookingRequestId:
            _userBookings.where((e) => e.requesterId == _userId).last.id,
      );

      (bookingsRequestee.isEmpty && bookingsRequester.isEmpty)
          ? setState(() {
              _hasReachedMaxBookings = true;
            })
          : setState(() {
              _bookingsStatus = BookingsStatus.success;
              _userBookings = List.of(_userBookings)
                ..addAll(bookingsRequestee)
                ..addAll(bookingsRequester);
              _hasReachedMaxBookings = false;
            });
    } catch (e, s) {
      logger.error(
        'fetchMoreBookings error',
        error: e,
        stackTrace: s,
      );
      // emit(_copyWith(bookingsStatus: BookingsStatus.failure));
    } finally {
      await trace.stop();
    }
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (_isBottom) _fetchMoreBookings();
    });
  }

  @override
  void initState() {
    super.initState();
    _databaseRepository = context.read<DatabaseRepository>();
    _scrollController.addListener(_onScroll);
    _initBookings();
  }

  Widget _buildUserBookingFeed(UserModel user) => switch (_bookingsStatus) {
        BookingsStatus.initial => const Text('Waiting for New Bookings...'),
        BookingsStatus.failure => const Center(
            child: Text('failed to fetch bookings'),
          ),
        BookingsStatus.success => () {
            if (_userBookings.isEmpty || user.deleted) {
              return const Text('No bookings yet...');
            }

            return CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  stretch: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.read<NavigationBloc>().add(
                          const Pop(),
                        ),
                  ),
                  title: Text(
                    user.artistName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                  ),
                  centerTitle: false,
                  onStretchTrigger: () async {
                    await _initBookings();
                  },
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                    // itemExtent: 100,
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return BookingTile(
                          visitedUser: user,
                          booking: _userBookings[index],
                        );
                      },
                      childCount: _userBookings.length,
                    ),
                  ),
                ),
              ],
            );
          }(),
      };

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<Option<UserModel>>(
        future: _databaseRepository.getUserById(_userId),
        builder: (context, snapshot) {
          final user = snapshot.data;
          return switch (user) {
            null => const Center(child: CircularProgressIndicator()),
            None() => const Center(child: Text('User not found')),
            Some(:final value) => _buildUserBookingFeed(value),
          };
        },
      ),
    );
  }
}

enum BookingsStatus {
  initial,
  success,
  failure,
}
