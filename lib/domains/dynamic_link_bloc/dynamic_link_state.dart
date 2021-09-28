part of 'dynamic_link_bloc.dart';

abstract class DynamicLinkState extends Equatable {
  const DynamicLinkState();
}

class DynamicLinkInitial extends DynamicLinkState {
  @override
  List<Object> get props => [];
}
