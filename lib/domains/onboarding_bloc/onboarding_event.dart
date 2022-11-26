part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
}

class OnboardingCheck extends OnboardingEvent {
  const OnboardingCheck({required this.userId});

  final String userId;

  @override
  String toString() => 'OnboardingCheck { id: $userId }';

  @override
  List<Object> get props => [userId];
}

class FinishOnboarding extends OnboardingEvent {
  const FinishOnboarding({required this.user});

  final UserModel user;

  @override
  String toString() => 'FinishOnboarded { email: ${user.email} }';

  @override
  List<Object> get props => [];
}
