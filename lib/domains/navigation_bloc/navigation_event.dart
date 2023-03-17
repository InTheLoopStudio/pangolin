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

class PushProfile extends NavigationEvent {
  const PushProfile(this.userId);

  final String userId;

  @override
  String toString() => 'PushProfile { userId : $userId }';

  @override
  List<Object> get props => [userId];
}

class PushLocationForm extends NavigationEvent {
  const PushLocationForm({
    required this.initialPlaceId,
    required this.initialPlace,
    required this.onSelected,
  });

  final String initialPlaceId;
  final Place initialPlace;
  final void Function(Place?, String) onSelected;

  @override
  String toString() => 'PushLocationForm { initialPlaceId : $initialPlaceId }';

  @override
  List<Object> get props => [
        initialPlaceId,
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

class PushPost extends NavigationEvent {
  const PushPost(
    this.post,
  );

  final Post post;

  @override
  String toString() => '''PushPost { post: $post }''';

  @override
  List<Object> get props => [post];
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

class PushCreatePost extends NavigationEvent {
  const PushCreatePost();

  @override
  String toString() => 'PushCreatePost { }';

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
  String toString() => '''PushStreamChannel { loop: $channel }''';

  @override
  List<Object> get props => [channel];
}
