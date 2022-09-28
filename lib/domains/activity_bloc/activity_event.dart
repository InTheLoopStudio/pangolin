part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object> get props => [];
}

class InitListenerEvent extends ActivityEvent {}

class FetchActivitiesEvent extends ActivityEvent {}

class AddActivityEvent extends ActivityEvent {
  const AddActivityEvent({
    required this.activity,
  }) : super();

  final Activity activity;

  @override
  List<Object> get props => [activity];
}

class MarkActivityAsReadEvent extends ActivityEvent {
  const MarkActivityAsReadEvent({
    required this.activity,
  }) : super();

  final Activity activity;

  @override
  List<Object> get props => [activity];
}
