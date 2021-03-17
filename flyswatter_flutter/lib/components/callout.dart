import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';
import 'package:flyswatter_flutter/enums/view.dart';
import 'file:///C:/Users/draco/Documents/development-files/flyswatter/flyswatter_flutter/lib/controllers/music-manager.dart';

import 'flies/fly.dart';


class Callout {
  final Fly fly;
  Rect rect;
  Sprite sprite;
  double value;

  TextPainter tp;
  Offset textOffset;

  Callout(this.fly) {
    sprite = Sprite('ui/callout.png');
    value = 1;
    tp = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
    tp.paint(c, textOffset);
  }

  void update(double t) {
    if (fly.game.activeView == View.playing) {
      value = value - .5 * t;
      if (value <= 0) {
        if (fly.game.soundButton.isEnabled) {
          Flame.audio.play('sfx/haha' + (fly.game.rnd.nextInt(5) + 1).toString() + '.ogg');
        }
        MusicManager.play(MusicManagerType.home);
        fly.game.activeView = View.lost;
      }
    }

    rect = Rect.fromLTWH(
      fly.flyPos.left - (fly.game.tileSize * .75),
      fly.flyPos.top - (fly.game.tileSize * .625),
      fly.game.tileSize * .75,
      fly.game.tileSize * .75,
    );

    tp.text = TextSpan(
      text: (value * 10).toInt().toString(),
      style: TextStyle(
        color: Color(0xffffffff),
        fontSize: fly.game.tileSize * .375,
      ),
    );
    tp.layout();
    textOffset = Offset(
      rect.center.dx - (tp.width / 2),
      rect.top + (rect.height * .4) - (tp.height / 2),
    );
  }
}
