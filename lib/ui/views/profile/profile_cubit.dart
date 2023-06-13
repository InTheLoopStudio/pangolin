import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intheloopapp/app_logger.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/badge.dart' as badge;
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

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
  StreamSubscription<badge.Badge>? badgeListener;

  bool onNotification(
    ScrollController scrollController,
    double expandedBarHeight,
    double collapsedBarHeight,
  ) {
    emit(
      state.copyWith(
        isCollapsed: scrollController.hasClients &&
            scrollController.offset > (expandedBarHeight - collapsedBarHeight),
      ),
    );

    /// When the app bar is collapsed and the feedback
    /// hasn't been added previously will invoke
    /// the `mediumImpact()` method, otherwise will
    /// reset the didAddFeedback value.
    ///
    if (state.isCollapsed && !state.didAddFeedback) {
      HapticFeedback.mediumImpact();
      emit(state.copyWith(didAddFeedback: true));
    } else if (!state.isCollapsed) {
      emit(state.copyWith(didAddFeedback: false));
    }
    return false;
  }

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
          .listen((badge.Badge event) {
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

  @override
  Future<void> close() async {
    await badgeListener?.cancel();
    await super.close();
  }
}
