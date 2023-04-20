part of 'loop_feed_list_bloc.dart';

abstract class LoopFeedListEvent extends Equatable {
  const LoopFeedListEvent();

  @override
  List<Object> get props => [];
}

class ScrollToTop extends LoopFeedListEvent {}

class ChangeFeed extends LoopFeedListEvent {
  const ChangeFeed({
    required this.index,
  });

  final int index;

  @override
  List<Object> get props => [index];
}
