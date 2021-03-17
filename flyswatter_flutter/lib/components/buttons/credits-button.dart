import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flyswatter_flutter/enums/view.dart';
import 'package:flyswatter_flutter/flyswat-game.dart';

class CreditsButton {
  final FlySwatGame game;
  Rect rect;
  Sprite sprite;

  CreditsButton(this.game) {
    resize();
    sprite = Sprite('ui/icon-credits.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void resize() {
    rect = Rect.fromLTWH(
      game.screenSize.width - (game.tileSize * 1.25),
      game.screenSize.height - (game.tileSize * 1.25),
      game.tileSize,
      game.tileSize,
    );
  }

  void onTapDown() {
    game.activeView = View.credits;
  }
}
