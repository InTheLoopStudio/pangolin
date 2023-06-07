import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/badge.dart' as badge_model;
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/activity/activity_view.dart';
import 'package:intheloopapp/ui/views/advanced_search/advanced_search_view.dart';
import 'package:intheloopapp/ui/views/badge/badge_view.dart';
import 'package:intheloopapp/ui/views/bookings/user_bookings_feed.dart';
import 'package:intheloopapp/ui/views/common/booking_view/booking_view.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view.dart';
import 'package:intheloopapp/ui/views/create_booking/create_booking_view.dart';
import 'package:intheloopapp/ui/views/create_loop/create_loop_view.dart';
import 'package:intheloopapp/ui/views/create_service/create_service_view.dart';
import 'package:intheloopapp/ui/views/likes/likes_view.dart';
import 'package:intheloopapp/ui/views/login/forgot_password_view.dart';
import 'package:intheloopapp/ui/views/login/signup_view.dart';
import 'package:intheloopapp/ui/views/loop_feed/loop_feed_view.dart';
import 'package:intheloopapp/ui/views/loop_feed/user_loop_feed.dart';
import 'package:intheloopapp/ui/views/messaging/channel_view.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_view.dart';
import 'package:intheloopapp/ui/views/opportunities/interested_view.dart';
import 'package:intheloopapp/ui/views/profile/new_profile_view.dart';
import 'package:intheloopapp/ui/views/profile/profile_view.dart';
import 'package:intheloopapp/ui/views/settings/settings_view.dart';
import 'package:intheloopapp/ui/widgets/common/forms/location_form/location_form_view.dart';
import 'package:intheloopapp/ui/widgets/profile_view/service_selection_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  /// build the bloc and defines event handlers
  NavigationBloc({
    required this.database,
    required this.navigationKey,
  }) : super(const NavigationState()) {
    on<ChangeTab>((event, emit) {
      emit(state.copyWith(selectedTab: event.selectedTab));
    });
    on<PushLoop>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<LoopView>(
          settings: RouteSettings(name: '/loop/${event.loop.id}'),
          builder: (context) => Material(
            child: LoopView(
              loop: event.loop,
              loopUser: event.loopUser,
            ),
          ),
        ),
      );
      emit(state);
    });
    on<PushBadge>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<BadgeView>(
          settings: RouteSettings(name: '/badge/${event.badge.id}'),
          builder: (context) => Material(
            child: BadgeView(
              badge: event.badge,
            ),
          ),
        ),
      );
      emit(state);
    });
    on<PushProfile>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<ProfileView>(
          settings: const RouteSettings(name: '/profile'),
          builder: (context) => NewProfileView(
            visitedUserId: event.userId,
            visitedUser: event.user,
          ),
        ),
      );
      emit(state);
    });
    on<PushLoops>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<LoopFeedView>(
          settings: RouteSettings(name: '/loops/${event.userId}'),
          builder: (context) => LoopFeedView(
            nested: false,
            header: true,
            sourceFunction: (
              String userId, {
              String? lastLoopId,
              int limit = 20,
              bool ignoreCache = false,
            }) async {
              final result = await database.getUserLoops(
                event.userId,
                limit: limit,
                lastLoopId: lastLoopId,
              );
              return result;
            },
            sourceStream: (
              String userId, {
              int limit = 20,
              bool ignoreCache = false,
            }) async* {
              yield* database.userLoopsObserver(event.userId, limit: limit);
            },
            feedKey: 'user_loops',
            scrollController: ScrollController(),
          ),
        ),
      );
      emit(state);
    });
    on<PushOpportunities>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<LoopFeedView>(
          settings: RouteSettings(name: '/opportunities/${event.userId}'),
          builder: (context) => LoopFeedView(
            nested: false,
            header: true,
            sourceFunction: (
              String userId, {
              String? lastLoopId,
              int limit = 20,
              bool ignoreCache = false,
            }) async {
              final result = await database.getUserOpportunities(
                event.userId,
                limit: limit,
                lastLoopId: lastLoopId,
              );
              return result;
            },
            sourceStream: (
              String userId, {
              int limit = 20,
              bool ignoreCache = false,
            }) async* {
              yield* database.userOpportunitiesObserver(
                event.userId,
                limit: limit,
              );
            },
            feedKey: 'user_opportunities',
            scrollController: ScrollController(),
          ),
        ),
      );
      emit(state);
    });
    on<PushBookings>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<UserBookingsFeed>(
          settings: RouteSettings(name: '/bookings/${event.userId}'),
          builder: (context) => UserBookingsFeed(userId: event.userId),
        ),
      );
      emit(state);
    });
    on<PushSettings>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<ProfileView>(
          builder: (context) => const SettingsView(),
        ),
      );
      emit(state);
    });
    on<PushActivity>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<ActivityView>(
          settings: const RouteSettings(name: '/activities'),
          builder: (context) => const ActivityView(),
        ),
      );
      emit(state);
    });
    on<PushForgotPassword>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<ForgotPasswordView>(
          settings: const RouteSettings(name: '/forgot-password'),
          builder: (context) => const ForgotPasswordView(),
        ),
      );
      emit(state);
    });
    on<PushSignUp>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<SignUpView>(
          settings: const RouteSettings(name: '/sign-up'),
          builder: (context) => const SignUpView(),
        ),
      );
      emit(state);
    });
    on<PushOnboarding>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<OnboardingView>(
          settings: const RouteSettings(name: '/onboarding'),
          builder: (context) => const OnboardingView(),
        ),
      );

      emit(state);
    });
    on<PushLikes>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<PushLikes>(
          settings: RouteSettings(name: '/likes/${event.loop.id}'),
          builder: (context) => LikesView(loop: event.loop),
        ),
      );

      emit(state);
    });
    on<PushCreateLoop>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<CreateLoopView>(
          settings: const RouteSettings(name: '/create-loop'),
          builder: (context) => const CreateLoopView(),
        ),
      );

      emit(state);
    });
    on<PushStreamChannel>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<StreamChannel>(
          settings: RouteSettings(name: '/channel/${event.channel.id}'),
          builder: (context) => StreamChannel(
            channel: event.channel,
            child: const ChannelView(),
          ),
        ),
      );

      emit(state);
    });
    on<PushCreateBooking>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<CreateBookingView>(
          settings: const RouteSettings(name: '/create-booking'),
          builder: (context) => CreateBookingView(
            service: event.service,
            requesteeStripeConnectedAccountId:
                event.requesteeStripeConnectedAccountId,
          ),
        ),
      );

      emit(state);
    });
    on<PushBooking>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<BookingView>(
          settings: RouteSettings(name: '/booking/${event.booking.id}'),
          builder: (context) => BookingView(
            booking: event.booking,
          ),
        ),
      );

      emit(state);
    });
    on<PushAdvancedSearch>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<AdvancedSearchView>(
          settings: const RouteSettings(name: '/advanced-search'),
          builder: (context) => const AdvancedSearchView(),
        ),
      );

      emit(state);
    });
    on<PushServiceSelection>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<ServiceSelectionView>(
          settings: const RouteSettings(name: '/service-selection'),
          builder: (context) => ServiceSelectionView(
            userId: event.userId,
            requesteeStripeConnectedAccountId:
                event.requesteeStripeConnectedAccountId,
          ),
        ),
      );

      emit(state);
    });
    on<PushCreateService>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<CreateServiceView>(
          settings: const RouteSettings(name: '/create-service'),
          builder: (context) => CreateServiceView(
            onCreated: event.onCreated,
          ),
        ),
      );

      emit(state);
    });
    on<PushLocationForm>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<LocationFormView>(
          settings: const RouteSettings(name: '/location-form'),
          builder: (context) => LocationFormView(
            initialPlace: event.initialPlace,
            onSelected: event.onSelected,
          ),
        ),
      );

      emit(state);
    });
    on<PushInterestedView>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<InterestedView>(
          settings: RouteSettings(name: '/interested/${event.loop.id}'),
          builder: (context) => InterestedView(
            loop: event.loop,
          ),
        ),
      );

      emit(state);
    });
    on<Pop>((event, emit) {
      navigationKey.currentState?.pop();

      emit(state);
    });
  }

  final DatabaseRepository database;
  final GlobalKey<NavigatorState> navigationKey;
}
