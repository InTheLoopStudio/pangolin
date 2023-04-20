part of 'loop_feed_list_bloc.dart';

class LoopFeedListState extends Equatable {
  const LoopFeedListState({
    required this.index,
    required this.feedParamsList,
  });

  final List<FeedParams> feedParamsList;
  final int index;

  @override
  List<Object> get props => [
        index,
        feedParamsList,
      ];

  LoopFeedListState copyWith({
    int? index,
    List<FeedParams>? feedParamsList,
  }) {
    return LoopFeedListState(
      index: index ?? this.index,
      feedParamsList: feedParamsList ?? this.feedParamsList,
    );
  }
}

class FeedParams {
  FeedParams({
    required this.sourceFunction,
    required this.sourceStream,
    required this.tabTitle,
    required this.feedKey,
    required this.scrollController,
  });

  final String tabTitle;
  final String feedKey;
  final ScrollController scrollController;
  final Future<List<Loop>> Function(
    String currentUserId, {
    int limit,
    String? lastLoopId,
    bool ignoreCache,
  }) sourceFunction;
  final Stream<Loop> Function(
    String currentUserId, {
    int limit,
    bool ignoreCache,
  }) sourceStream;
}
