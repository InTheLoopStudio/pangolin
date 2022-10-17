import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intheloopapp/domains/models/loop.dart';

part 'audio_feed_state.dart';

class AudioFeedCubit extends Cubit<AudioFeedState> {
  AudioFeedCubit({
    required this.currentUserId,
    required this.sourceFunction,
    required this.sourceStream,
  }) : super(const AudioFeedState());

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

  // @override
  // AudioFeedState? fromJson(Map<String, dynamic> json) {
  //   return AudioFeedState(
  //     currentIndex: json['currentIndex'],
  //     hasReachedMax: json['hasReachedMax'],
  //     status: json['status'],
  //     loops: json['loops'] as List<Loop>,
  //     easterEggTapped: state.easterEggTapped,
  //   );
  // }

  // @override
  // Map<String, dynamic>? toJson(AudioFeedState state) {
  //   return {
  //     'currentIndex': state.currentIndex,
  //     'hasReachedMax': state.hasReachedMax,
  //     'status': state.status,
  //     'loops': state.loops.map((loop) => loop.toJson()).toList(),
  //     'easterEggTapped': state.easterEggTapped,
  //   };
  // }

  Future<void> initLoops({bool clearLoops = true}) async {
    await loopListener?.cancel();
    if (clearLoops) {
      emit(
        state.copyWith(
          status: AudioFeedStatus.initial,
          loops: [],
          hasReachedMax: false,
        ),
      );
    }

    final loopsAvailable =
        (await sourceFunction(currentUserId, limit: 1)).isNotEmpty;
    if (!loopsAvailable) {
      emit(state.copyWith(status: AudioFeedStatus.success));
    }

    loopListener = sourceStream(currentUserId, limit: 20).listen((Loop event) {
      // print('loop { ${event.id} : ${event.title} }');
      emit(
        state.copyWith(
          status: AudioFeedStatus.success,
          loops: List.of(state.loops)..add(event),
        ),
      );
    });
  }

  Future<void> fetchMoreLoops() async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == AudioFeedStatus.initial) {
        await initLoops();
      }

      final loops = await sourceFunction(
        currentUserId,
        limit: 20,
        lastLoopId: state.loops.last.id,
      );
      loops.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: AudioFeedStatus.success,
                loops: List.of(state.loops)..addAll(loops),
                hasReachedMax: false,
              ),
            );
    } on Exception {
      emit(state.copyWith(status: AudioFeedStatus.failure));
    }
  }

  void tapEasterEgg() {
    emit(state.copyWith(easterEggTapped: state.easterEggTapped + 1));
  }

  @override
  Future<void> close() async {
    await loopListener?.cancel();
    await super.close();
  }
}
