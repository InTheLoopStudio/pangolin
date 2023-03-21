import 'package:audio_service/audio_service.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:just_audio/just_audio.dart';

AudioHandler? audioHandler;
final _player = AudioPlayer();

class AudioServiceImpl implements AudioRepository {

  @override
  Future<void> initAudioService() async {
    final handler = await AudioService.init(
      builder: AudioHandler.new,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.intheloopstudio.audio',
        androidNotificationChannelName: 'Audio Service',
        androidNotificationOngoing: true,
      ),
    );

    audioHandler = handler;
  }
  
  @override
  // TODO: implement bufferedPositionStream
  Stream<Duration> get bufferedPositionStream => throw UnimplementedError();
  
  @override
  // TODO: implement durationStream
  Stream<Duration?> get durationStream => throw UnimplementedError();
  
  @override
  // TODO: implement effectiveIndices
  List<int>? get effectiveIndices => throw UnimplementedError();
  
  @override
  bool isPlaying() {
    // TODO: implement isPlaying
    throw UnimplementedError();
  }
  
  @override
  Future<void> pause() {
    // TODO: implement pause
    throw UnimplementedError();
  }
  
  @override
  Future<void> play() {
    // TODO: implement play
    throw UnimplementedError();
  }
  
  @override
  // TODO: implement playerStateStream
  Stream<PlayerState> get playerStateStream => throw UnimplementedError();
  
  @override
  // TODO: implement positionStream
  Stream<Duration> get positionStream => throw UnimplementedError();
  
  @override
  Future<void> seek(Duration? duration, {int? index}) {
    // TODO: implement seek
    throw UnimplementedError();
  }
  
  @override
  Future<void> setFilePath(String source, {Duration initialPosition = Duration.zero}) {
    // TODO: implement setFilePath
    throw UnimplementedError();
  }
  
  @override
  Future<void> setLoopMode(LoopMode mode) {
    // TODO: implement setLoopMode
    throw UnimplementedError();
  }
}

class AudioHandler extends BaseAudioHandler {
  AudioHandler() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    // _listenToCurrentPosition();
    _listenForCurrentSongIndexChanges();
  }

  final _playlist = ConcatenatingAudioSource(children: []);

  Future<void> _loadEmptyPlaylist() async {
    await _player.setAudioSource(_playlist);
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    // manage Just Audio
    final audioSource = mediaItems.map(_createAudioSource);
    await _playlist.addAll(audioSource.toList());

    // notify system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.parse(mediaItem.extras!['url'] as String),
      tag: mediaItem,
    );
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
          playing: playing,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
          queueIndex: event.currentIndex,
        ),
      );
    });
  }

  // void _listenToCurrentPosition() {
  //   AudioService.position.listen((position) {
  //     final oldState = progressNotifier.value;
  //     progressNotifier.value = ProgressBarState(
  //       current: position,
  //       buffered: oldState.buffered,
  //       total: oldState.total,
  //     );
  //   });
  // }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      mediaItem.add(playlist[index]);
    });
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }
}
