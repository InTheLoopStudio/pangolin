import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc({
    required this.databaseRepository,
    required this.authenticationBloc,
  }) : super(const ActivityInitial()) {
    currentUser = (authenticationBloc.state as Authenticated).currentUser;
    on<AddActivityEvent>(
      (event, emit) => emit(
        ActivitySuccess(
          activities: List.of(state.activities)..add(event.activity),
        ),
      ),
    );
    on<InitListenerEvent>(
      (event, emit) => _mapInitListenerEventToState(emit),
    );
    on<FetchActivitiesEvent>(
      (event, emit) => _mapFetchActivitiesEventToState(emit),
    );
    on<MarkActivityAsReadEvent>(
      (event, emit) => _mapMarkActivityAsReadEventToState(emit, event.activity),
    );
  }
  DatabaseRepository databaseRepository;
  AuthenticationBloc authenticationBloc;
  late UserModel currentUser;

  Future<void> _mapInitListenerEventToState(
    Emitter<ActivityState> emit,
  ) async {
    emit(const ActivityInitial());

    final activitiesAvailable = (await databaseRepository.getActivities(
      currentUser.id,
      limit: 1,
    ))
        .isNotEmpty;

    if (!activitiesAvailable) {
      emit(ActivitySuccess());
    }

    final activityStream =
        databaseRepository.activitiesObserver(currentUser.id);

    await for (final activity in activityStream) {
      emit(
        ActivitySuccess(
          activities: List.of(state.activities)..add(activity),
        ),
      );
    }
  }

  Future<void> _mapFetchActivitiesEventToState(
    Emitter<ActivityState> emit,
  ) async {
    if (state is ActivityEnd) return;

    try {
      if (state is ActivityInitial) return;

      final activities = await databaseRepository.getActivities(
        currentUser.id,
        limit: 10,
        lastActivityId: state.activities.last.id,
      );

      activities.isEmpty
          ? emit(ActivityEnd(activities: state.activities))
          : emit(
              ActivitySuccess(
                activities: List.of(state.activities)..addAll(activities),
              ),
            );
    } on Exception {
      emit(const ActivityFailure());
    }
  }

  Future<void> _mapMarkActivityAsReadEventToState(
    Emitter<ActivityState> emit,
    Activity activity,
  ) async {
    final idx = state.activities.indexOf(activity);
    final updatedActivity = activity.copyWith(markedRead: true);

    if (idx != -1) {
      emit(
        ActivitySuccess(
          activities: state.activities..[idx] = updatedActivity,
        ),
      );
    }

    await databaseRepository.markActivityAsRead(updatedActivity);

    return;
  }
}
