import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/domains/models/badge.dart' as badge_model;
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/post.dart';
import 'package:intheloopapp/ui/views/activity/activity_view.dart';
import 'package:intheloopapp/ui/views/badge/badge_view.dart';
import 'package:intheloopapp/ui/views/common/booking_view/booking_view.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_new.dart';
import 'package:intheloopapp/ui/views/common/post_view/post_view.dart';
import 'package:intheloopapp/ui/views/create_booking/create_booking_view.dart';
import 'package:intheloopapp/ui/views/create_loop/create_loop_view.dart';
import 'package:intheloopapp/ui/views/likes/likes_view.dart';
import 'package:intheloopapp/ui/views/login/forgot_password_view.dart';
import 'package:intheloopapp/ui/views/login/signup_view.dart';
import 'package:intheloopapp/ui/views/messaging/channel_view.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_view.dart';
import 'package:intheloopapp/ui/views/profile/profile_view.dart';
import 'package:intheloopapp/ui/views/settings/settings_view.dart';
import 'package:intheloopapp/ui/widgets/common/forms/location_form/location_form_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  /// build the bloc and defines event handlers
  NavigationBloc({required this.navigationKey})
      : super(const NavigationState()) {
    on<ChangeTab>((event, emit) {
      emit(state.copyWith(selectedTab: event.selectedTab));
    });
    on<PushLoop>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<LoopViewNew>(
          builder: (context) => Material(
            child: LoopViewNew(
              loop: event.loop,
            ),
          ),
        ),
      );
      emit(state);
    });
    on<PushPost>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<PostView>(
          builder: (context) => Material(
            child: PostView(
              post: event.post,
            ),
          ),
        ),
      );
      emit(state);
    });
    on<PushBadge>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<BadgeView>(
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
          builder: (context) => ProfileView(visitedUserId: event.userId),
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
          builder: (context) => const Material(
            child: ActivityView(),
          ),
        ),
      );
      emit(state);
    });
    on<PushForgotPassword>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<ForgotPasswordView>(
          builder: (context) => const Material(
            child: ForgotPasswordView(),
          ),
        ),
      );
      emit(state);
    });
    on<PushSignUp>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<SignUpView>(
          builder: (context) => const Material(
            child: SignUpView(),
          ),
        ),
      );
      emit(state);
    });
    on<PushOnboarding>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<OnboardingView>(
          builder: (context) => const OnboardingView(),
        ),
      );

      emit(state);
    });
    on<PushLikes>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<PushLikes>(
          builder: (context) => LikesView(loop: event.loop),
        ),
      );

      emit(state);
    });
    on<PushCreateLoop>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<CreateLoopView>(
          builder: (context) => const CreateLoopView(),
        ),
      );

      emit(state);
    });
    on<PushStreamChannel>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<StreamChannel>(
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
          builder: (context) => CreateBookingView(
            requesteeId: event.requesteeId,
            requesteeStripeConnectedAccountId:
                event.requesteeStripeConnectedAccountId,
            requesteeBookingRate: event.requesteeBookingRate,
          ),
        ),
      );

      emit(state);
    });
    on<PushBooking>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<BookingView>(
          builder: (context) => BookingView(
            booking: event.booking,
          ),
        ),
      );

      emit(state);
    });
    on<PushLocationForm>((event, emit) {
      navigationKey.currentState?.push(
        MaterialPageRoute<LocationFormView>(
          builder: (context) => LocationFormView(
            initialPlaceId: event.initialPlaceId,
            initialPlace: event.initialPlace,
            onSelected: event.onSelected,
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

  final GlobalKey<NavigatorState> navigationKey;
}
