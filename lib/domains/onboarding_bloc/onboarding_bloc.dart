import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required this.databaseRepository,
  }) : super(Unonboarded()) {
    on<OnboardingCheck>((event, emit) async {
      try {
        final userId = event.userId;

        final user = await databaseRepository.getUserById(userId);
        if (user == null) {
          emit(Onboarding());
        } else {
          emit(Onboarded(user));
        }
      } catch (e, s) {
        await FirebaseCrashlytics.instance.recordError(e, s);
        emit(Onboarding());
      }
    });
    on<FinishOnboarding>((event, emit) {
      FirebaseCrashlytics.instance.setUserIdentifier(event.user.id);
      emit(Onboarded(event.user));
    });
    on<UpdateOnboardedUser>((event, emit) async {
      // emit new user in state
      emit(Onboarded(event.user));

      // Update user in db
      await databaseRepository.updateUserData(event.user);
    });
  }

  final DatabaseRepository databaseRepository;
}
