import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flyswatter_flutter/flyswat-game.dart';

import 'fly.dart';


class MachoFly extends Fly {
  double get speed => game.tileSize * 2.5;

  MachoFly(FlySwatGame game, double x, double y) : super(game) {
    resize(x: x, y: y);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('flies/macho-fly-1.png'));
    flyingSprite.add(Sprite('flies/macho-fly-2.png'));
    deadSprite = Sprite('flies/macho-fly-dead.png');
  }

  void resize({double x, double y}) {
    x ??= (flyPos?.left) ?? 0;
    y ??= (flyPos?.top) ?? 0;
    flyPos = Rect.fromLTWH(x, y, game.tileSize * 1.35, game.tileSize * 1.35);
    super.resize();
  }
}
