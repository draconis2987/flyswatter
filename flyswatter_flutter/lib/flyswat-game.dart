import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flyswatter_flutter/components/flies/agile-fly.dart';
import 'package:flyswatter_flutter/components/flies/hungry-fly.dart';
import 'package:flyswatter_flutter/components/flies/macho-fly.dart';
import 'package:flyswatter_flutter/views/credits-view.dart';
import 'package:flyswatter_flutter/views/help-view.dart';
import 'package:flyswatter_flutter/views/home-view.dart';
import 'package:flyswatter_flutter/views/lost-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/backyard.dart';
import 'components/buttons/credits-button.dart';
import 'components/buttons/help-button.dart';
import 'components/buttons/music-button.dart';
import 'components/highscore-display.dart';
import 'components/score-display.dart';
import 'components/buttons/sound-button.dart';
import 'components/buttons/start-button.dart';
import 'controllers/spawner.dart';
import 'file:///C:/Users/draco/Documents/development-files/flyswatter/flyswatter_flutter/lib/controllers/music-manager.dart';

import 'components/flies/drooler-fly.dart';
import 'components/flies/fly.dart';
import 'components/flies/house-fly.dart';
import 'enums/view.dart';

class FlySwatGame extends BaseGame {

  final SharedPreferences storage;
  Size screenSize;
  double tileSize;
  Random rnd;

  Backyard background;
  List<Fly> flies;
  StartButton startButton;
  HelpButton helpButton;
  CreditsButton creditsButton;
  MusicButton musicButton;
  SoundButton soundButton;
  ScoreDisplay scoreDisplay;
  HighscoreDisplay highscoreDisplay;

  FlySpawner spawner;

  View activeView = View.home;
  HomeView homeView;
  LostView lostView;
  HelpView helpView;
  CreditsView creditsView;

  int score;

  FlySwatGame(this.storage) {
    initialize();
  }

  Future<void> initialize() async {
    rnd = Random();
    flies = List<Fly>();
    score = 0;
    resize(Size.zero);

    background = Backyard(this);
    startButton = StartButton(this);
    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);
    musicButton = MusicButton(this);
    soundButton = SoundButton(this);
    scoreDisplay = ScoreDisplay(this);
    highscoreDisplay = HighscoreDisplay(this);

    spawner = FlySpawner(this);
    homeView = HomeView(this);
    lostView = LostView(this);
    helpView = HelpView(this);
    creditsView = CreditsView(this);

    MusicManager.play(MusicManagerType.home);
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - (tileSize * 2.025));
    double y = (rnd.nextDouble() * (screenSize.height - (tileSize * 2.025))) + (tileSize * 1.5);

    switch (rnd.nextInt(5)) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(DroolerFly(this, x, y));
        break;
      case 2:
        flies.add(AgileFly(this, x, y));
        break;
      case 3:
        flies.add(MachoFly(this, x, y));
        break;
      case 4:
        flies.add(HungryFly(this, x, y));
        break;
    }
  }

  void render(Canvas canvas) {
    background.render(canvas);

    highscoreDisplay.render(canvas);
    if (activeView == View.playing || activeView == View.lost) scoreDisplay.render(canvas);

    flies.forEach((Fly fly) => fly.render(canvas));

    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.lost) lostView.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      helpButton.render(canvas);
      creditsButton.render(canvas);
    }
    musicButton.render(canvas);
    soundButton.render(canvas);
    if (activeView == View.help) helpView.render(canvas);
    if (activeView == View.credits) creditsView.render(canvas);
  }

  void update(double t) {
    spawner.update(t);
    flies.forEach((Fly fly) => fly.update(t));
    flies.removeWhere((Fly fly) => fly.isOffScreen);
    if (activeView == View.playing) scoreDisplay.update(t);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;

    background?.resize();

    highscoreDisplay?.resize();
    scoreDisplay?.resize();
    flies.forEach((Fly fly) => fly?.resize());

    homeView?.resize();
    lostView?.resize();
    helpView?.resize();
    creditsView?.resize();

    startButton?.resize();
    helpButton?.resize();
    creditsButton?.resize();
    musicButton?.resize();
    soundButton?.resize();

  }

  void onTapDown(TapDownDetails details) {
    bool isHandled = false;

    // dialog boxes
    if (!isHandled) {
      if (activeView == View.help || activeView == View.credits) {
        activeView = View.home;
        isHandled = true;
      }
    }

    // music button
    if (!isHandled && musicButton.rect.contains(details.globalPosition)) {
      musicButton.onTapDown();
      isHandled = true;
    }

    // sound button
    if (!isHandled && soundButton.rect.contains(details.globalPosition)) {
      soundButton.onTapDown();
      isHandled = true;
    }

    // help button
    if (!isHandled && helpButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
        isHandled = true;
      }
    }

    // credits button
    if (!isHandled && creditsButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        isHandled = true;
      }
    }

    // start button
    if (!isHandled && startButton.rect.contains(details.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        isHandled = true;
      }
    }

    // flies
    if (!isHandled) {
      bool didHitAFly = false;
      flies.forEach((Fly fly) {
        if (fly.flyPos.contains(details.globalPosition)) {
          fly.onTapDown();
          isHandled = true;
          didHitAFly = true;
        }
      });
      if (activeView == View.playing && !didHitAFly) {
        if (soundButton.isEnabled) {
          Flame.audio.play('sfx/haha' + (rnd.nextInt(5) + 1).toString() + '.ogg');
        }
        MusicManager.play(MusicManagerType.home);
        activeView = View.lost;
      }
    }
  }
}