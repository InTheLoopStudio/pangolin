import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

abstract class AudioRepository {
  Future<void> initAudioService();

  bool isPlaying();

  Future<void> play();
  Future<void> playMediaItem(MediaItem mediaItem);
  Future<void> pause();
  Future<void> seek(Duration? duration, {int? index});
  Future<void> setLoopMode(LoopMode mode);

  Stream<Duration?>? get durationStream;
  Stream<Duration>? get positionStream;
  Stream<Duration>? get bufferedPositionStream;
  Stream<PlayerState>? get playerStateStream;
  List<int>? get effectiveIndices;

  Future<void> setFilePath(
    String source, {
    Duration? initialPosition,
  });
}
