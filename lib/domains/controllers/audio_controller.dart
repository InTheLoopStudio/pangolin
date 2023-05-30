import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intheloopapp/app_logger.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:just_audio/just_audio.dart';

AudioController? currentController;

CacheManager myCacheManager = DefaultCacheManager();

class AudioController {
  AudioController._({
    required this.audioRepo,
    this.source,
    this.duration = Duration.zero,
    // ignore: unused_element
    this.position = Duration.zero,
    // ignore: unused_element
    this.bufferedPosition = Duration.zero,
    // ignore: unused_element
    this.loopMode = LoopMode.one,
    this.image,
    this.title,
    this.artist,
  }) {
    playerState = PlayerState(false, ProcessingState.idle);
  }

  factory AudioController.fromAudioFile({
    required AudioRepository audioRepo,
    File? audioFile,
    String? title,
    String? artist,
    String? image,
  }) {
    return AudioController._(
      audioRepo: audioRepo,
      source: audioFile?.path ?? '',
      title: title,
      artist: artist,
      image: image,
    );
  }

  static Future<AudioController> fromUrl({
    required AudioRepository audioRepo,
    required String url,
    String? title,
    String? image,
    String? artist,
  }) async {
    try {
      final File file = await myCacheManager.getSingleFile(url);
      final duration = await AudioPlayer().setFilePath(file.path);

      return AudioController._(
        audioRepo: audioRepo,
        source: file.path,
        duration: duration,
        title: title,
        image: image,
        artist: artist,
      );
    } catch (e, s) {
      logger.error(
        'cannot build AudiusController from URL $url',
        error: e,
        stackTrace: s,
      );
      throw Exception('could not build AudiusController from URL $url');
    }
  }

  final AudioRepository audioRepo;

  final String? source;

  final String? title;
  final String? image;
  final String? artist;

  LoopMode loopMode;
  Duration? duration;
  Duration position;
  Duration bufferedPosition;
  late PlayerState playerState;

  MediaItem get mediaItem => MediaItem(
        id: '',
        title: title ?? '',
        artist: artist,
        artUri: Uri.parse(image ?? ''),
      );

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
    if (audioRepo.durationStream == null) {
      yield duration;
    }

    await for (final playerDuration in audioRepo.durationStream!) {
      if (attached) {
        yield playerDuration;
      } else {
        yield duration;
      }
    }
  }

  Stream<Duration> combinedPositionStream() async* {
    if (audioRepo.positionStream == null) {
      yield position;
    }

    await for (final playerPosition in audioRepo.positionStream!) {
      if (attached) {
        yield playerPosition;
      } else {
        yield position;
      }
    }
  }

  Stream<Duration> combinedBufferedPositionStream() async* {
    if (audioRepo.bufferedPositionStream == null) {
      yield bufferedPosition;
    }

    await for (final playerBufferedPosition
        in audioRepo.bufferedPositionStream!) {
      if (attached) {
        yield playerBufferedPosition;
      } else {
        yield bufferedPosition;
      }
    }
  }

  Stream<PlayerState> combinedPlayerStateStream() async* {
    if (audioRepo.playerStateStream == null) {
      yield playerState;
    }

    await for (final fromStreamState in audioRepo.playerStateStream!) {
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
    durationListener = audioRepo.durationStream?.listen((event) {
      duration = event;
    });
    positionListener = audioRepo.positionStream?.listen((event) {
      position = event;
    });
    bufferedPositionListener =
        audioRepo.bufferedPositionStream?.listen((event) {
      bufferedPosition = event;
    });
    playerStateListener = audioRepo.playerStateStream?.listen((event) {
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

    await audioRepo.playMediaItem(mediaItem);
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
