import 'package:audio_service/audio_service.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:just_audio/just_audio.dart';

AudioHandler? _audioHandler;

class AudioServiceImpl implements AudioRepository {
  @override
  Future<void> initAudioService() async {
    final handler = await AudioService.init(
      builder: AudioHandler.new,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.intheloopstudio.audio',
        androidNotificationChannelName: 'Tapped Audio',
        androidNotificationOngoing: true,
      ),
    );

    _audioHandler = handler;
  }

  @override
  Stream<Duration>? get bufferedPositionStream =>
      _audioHandler?.bufferedPositionStream;

  @override
  Stream<Duration?>? get durationStream => _audioHandler?.durationStream;

  @override
  List<int>? get effectiveIndices => _audioHandler?.effectiveIndices;

  @override
  bool isPlaying() {
    return _audioHandler?.playing ?? false;
  }

  @override
  Future<void> pause() async {
    await _audioHandler?.pause();
  }

  @override
  Future<void> play() async {
    await _audioHandler?.play();
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    await _audioHandler?.playMediaItem(mediaItem);
  }

  @override
  Stream<PlayerState>? get playerStateStream =>
      _audioHandler?.playerStateStream;

  @override
  Stream<Duration>? get positionStream => _audioHandler?.positionStream;

  @override
  Future<void> seek(Duration? position, {int? index}) async {
    await _audioHandler?.seek(
      position ?? Duration.zero,
      index: index,
    );
  }

  @override
  Future<void> setFilePath(
    String source, {
    Duration? initialPosition,
  }) async {
    await _audioHandler?.setFilePath(source, initialPosition: initialPosition);
  }

  @override
  Future<void> setLoopMode(LoopMode mode) async {
    await _audioHandler?.setLoopMode(mode);
  }
}

class AudioHandler extends BaseAudioHandler {
  AudioHandler() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);

  Future<void> _loadEmptyPlaylist() async {
    await _player.setAudioSource(_playlist);
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(
        playbackState.value.copyWith(
          controls: [
            MediaControl.skipToPrevious,
            if (playing) MediaControl.pause else MediaControl.play,
            MediaControl.stop,
            MediaControl.skipToNext,
          ],
          systemActions: const {
            MediaAction.seek,
          },
          androidCompactActionIndices: const [0, 1, 3],
          processingState: const {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[_player.processingState]!,
          repeatMode: const {
            LoopMode.off: AudioServiceRepeatMode.none,
            LoopMode.one: AudioServiceRepeatMode.one,
            LoopMode.all: AudioServiceRepeatMode.all,
          }[_player.loopMode]!,
          playing: playing,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
          queueIndex: event.currentIndex,
        ),
      );
    });
  }

  bool get playing => _player.playing;

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    await _player.play();
    return super.playMediaItem(mediaItem);
  }

  @override
  Future<void> play() async {
    await _player.play();
    return super.play();
  }

  @override
  Future<void> seek(Duration position, {int? index}) async {
    await _player.seek(position, index: index);
    return super.seek(position);
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    return super.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  Future<void> setFilePath(
    String source, {
    Duration? initialPosition,
  }) async {
    await _player.setFilePath(source, initialPosition: initialPosition);
  }

  Future<void> setLoopMode(LoopMode mode) async {
    await _player.setLoopMode(mode);
  }

  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  List<int>? get effectiveIndices => _player.effectiveIndices;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
}
