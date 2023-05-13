part of 'activity_bloc.dart';

/// The state for activities aka notifications
sealed class ActivityState extends Equatable {
  /// Initially, activies is an empty list
  const ActivityState({this.activities = const []});

  /// The activities or notifications on the app
  final List<Activity> activities;

  bool get unreadActivities => activities.any((elem) => !elem.markedRead);
  int get unreadActivitiesCount =>
      activities.where((elem) => !elem.markedRead).length;

  @override
  List<Object> get props => [activities];
}

/// The initial state of activities
final class ActivityInitial extends ActivityState {
  /// The initial state of activities is to have no activities
  /// i.e. an empty list
  const ActivityInitial() : super(activities: const []);
}

/// The state after successfully pulling new activities
final class ActivitySuccess extends ActivityState {
  /// By default, the activity list is empty
  const ActivitySuccess({super.activities});
}

/// The state when reaching the last page in paginated activities
final class ActivityEnd extends ActivityState {
  /// By default, the activity list is empty
  const ActivityEnd({super.activities});
}

/// The state when there is an error pulling new activities
final class ActivityFailure extends ActivityState {
  /// By default, the activity list is empty
  const ActivityFailure() : super(activities: const []);
}
