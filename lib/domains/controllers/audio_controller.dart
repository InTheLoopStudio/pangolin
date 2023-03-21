import 'dart:async';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';

AudioController? currentController;

class AudioController {
  AudioController._({
    this.source,
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.bufferedPosition = Duration.zero,
    this.loopMode = LoopMode.one,
  }) {
    playerState = PlayerState(false, ProcessingState.idle);
  }

  factory AudioController.fromAudioFile(File? audioFile) {
    return AudioController._(
      source: audioFile?.path ?? '',
    );
  }

  static Future<AudioController> fromUrl(String url) async {
    final File file = await DefaultCacheManager().getSingleFile(url);
    final duration = await AudioPlayer().setFilePath(file.path);

    // AudioSource.file(
    //   file.path,
    //   tag: MediaItem(
    //     // Specify a unique ID for each media item:
    //     id: '1',
    //     // Metadata to display in the notification:
    //     album: "Album name",
    //     title: "Song name",
    //     artUri: Uri.parse('https://example.com/albumart.jpg'),
    //   ),
    // );

    return AudioController._(
      source: file.path,
      duration: duration,
    );
  }

  final AudioRepository audioRepo;

  final String? source;
  LoopMode loopMode;

  Duration? duration;
  Duration position;
  Duration bufferedPosition;
  late PlayerState playerState;

  StreamSubscription<Duration?>? durationListener;
  StreamSubscription<Duration>? positionListener;
  StreamSubscription<Duration>? bufferedPositionListener;
  StreamSubscription<PlayerState>? playerStateListener;

  bool get attached => this == currentController;
  bool get isPlaying => attached && audioRepo.isPlaying();

  Stream<Duration?> get durationStream => combinedDurationStream();
  Stream<Duration> get positionStream => combinedPositionStream();
  Stream<Duration> get bufferedPositionStream =>
      combinedBufferedPositionStream();
  Stream<PlayerState> get playerStateStream => combinedPlayerStateStream();
  List<int>? get effectiveIndices =>
      attached ? audioRepo.effectiveIndices : null;

  Stream<Duration?> combinedDurationStream() async* {
    await for (final playerDuration in audioRepo.durationStream) {
      if (attached) {
        yield playerDuration;
      } else {
        yield duration;
      }
    }
  }

  Stream<Duration> combinedPositionStream() async* {
    await for (final playerPosition in audioRepo.positionStream) {
      if (attached) {
        yield playerPosition;
      } else {
        yield position;
      }
    }
  }

  Stream<Duration> combinedBufferedPositionStream() async* {
    await for (final playerBufferedPosition
        in audioRepo.bufferedPositionStream) {
      if (attached) {
        yield playerBufferedPosition;
      } else {
        yield bufferedPosition;
      }
    }
  }

  Stream<PlayerState> combinedPlayerStateStream() async* {
    await for (final fromStreamState in audioRepo.playerStateStream) {
      if (attached) {
        yield fromStreamState;
      } else {
        yield playerState;
      }
    }
  }

  static Future<Duration> getDuration(File? audioFile) async {
    return await AudioPlayer().setFilePath(audioFile?.path ?? '') ??
        Duration.zero;
  }

  Future<void> attach() async {
    if (source == null) {
      throw Exception('cannot attach with an empty source');
    }

    await currentController?.detach();

    // set the source
    await audioRepo.setFilePath(
      source!,
      initialPosition: position,
    );

    await audioRepo.setLoopMode(loopMode);

    // listen to the audio streams
    durationListener = audioRepo.durationStream.listen((event) {
      duration = event;
    });
    positionListener = audioRepo.positionStream.listen((event) {
      position = event;
    });
    bufferedPositionListener = audioRepo.bufferedPositionStream.listen((event) {
      bufferedPosition = event;
    });
    playerStateListener = audioRepo.playerStateStream.listen((event) {
      playerState = event;
    });

    currentController = this;
  }

  Future<void> detach() async {
    await audioRepo.pause();

    // stop listening to the streams
    await positionListener?.cancel();
    await durationListener?.cancel();
    await bufferedPositionListener?.cancel();
    await playerStateListener?.cancel();

    currentController = null;
  }

  Future<void> play() async {
    if (!attached) {
      await attach();
    }

    await audioRepo.play();
  }

  Future<void> pause() async {
    if (!attached) {
      return;
      // await attach();
    }

    await audioRepo.pause();
  }

  Future<void> seek(Duration? duration, {int? index}) async {
    position = duration ?? Duration.zero;
    if (attached) {
      await audioRepo.seek(duration, index: index);
    }
  }

  Future<void> setLoopMode(LoopMode mode) async {
    loopMode = mode;
    if (attached) {
      await audioRepo.setLoopMode(mode);
    }
  }

  Future<void> dispose() async {
    await detach();
  }
}

class PositionData {
  PositionData(this.position, this.bufferedPosition);
  final Duration position;
  final Duration bufferedPosition;
}
