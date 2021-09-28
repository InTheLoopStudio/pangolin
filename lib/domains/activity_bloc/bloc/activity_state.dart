part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  const ActivityState({this.activities = const []});

  final List<Activity> activities;

  @override
  List<Object> get props => [activities];
}

class ActivityInitial extends ActivityState {
  const ActivityInitial() : super(activities: const []);
}

class ActivitySuccess extends ActivityState {
  const ActivitySuccess({activities = const []})
      : super(activities: activities);
}

class ActivityEnd extends ActivityState {
  const ActivityEnd({activities = const []}) : super(activities: activities);
}

class ActivityFailure extends ActivityState {
  ActivityFailure() : super(activities: const []);
}
