import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:just_audio/just_audio.dart';

ValueNotifier<String> audioLock = ValueNotifier('');

class AudioController {
  AudioController() : player = AudioPlayer();

  AudioPlayer player;

  Future<Duration?> setURL(String url) async {
    try {
      File file = await DefaultCacheManager().getSingleFile(url);
      final duration = await setAudioFile(file);

      return duration;
    } on PlayerException catch (e) {
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      print('Error code: ${e.code}');
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web: a generic message
      print('Error message: ${e.message}');
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      print('Connection aborted: ${e.message}');
    } catch (e) {
      // Fallback for all errors
      print(e);
    }
    final duration = await player.setUrl(url);
    return duration!;
  }

  Future<Duration?> setAudioFile(File? audioFile) async {
    Duration? duration;

    if (audioFile == null) return const Duration();

    try {
      duration = await player.setFilePath(audioFile.path);
    } on PlayerException catch (e) {
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      print('Error code: ${e.code}');
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web: a generic message
      print('Error message: ${e.message}');
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      print('Connection aborted: ${e.message}');
    } catch (e) {
      // Fallback for all errors
      print(e);
    }

    return duration;
  }

  void play(String id) {
    audioLock.value = id;
    player.play();
  }

  void pause() {
    player.pause();
  }

  void seek(Duration? duration, {int? index}) {
    player.seek(duration, index: index);
  }

  void setLoopMode(LoopMode mode) {
    player.setLoopMode(mode);
  }

  void dispose() {
    player.dispose();
  }
}
