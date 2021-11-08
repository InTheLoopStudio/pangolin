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
  DatabaseRepository databaseRepository;
  AuthenticationBloc authenticationBloc;
  StreamSubscription? activityListener;
  late UserModel currentUser;

  ActivityBloc({
    required this.databaseRepository,
    required this.authenticationBloc,
  }) : super(ActivityInitial()) {
    currentUser = (authenticationBloc.state as Authenticated).currentUser;
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

  Future<void> _mapInitListenerEventToState(
    Emitter<ActivityState> emit,
  ) async {
    activityListener?.cancel();
    emit(ActivityInitial());

    bool activitiesAvailable = 0 !=
        (await databaseRepository.getActivities(
          currentUser.id,
          limit: 1,
        ))
            .length;

    if (!activitiesAvailable) {
      emit(ActivitySuccess(activities: const []));
      return;
    }

    activityListener = databaseRepository
        .activitiesObserver(currentUser.id, limit: 20)
        .listen((Activity event) {
      // print('Activity { ${event.id} : ${event.fromUserId} } ');
      emit(ActivitySuccess(
        activities: List.of(state.activities)..add(event),
      ));
    });
  }

  Future<void> _mapFetchActivitiesEventToState(
    Emitter<ActivityState> emit,
  ) async {
    if (state is ActivityEnd) return;

    try {
      if (state is ActivityInitial) return;

      List<Activity> activities = await databaseRepository.getActivities(
        currentUser.id,
        limit: 10,
        lastActivityId: state.activities.last.id,
      );

      activities.isEmpty
          ? emit(ActivityEnd(activities: state.activities))
          : emit(ActivitySuccess(
              activities: List.of(state.activities)..addAll(activities),
            ));
    } on Exception {
      emit(ActivityFailure());
    }
  }

  Future<void> _mapMarkActivityAsReadEventToState(
    Emitter<ActivityState> emit,
    Activity activity,
  ) async {
    int idx = state.activities.indexOf(activity);
    Activity updatedActivity = activity.copyWith(markedRead: true);

    if (idx != -1) {
      emit(ActivitySuccess(
        activities: state.activities..[idx] = updatedActivity,
      ));
    }

    await databaseRepository.markActivityAsRead(updatedActivity);

    return;
  }

  @override
  Future<void> close() async {
    activityListener?.cancel();
    super.close();
  }
}
