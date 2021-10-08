part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object> get props => [];
}

class InitListenerEvent extends ActivityEvent {}

class FetchActivitiesEvent extends ActivityEvent {}

class MarkActivityAsReadEvent extends ActivityEvent {
  MarkActivityAsReadEvent({
    required this.activity,
  }) : super();

  final Activity activity;

  @override
  List<Object> get props => [activity];
}
