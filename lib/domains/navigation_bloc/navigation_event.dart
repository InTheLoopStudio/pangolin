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
  PushProfile(this.userId);

  final String userId;

  @override
  String toString() => 'PushProfile { userId : $userId }';

  @override
  List<Object> get props => [userId];
}

class PushActivity extends NavigationEvent {
  PushActivity();

  @override
  String toString() => 'PushActivity { }';

  @override
  List<Object> get props => [];
}

class PushLoop extends NavigationEvent {
  PushLoop(this.loop, {this.showComments = false, this.autoPlay = true});

  final Loop loop;
  final bool showComments;
  final bool autoPlay;

  @override
  String toString() =>
      'PushProfile { loop: ${loop.toString()}, showComments: $showComments, autoPlay: $autoPlay }';

  @override
  List<Object> get props => [];
}

class PushOnboarding extends NavigationEvent {
  PushOnboarding();

  @override
  String toString() => 'PushOnboarding { }';

  @override
  List<Object> get props => [];
}

class PushLikes extends NavigationEvent {
  PushLikes(this.loop);

  final Loop loop;

  @override
  String toString() => 'PushLikes { }';

  @override
  List<Object> get props => [loop];
}

class ChangeTab extends NavigationEvent {
  ChangeTab({required this.selectedTab});

  final int selectedTab;

  @override
  String toString() => 'ChangeTab { selectedTab: $selectedTab }';

  @override
  List<Object> get props => [selectedTab];
}
