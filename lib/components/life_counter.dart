import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../forge2d_game_world.dart';

class LifeCounter extends TextComponent with HasGameRef<BrickBreakGame> {

  late String life;


@override
  Future<void> onLoad() async {
  await super.onLoad();
  life = gameRef.life.toString();
  positionType = PositionType.game;
  gameRef.life > 1 ? text = '$life lives left' : text = '$life life left';
  position = Vector2(26,74);
  scale = Vector2(0.1, 0.1 );
  textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (fontSize: 18, color:Colors.white, fontWeight: FontWeight.w800));
  priority = 6;
}

  @override
  void update(double dt){
    super.update(dt);
    life = gameRef.life.toString();
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (fontSize: 18, color:Colors.yellow.shade800, fontWeight: FontWeight.w800));
    gameRef.life > 1 ? text = '$life lives left' : text = '$life life left';
    position = Vector2(26,74);
    scale = Vector2(0.1, 0.1 );
    priority = 6;
  }

}