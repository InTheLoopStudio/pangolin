part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();
}

class Pop extends NavigationEvent {
  const Pop();

  @override
  String toString() => 'Pop { }';

  @override
  List<Object> get props => [];
}

class PushPhotoView extends NavigationEvent {
  const PushPhotoView({
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  String toString() => 'PushPhotoView { imageUrl: $imageUrl }';

  @override
  List<Object> get props => [imageUrl];
}

class PushProfile extends NavigationEvent {
  const PushProfile(this.userId);

  final String userId;

  @override
  String toString() => 'PushProfile { userId : $userId }';

  @override
  List<Object> get props => [userId];
}

class PushSettings extends NavigationEvent {
  const PushSettings();

  @override
  String toString() => 'PushSettings { }';

  @override
  List<Object> get props => [];
}

class PushLocationForm extends NavigationEvent {
  const PushLocationForm({
    required this.initialPlace,
    required this.onSelected,
  });

  final Place? initialPlace;
  final void Function(Place?, String) onSelected;

  @override
  String toString() => 'PushLocationForm { initialPlace: $initialPlace }';

  @override
  List<Object?> get props => [
        initialPlace,
        onSelected,
      ];
}

class PushActivity extends NavigationEvent {
  const PushActivity();

  @override
  String toString() => 'PushActivity { }';

  @override
  List<Object> get props => [];
}

class PushForgotPassword extends NavigationEvent {
  const PushForgotPassword();

  @override
  String toString() => 'PushForgotPassword { }';

  @override
  List<Object> get props => [];
}

class PushSignUp extends NavigationEvent {
  const PushSignUp();

  @override
  String toString() => 'PushSignUp { }';

  @override
  List<Object> get props => [];
}

class PushLoop extends NavigationEvent {
  const PushLoop(
    this.loop, {
    this.showComments = false,
    this.autoPlay = true,
  });

  final Loop loop;
  final bool showComments;
  final bool autoPlay;

  @override
  String toString() =>
      '''PushLoop { loop: $loop, showComments: $showComments, autoPlay: $autoPlay }''';

  @override
  List<Object> get props => [loop];
}

class PushBadge extends NavigationEvent {
  const PushBadge(this.badge);

  final badge_model.Badge badge;

  @override
  String toString() => 'PushProfile { badge: $badge}';

  @override
  List<Object> get props => [];
}

class PushOnboarding extends NavigationEvent {
  const PushOnboarding();

  @override
  String toString() => 'PushOnboarding { }';

  @override
  List<Object> get props => [];
}

class PushLikes extends NavigationEvent {
  const PushLikes(this.loop);

  final Loop loop;

  @override
  String toString() => 'PushLikes { }';

  @override
  List<Object> get props => [loop];
}

class PushCreateLoop extends NavigationEvent {
  const PushCreateLoop();

  @override
  String toString() => 'PushCreateLoop { }';

  @override
  List<Object> get props => [];
}

class ChangeTab extends NavigationEvent {
  const ChangeTab({required this.selectedTab});

  final int selectedTab;

  @override
  String toString() => 'ChangeTab { selectedTab: $selectedTab }';

  @override
  List<Object> get props => [selectedTab];
}

class PushStreamChannel extends NavigationEvent {
  const PushStreamChannel(
    this.channel,
  );

  final Channel channel;

  @override
  String toString() => '''PushStreamChannel { channel: $channel }''';

  @override
  List<Object> get props => [channel];
}

class PushCreateBooking extends NavigationEvent {
  const PushCreateBooking({
    required this.service,
    required this.requesteeStripeConnectedAccountId,
  });

  final Service service;
  final String requesteeStripeConnectedAccountId;

  @override
  String toString() =>
      '''PushCreateBooking { service: $service, requesteeStripeConnectedAccountId: $requesteeStripeConnectedAccountId }''';

  @override
  List<Object> get props => [
        service,
        requesteeStripeConnectedAccountId,
      ];
}

class PushBooking extends NavigationEvent {
  const PushBooking(this.booking);

  final Booking booking;

  @override
  String toString() => '''PushBooking { booking: $booking }''';

  @override
  List<Object> get props => [booking];
}

class PushAdvancedSearch extends NavigationEvent {
  const PushAdvancedSearch();

  @override
  String toString() => 'PushAdvancedSearch { }';

  @override
  List<Object> get props => [];
}

class PushServiceSelection extends NavigationEvent {
  const PushServiceSelection({
    required this.userId,
    required this.requesteeStripeConnectedAccountId,
  });

  final String userId;
  final String requesteeStripeConnectedAccountId;

  @override
  String toString() =>
      'PushServiceSelection { userId: $userId, requesteeStripeConnectedAccountId: $requesteeStripeConnectedAccountId }';

  @override
  List<Object> get props => [
    userId,
    requesteeStripeConnectedAccountId,
  ];
}
