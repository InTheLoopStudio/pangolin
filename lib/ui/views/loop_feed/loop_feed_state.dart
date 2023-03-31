part of 'loop_feed_cubit.dart';

enum LoopFeedStatus { initial, success, failure }

@immutable
class LoopFeedState extends Equatable {
  const LoopFeedState({
    this.currentIndex = 0,
    this.hasReachedMax = false,
    this.status = LoopFeedStatus.initial,
    this.loops = const [],
  });

  final int currentIndex;
  final bool hasReachedMax;
  final LoopFeedStatus status;
  final List<Loop> loops;

  @override
  List<Object> get props => [
        currentIndex,
        hasReachedMax,
        status,
        loops,
      ];

  LoopFeedState copyWith({
    int? currentIndex,
    bool? hasReachedMax,
    LoopFeedStatus? status,
    List<Loop>? loops,
  }) {
    return LoopFeedState(
      currentIndex: currentIndex ?? this.currentIndex,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
      loops: loops ?? this.loops,
    );
  }
}
