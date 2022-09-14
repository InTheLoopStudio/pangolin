import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingInitial()) {
    on<OnboardingCheck>((event, emit) {
      UserModel user = event.user; 
      if (user.onboarded == false) {
        emit(Onboarding());
      } else {
        emit(Onboarded());
      }
    });
    on<FinishOnboarding>((event, emit) => emit(Onboarded()));
  }
}
