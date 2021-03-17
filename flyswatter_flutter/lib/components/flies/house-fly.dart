import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flyswatter_flutter/flyswat-game.dart';

import 'fly.dart';


class HouseFly extends Fly {
  HouseFly(FlySwatGame game, double x, double y) : super(game) {
    resize(x: x, y: y);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('flies/house-fly-1.png'));
    flyingSprite.add(Sprite('flies/house-fly-2.png'));
    deadSprite = Sprite('flies/house-fly-dead.png');
  }

  void resize({double x, double y}) {
    x ??= (flyPos?.left) ?? 0;
    y ??= (flyPos?.top) ?? 0;
    flyPos = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);
    super.resize();
  }
}
