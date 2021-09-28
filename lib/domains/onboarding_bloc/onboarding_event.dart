part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
}

class OnboardingCheck extends OnboardingEvent {
  const OnboardingCheck({required this.user});

  final UserModel user;

  @override
  String toString() => 'OnboardingCheck { email: ${user.email} }';

  @override
  List<Object> get props => [user];
}

class FinishOnboarding extends OnboardingEvent {
  @override
  List<Object> get props => [];
}
