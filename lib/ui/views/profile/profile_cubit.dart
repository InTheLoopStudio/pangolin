import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intheloopapp/app_logger.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/badge.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this.databaseRepository,
    required this.places,
    required this.currentUser,
    required this.visitedUser,
  }) : super(
          ProfileState(
            currentUser: currentUser,
            visitedUser: visitedUser,
          ),
        );
  final DatabaseRepository databaseRepository;
  final PlacesRepository places;
  final UserModel currentUser;
  final UserModel visitedUser;
  StreamSubscription<Loop>? loopListener;
  StreamSubscription<Badge>? badgeListener;
  StreamSubscription<Booking>? bookingListener;

  Future<void> refetchVisitedUser({UserModel? newUserData}) async {
    try {
      logger.debug(
        'refetchVisitedUser ${state.visitedUser} : ${newUserData ?? "null"}',
      );
      if (newUserData == null) {
        final refreshedVisitedUser =
            await databaseRepository.getUserById(state.visitedUser.id);
        emit(state.copyWith(visitedUser: refreshedVisitedUser.asNullable()));
      } else {
        emit(state.copyWith(visitedUser: newUserData));
      }
    } catch (e, s) {
      logger.error(
        'refetchVisitedUser error',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> getLatestLoop() async {
    try {
      final loops = await databaseRepository.getUserLoops(
        visitedUser.id,
        limit: 1,
      );

      final latestLoop =
          loops.isNotEmpty ? Some(loops.first) : const None<Loop>();

      emit(state.copyWith(latestLoop: latestLoop));
    } catch (e, s) {
      logger.error(
        'getLatestLoop error',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> getLatestOpportunity() async {
    try {
      final opportunities = await databaseRepository.getUserOpportunities(
        visitedUser.id,
        limit: 1,
      );

      final latestOpportunity = opportunities.isNotEmpty
          ? Some(opportunities.first)
          : const None<Loop>();

      emit(state.copyWith(latestOpportunity: latestOpportunity));
    } catch (e, s) {
      logger.error(
        'getLatestLoop error',
        error: e,
        stackTrace: s,
      );
    }
  }

  Future<void> getLatestBooking() async {
    final trace = logger.createTrace('getLatestBooking');
    await trace.start();
    try {
      final bookingsRequestee = await databaseRepository.getBookingsByRequestee(
        visitedUser.id,
        limit: 1,
      );
      final bookingsRequester = await databaseRepository.getBookingsByRequester(
        visitedUser.id,
        limit: 1,
      );

      final latestRequesteeBooking = bookingsRequestee.isNotEmpty
          ? Some(bookingsRequestee.first)
          : const None<Booking>();

      final latestRequesterBooking = bookingsRequester.isNotEmpty
          ? Some(bookingsRequester.first)
          : const None<Booking>();

      final _ = switch ((latestRequesteeBooking, latestRequesterBooking)) {
        (None(), None()) => emit(state.copyWith(latestBooking: const None())),
        (Some(:final value), None()) =>
          emit(state.copyWith(latestBooking: Some(value))),
        (None(), Some(:final value)) => emit(
            state.copyWith(
              latestBooking: Some(value),
            ),
          ),
        (Some(), Some()) => () {
            final latest = _getLatestBooking(
              latestRequesteeBooking.unwrap,
              latestRequesterBooking.unwrap,
            );
            emit(state.copyWith(latestBooking: Some(latest)));
          }(),
      };
    } catch (e, s) {
      logger.error(
        'fetchMoreBookings error',
        error: e,
        stackTrace: s,
      );
      // emit(state.copyWith(bookingsStatus: BookingsStatus.failure));
    } finally {
      await trace.stop();
    }
  }

  Booking _getLatestBooking(Booking b1, Booking b2) {
    return b1.startTime.isAfter(b2.startTime) ? b1 : b2;
  }

  Future<void> initLoops({bool clearLoops = true}) async {
    final trace = logger.createTrace('initLoops');
    await trace.start();
    try {
      logger.debug(
        'initLoops ${state.visitedUser}',
      );
      await loopListener?.cancel();
      if (clearLoops) {
        emit(
          state.copyWith(
            loopStatus: LoopsStatus.initial,
            userLoops: [],
            hasReachedMaxLoops: false,
          ),
        );
      }

      final userLoops =
          await databaseRepository.getUserLoops(visitedUser.id, limit: 1);
      if (userLoops.isEmpty) {
        emit(state.copyWith(loopStatus: LoopsStatus.success));
      }

      loopListener = databaseRepository
          .userLoopsObserver(visitedUser.id)
          .listen((Loop event) {
        try {
          logger.debug('loop { ${event.id} : ${event.title} }');
          emit(
            state.copyWith(
              loopStatus: LoopsStatus.success,
              userLoops: List.of(state.userLoops)..add(event),
            ),
          );
        } catch (e, s) {
          logger.error('initLoops error', error: e, stackTrace: s);
        }
      });
    } catch (e, s) {
      logger.error('initLoops error', error: e, stackTrace: s);
    } finally {
      await trace.stop();
    }
  }

  Future<void> initBadges({bool clearBadges = true}) async {
    final trace = logger.createTrace('initBadges');
    await trace.start();
    try {
      logger.debug(
        'initBadges ${state.visitedUser}',
      );
      await badgeListener?.cancel();
      if (clearBadges) {
        emit(
          state.copyWith(
            badgeStatus: BadgesStatus.initial,
            userBadges: [],
            hasReachedMaxBadges: false,
          ),
        );
      }

      final badgesAvailable =
          (await databaseRepository.getUserBadges(visitedUser.id, limit: 1))
              .isNotEmpty;
      if (!badgesAvailable) {
        emit(state.copyWith(badgeStatus: BadgesStatus.success));
      }

      badgeListener = databaseRepository
          .userBadgesObserver(visitedUser.id)
          .listen((Badge event) {
        logger.debug('badge { ${event.id} : ${event.name} }');
        try {
          emit(
            state.copyWith(
              badgeStatus: BadgesStatus.success,
              userBadges: List.of(state.userBadges)..add(event),
              hasReachedMaxBadges: state.userBadges.length < 10,
            ),
          );
        } catch (e, s) {
          logger.error('initBadges error', error: e, stackTrace: s);
        }
      });
    } catch (e, s) {
      logger.error('initBadges error', error: e, stackTrace: s);
    } finally {
      await trace.stop();
    }
  }

  Future<void> initBookings({bool clearBookings = true}) async {
    final trace = logger.createTrace('initBookings');
    await trace.start();
    try {
      logger.debug(
        'initBookings ${state.visitedUser}',
      );
      await bookingListener?.cancel();
      if (clearBookings) {
        emit(
          state.copyWith(
            bookingsStatus: BookingsStatus.initial,
            userBookings: [],
            hasReachedMaxBookings: false,
          ),
        );
      }

      emit(state.copyWith(bookingsStatus: BookingsStatus.success));

      bookingListener = Rx.merge([
        databaseRepository.getBookingsByRequesteeObserver(
          visitedUser.id,
        ),
        databaseRepository.getBookingsByRequesterObserver(
          visitedUser.id,
        ),
      ]).listen((Booking event) {
        logger.debug('booking { ${event.id} : ${event.name} }');
        try {
          if (event.status != BookingStatus.confirmed) {
            return;
          }

          emit(
            state.copyWith(
              bookingsStatus: BookingsStatus.success,
              userBookings: List.of(state.userBookings)..add(event),
              hasReachedMaxBookings: state.userBookings.length < 20,
            ),
          );
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

  Future<void> initPlace() async {
    final trace = logger.createTrace('initPlace');
    await trace.start();
    try {
      logger.debug('initPlace ${state.visitedUser}');
      final place = visitedUser.placeId != null
          ? await places.getPlaceById(visitedUser.placeId!)
          : null;
      emit(state.copyWith(place: place));
    } catch (e, s) {
      logger.error('initPlace error', error: e, stackTrace: s);
    } finally {
      await trace.stop();
    }
  }

  Future<void> fetchMoreLoops() async {
    if (state.hasReachedMaxLoops) return;

    final trace = logger.createTrace('fetchMoreLoops');
    await trace.start();
    try {
      if (state.loopStatus == LoopsStatus.initial) {
        await initLoops();
      }

      final loops = await databaseRepository.getUserLoops(
        visitedUser.id,
        // limit: 10,
        lastLoopId: state.userLoops.last.id,
      );
      loops.isEmpty
          ? emit(state.copyWith(hasReachedMaxLoops: true))
          : emit(
              state.copyWith(
                loopStatus: LoopsStatus.success,
                userLoops: List.of(state.userLoops)..addAll(loops),
                hasReachedMaxLoops: false,
              ),
            );
    } catch (e, s) {
      logger.error(
        'fetchMoreLoops error',
        error: e,
        stackTrace: s,
      );
      // emit(state.copyWith(loopStatus: LoopsStatus.failure));
    } finally {
      await trace.stop();
    }
  }

  Future<void> fetchMoreBadges() async {
    if (state.hasReachedMaxBadges) return;

    final trace = logger.createTrace('fetchMoreBadges');
    await trace.start();
    try {
      if (state.badgeStatus == BadgesStatus.initial) {
        await initBadges();
      }

      final badges = await databaseRepository.getUserBadges(
        visitedUser.id,
        limit: 10,
        lastBadgeId: state.userBadges.last.id,
      );
      badges.isEmpty
          ? emit(state.copyWith(hasReachedMaxBadges: true))
          : emit(
              state.copyWith(
                badgeStatus: BadgesStatus.success,
                userBadges: List.of(state.userBadges)..addAll(badges),
                hasReachedMaxBadges: false,
              ),
            );
    } catch (e, s) {
      logger.error(
        'fetchMoreBadges error',
        error: e,
        stackTrace: s,
      );
      // emit(state.copyWith(badgeStatus: BadgesStatus.failure));
    } finally {
      await trace.stop();
    }
  }

  Future<void> fetchMoreBookings() async {
    if (state.hasReachedMaxBookings) return;

    final trace = logger.createTrace('fetchMoreBookings');
    await trace.start();
    try {
      if (state.bookingsStatus == BookingsStatus.initial) {
        await initBookings();
      }

      final bookingsRequestee = await databaseRepository.getBookingsByRequestee(
        visitedUser.id,
        limit: 10,
        lastBookingRequestId: state.userBookings
            .where((e) => e.requesteeId == state.visitedUser.id)
            .last
            .id,
      );
      final bookingsRequester = await databaseRepository.getBookingsByRequester(
        visitedUser.id,
        limit: 10,
        lastBookingRequestId: state.userBookings
            .where((e) => e.requesterId == state.visitedUser.id)
            .last
            .id,
      );
      (bookingsRequestee.isEmpty && bookingsRequester.isEmpty)
          ? emit(state.copyWith(hasReachedMaxBookings: true))
          : emit(
              state.copyWith(
                bookingsStatus: BookingsStatus.success,
                userBookings: List.of(state.userBookings)
                  ..addAll(bookingsRequestee)
                  ..addAll(bookingsRequester),
                hasReachedMaxBookings: false,
              ),
            );
    } catch (e, s) {
      logger.error(
        'fetchMoreBookings error',
        error: e,
        stackTrace: s,
      );
      // emit(state.copyWith(bookingsStatus: BookingsStatus.failure));
    } finally {
      await trace.stop();
    }
  }

  void toggleFollow(String currentUserId, String visitedUserId) {
    if (state.isFollowing) {
      unfollow(currentUserId, visitedUserId);
    } else {
      follow(currentUserId, visitedUserId);
    }
  }

  Future<void> follow(String currentUserId, String visitedUserId) async {
    try {
      logger.debug('follow $visitedUserId');
      emit(
        state.copyWith(
          followerCount: state.followerCount + 1,
          isFollowing: true,
        ),
      );
      await databaseRepository.followUser(currentUserId, visitedUserId);
    } catch (e, s) {
      logger.error('follow error', error: e, stackTrace: s);
    }
  }

  Future<void> unfollow(String currentUserId, String visitedUserId) async {
    try {
      logger.debug('unfollow $visitedUserId');
      emit(
        state.copyWith(
          followerCount: state.followerCount - 1,
          isFollowing: false,
        ),
      );
      await databaseRepository.unfollowUser(currentUserId, visitedUserId);
    } catch (e, s) {
      logger.error('unfollow error', error: e, stackTrace: s);
    }
  }

  Future<void> block() async {
    try {
      logger.debug('block ${state.visitedUser.id}');
      emit(state.copyWith(isBlocked: true));
      await databaseRepository.blockUser(
        currentUserId: state.currentUser.id,
        blockedUserId: state.visitedUser.id,
      );
    } catch (e, s) {
      logger.error('block error', error: e, stackTrace: s);
    }
  }

  Future<void> unblock() async {
    try {
      logger.debug('unblock ${state.visitedUser.id}');
      emit(state.copyWith(isBlocked: false));
      await databaseRepository.unblockUser(
        currentUserId: state.currentUser.id,
        blockedUserId: state.visitedUser.id,
      );
    } catch (e, s) {
      logger.error('unblock error', error: e, stackTrace: s);
    }
  }

  Future<void> loadIsBlocked() async {
    try {
      final isBlocked = await databaseRepository.isBlocked(
        currentUserId: state.currentUser.id,
        blockedUserId: state.visitedUser.id,
      );

      emit(
        state.copyWith(
          isBlocked: isBlocked,
        ),
      );
    } catch (e, s) {
      logger.error('loadIsBlocked error', error: e, stackTrace: s);
    }
  }

  Future<void> loadIsFollowing(
    String currentUserId,
    String visitedUserId,
  ) async {
    try {
      final isFollowing = await databaseRepository.isFollowingUser(
        currentUserId,
        visitedUserId,
      );

      emit(
        state.copyWith(
          isFollowing: isFollowing,
        ),
      );
    } catch (e, s) {
      logger.error('loadIsFollowing error', error: e, stackTrace: s);
    }
  }

  Future<void> loadIsVerified(String visitedUserId) async {
    try {
      final isVerified = await databaseRepository.isVerified(visitedUserId);

      emit(
        state.copyWith(
          isVerified: isVerified,
        ),
      );
    } catch (e, s) {
      logger.error('loadIsVerified error', error: e, stackTrace: s);
    }
  }

  void deleteLoop(Loop loop) {
    logger.debug('deleteLoop ${loop.id}');
    final newLoops = List<Loop>.of(state.userLoops)
      ..removeWhere((element) => element.id == loop.id);
    emit(state.copyWith(userLoops: newLoops));
  }

  @override
  Future<void> close() async {
    await loopListener?.cancel();
    await badgeListener?.cancel();
    await bookingListener?.cancel();
    await super.close();
  }
}
