import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingInitial());

  @override
  Stream<OnboardingState> mapEventToState(
    OnboardingEvent event,
  ) async* {
    if (event is OnboardingCheck) {
      yield* _mapOnboardingCheckToState(event.user);
    } else if (event is FinishOnboarding) {
      yield* _mapFinishOnboardingToState();
    }
  }
}

Stream<OnboardingState> _mapOnboardingCheckToState(UserModel user) async* {
  if (user.onboarded == null || user.onboarded == false) {
    yield Onboarding();
  } else {
    yield Onboarded();
  }
}

Stream<OnboardingState> _mapFinishOnboardingToState() async* {
  yield Onboarded();
}
