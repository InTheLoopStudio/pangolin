import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/ui/views/activity/activity_view.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view.dart';
import 'package:intheloopapp/ui/views/likes/likes_view.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_view.dart';
import 'package:intheloopapp/ui/views/profile/profile_view.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc({required this.navigationKey}) : super(NavigationState());

  final GlobalKey<NavigatorState> navigationKey;

  @override
  Stream<NavigationState> mapEventToState(
    NavigationEvent event,
  ) async* {
    if (event is ChangeTab) {
      yield* _mapChangeTabToState(event.selectedTab);
    } else if (event is PushLoop) {
      yield* _mapPushLoopToState(
          event.loop, event.showComments, event.autoPlay);
    } else if (event is PushProfile) {
      yield* _mapPushProfileToState(event.userId);
    } else if (event is PushActivity) {
      yield* _mapPushActivityToState();
    } else if (event is PushOnboarding) {
      yield* _mapPushOnboardingToState();
    } else if (event is PushLikes) {
      yield* _mapPushLikesToState(event.loop);
    } else if (event is Pop) {
      yield* _mapPopToState();
    }
  }

  Stream<NavigationState> _mapChangeTabToState(int selectedTab) async* {
    yield state.copyWith(selectedTab: selectedTab);
  }

  Stream<NavigationState> _mapPushActivityToState() async* {
    navigationKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => Material(
          child: ActivityView(),
        ),
      ),
    );
    yield state;
  }

  Stream<NavigationState> _mapPushLoopToState(
    Loop loop,
    bool showComments,
    bool autoPlay,
  ) async* {
    navigationKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => Material(
          child: LoopView(
            loop: loop,
            showComments: showComments,
            autoPlay: autoPlay,
          ),
        ),
      ),
    );
    yield state;
  }

  Stream<NavigationState> _mapPushProfileToState(String userId) async* {
    navigationKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => ProfileView(visitedUserId: userId),
      ),
    );
    yield state;
  }

  Stream<NavigationState> _mapPushOnboardingToState() async* {
    navigationKey.currentState?.push(
      MaterialPageRoute(builder: (context) => OnboardingView()),
    );

    yield state;
  }

  Stream<NavigationState> _mapPushLikesToState(Loop loop) async* {
    navigationKey.currentState?.push(
      MaterialPageRoute(builder: (context) => LikesView(loop: loop)),
    );

    yield state;
  }

  Stream<NavigationState> _mapPopToState() async* {
    navigationKey.currentState?.pop();

    yield state;
  }
}
