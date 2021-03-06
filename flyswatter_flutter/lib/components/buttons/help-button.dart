import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flyswatter_flutter/enums/view.dart';
import 'package:flyswatter_flutter/flyswat-game.dart';

class HelpButton {
  final FlySwatGame game;
  Rect rect;
  Sprite sprite;

  HelpButton(this.game) {
    resize();
    sprite = Sprite('ui/icon-help.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void resize() {
    rect = Rect.fromLTWH(
      game.tileSize * .25,
      game.screenSize.height - (game.tileSize * 1.25),
      game.tileSize,
      game.tileSize,
    );
  }

  void onTapDown() {
    game.activeView = View.help;
  }
}
