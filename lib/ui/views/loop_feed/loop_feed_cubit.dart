import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';

part 'loop_feed_state.dart';

class LoopFeedCubit extends Cubit<LoopFeedState> {
  LoopFeedCubit({
    required this.currentUserId,
    required this.sourceFunction,
    required this.sourceStream,
  }) : super(const LoopFeedState());

  final String currentUserId;
  final Future<List<Loop>> Function(
    String currentUserId, {
    int limit,
    String? lastLoopId,
  }) sourceFunction;
  final Stream<Loop> Function(
    String currentUserId, {
    int limit,
  }) sourceStream;
  StreamSubscription<Loop>? loopListener;

  Future<void> initLoops({bool clearLoops = true}) async {
    await loopListener?.cancel();
    if (clearLoops) {
      emit(
        state.copyWith(
          status: LoopFeedStatus.initial,
          loops: [],
          hasReachedMax: false,
        ),
      );
    }

    final loopsAvailable = await sourceFunction(
      currentUserId,
      limit: 1,
    );
    if (loopsAvailable.isEmpty) {
      emit(state.copyWith(status: LoopFeedStatus.success));
    }

    loopListener = sourceStream(currentUserId).listen((Loop event) {
      // print('loop { ${event.id} : ${event.title} }');
      emit(
        state.copyWith(
          status: LoopFeedStatus.success,
          loops: List.of(state.loops)..add(event),
        ),
      );
    });
  }

  Future<void> fetchMoreLoops() async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == LoopFeedStatus.initial) {
        await initLoops();
      }

      final loops = await sourceFunction(
        currentUserId,
        lastLoopId: state.loops.last.id,
      );
      loops.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: LoopFeedStatus.success,
                loops: List.of(state.loops)
                  ..addAll(loops)
                  ..sort(
                    (a, b) => b.timestamp.compareTo(a.timestamp),
                  ),
                hasReachedMax: false,
              ),
            );
    } on Exception {
      emit(state.copyWith(status: LoopFeedStatus.failure));
    }
  }

  @override
  Future<void> close() async {
    await loopListener?.cancel();
    await super.close();
  }
}
