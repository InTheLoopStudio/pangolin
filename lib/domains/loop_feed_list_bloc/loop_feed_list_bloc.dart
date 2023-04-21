import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/loop.dart';

part 'loop_feed_list_event.dart';
part 'loop_feed_list_state.dart';

class LoopFeedListBloc extends Bloc<LoopFeedListEvent, LoopFeedListState> {
  LoopFeedListBloc({
    required this.initialIndex,
    required this.feedParamsList,
  }) : super(
          LoopFeedListState(
            index: initialIndex,
            feedParamsList: feedParamsList,
          ),
        ) {
    on<ScrollToTop>((event, emit) {
      final tabIndex = state.index;
      feedParamsList[tabIndex].scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
          );
    });
    on<ChangeFeed>((event, emit) {
      emit(state.copyWith(index: event.index));
    });
  }

  final int initialIndex;
  final List<FeedParams> feedParamsList;
}
