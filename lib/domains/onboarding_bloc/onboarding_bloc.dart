import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required this.databaseRepository,
  }) : super(Unonboarded()) {
    on<OnboardingCheck>((event, emit) async {
      final userId = event.userId;

      final user = await databaseRepository.getUserById(userId);
      if (user == null) {
        emit(Onboarding());
      } else {
        emit(Onboarded(user));
      }
    });
    on<FinishOnboarding>((event, emit) => emit(Onboarded(event.user)));
    on<UpdateOnboardedUser>((event, emit) async {
      // Update user in db
      await databaseRepository.updateUserData(event.user);

      // emit new user in state
      emit(Onboarded(event.user));
    });
  }

  final DatabaseRepository databaseRepository;
}
