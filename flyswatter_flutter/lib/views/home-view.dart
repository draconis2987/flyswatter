import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flyswatter_flutter/flyswat-game.dart';

class HomeView {
  final FlySwatGame game;
  Rect titleRect;
  Sprite titleSprite;

  HomeView(this.game) {
    resize();
    titleSprite = Sprite('branding/title.png');
  }

  void render(Canvas c) {
    titleSprite.renderRect(c, titleRect);
  }

  void resize() {
    titleRect = Rect.fromLTWH(
      game.tileSize,
      (game.screenSize.height / 2) - (game.tileSize * 4),
      game.tileSize * 7,
      game.tileSize * 4,
    );
  }
}
