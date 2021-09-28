part of 'audio_feed_cubit.dart';

enum AudioFeedStatus { initial, success, failure }

@immutable
class AudioFeedState extends Equatable {
  const AudioFeedState({
    this.currentIndex = 0,
    this.hasReachedMax = false,
    this.status = AudioFeedStatus.initial,
    this.loops = const [],
    this.easterEggTapped = 0,
  });

  final int currentIndex;
  final bool hasReachedMax;
  final AudioFeedStatus status;
  final List<Loop> loops;
  final int easterEggTapped;

  @override
  List<Object> get props => [
        currentIndex,
        hasReachedMax,
        status,
        loops,
        easterEggTapped,
      ];

  AudioFeedState copyWith({
    int? currentIndex,
    bool? hasReachedMax,
    AudioFeedStatus? status,
    List<Loop>? loops,
    int? easterEggTapped,
  }) {
    return AudioFeedState(
      currentIndex: currentIndex ?? this.currentIndex,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      status: status ?? this.status,
      loops: loops ?? this.loops,
      easterEggTapped: easterEggTapped ?? this.easterEggTapped,
    );
  }
}
