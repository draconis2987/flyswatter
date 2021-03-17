import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flyswatter_flutter/flyswat-game.dart';


class Backyard {
  final FlySwatGame game;
  Sprite bgSprite;
  Rect bgRect;

  Backyard(this.game) {
    bgSprite = Sprite('bg/backyard.png');
    resize();
  }

  void render(Canvas c) {
    bgSprite.renderRect(c, bgRect);
  }

  void resize() {
    bgRect = Rect.fromLTWH(
      0,
      game.screenSize.height - (game.tileSize * 23),
      game.tileSize * 9,
      game.tileSize * 23,
    );
  }

  void update(double t) {}
}
