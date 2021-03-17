import 'package:flutter/widgets.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicManager {
  static AudioCache home;
  static AudioCache playing;
  static MusicManagerType current;
  static bool isPaused = false;
  static bool isInitialized = false;

  static Future<void> preload() async {
    home = AudioCache(fixedPlayer: AudioPlayer());
    await home.load('audio/bgm/home.mp3');
    await home.fixedPlayer.setReleaseMode(ReleaseMode.LOOP);

    playing = AudioCache( fixedPlayer: AudioPlayer());
    await playing.load('audio/bgm/playing.mp3');
    await playing.fixedPlayer.setReleaseMode(ReleaseMode.LOOP);

    isInitialized = true;
  }

  static Future<void> _update() async {
    if (!isInitialized) return;
    if (current == null) return;

    if (isPaused) {
      if (current == MusicManagerType.home) await home.fixedPlayer.pause();
      if (current == MusicManagerType.playing) await home.fixedPlayer.pause();
    } else {
      if (current == MusicManagerType.home) await home.fixedPlayer.resume();
      if (current == MusicManagerType.playing) await home.fixedPlayer.resume();
    }
  }

  static Future<void> play(MusicManagerType what) async {
    if (current != what) {
      if (what == MusicManagerType.home) {
        current = MusicManagerType.home;
        await playing.fixedPlayer.stop();
        await home.loop('audio/bgm/home.mp3', volume: .25);
      }
      if (what == MusicManagerType.playing) {
        current = MusicManagerType.playing;
        await playing.fixedPlayer.stop();
        await home.loop('audio/bgm/playing.mp3', volume: .25);
      }
    }
    _update();
  }

  static void pause() {
    isPaused = true;
    _update();
  }

  static void resume() {
    isPaused = false;
    _update();
  }
}

class MusicManagerHandler extends WidgetsBindingObserver {
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      MusicManager.resume();
    } else {
      MusicManager.pause();
    }
  }
}

enum MusicManagerType {
  home,
  playing,
}