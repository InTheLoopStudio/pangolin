part of 'dynamic_link_bloc.dart';

abstract class DynamicLinkEvent extends Equatable {
  const DynamicLinkEvent();
}

class MonitorDynamicLinks extends DynamicLinkEvent {
  @override
  List<Object> get props => [];
}
