part of 'activity_bloc.dart';

/// The state for activities aka notifications
abstract class ActivityState extends Equatable {
  /// Initially, activies is an empty list
  const ActivityState({this.activities = const []});

  /// The activities or notifications on the app
  final List<Activity> activities;

  @override
  List<Object> get props => [activities];
}

/// The initial state of activities
class ActivityInitial extends ActivityState {
  /// The initial state of activities is to have no activities
  /// i.e. an empty list
  const ActivityInitial() : super(activities: const []);
}

/// The state after successfully pulling new activities
class ActivitySuccess extends ActivityState {
  /// By default, the activity list is empty
  const ActivitySuccess({super.activities});
}

/// The state when reaching the last page in paginated activities
class ActivityEnd extends ActivityState {
  /// By default, the activity list is empty
  const ActivityEnd({super.activities});
}

/// The state when there is an error pulling new activities
class ActivityFailure extends ActivityState {
  /// By default, the activity list is empty
  const ActivityFailure() : super(activities: const []);
}
