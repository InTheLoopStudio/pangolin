part of 'onboarding_bloc.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();
}

final class Unonboarded extends OnboardingState {
  @override
  List<Object> get props => [];
}

final class Onboarding extends OnboardingState {
  @override
  List<Object> get props => [];
}

final class Onboarded extends OnboardingState {
  const Onboarded(this.currentUser) : super();
  final UserModel currentUser;

  @override
  String toString() => 'Onboarded { email: ${currentUser.email} }';

  @override
  List<Object> get props => [currentUser];
}
