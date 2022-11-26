part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();
}

class Unonboarded extends OnboardingState {
  @override
  List<Object> get props => [];
}

class Onboarding extends OnboardingState {
  @override
  List<Object> get props => [];
}

class Onboarded extends OnboardingState {
  const Onboarded(this.currentUser) : super();
  final UserModel currentUser;

  @override
  String toString() => 'Onboarded { email: ${currentUser.email} }';

  @override
  List<Object> get props => [currentUser];
}
