import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../forge2d_game_world.dart';

class LevelPointTopCounter extends TextComponent with HasGameRef<BrickBreakGame> {

  late String levelPointsTop;


  @override
  Future<void> onLoad() async {
    await super.onLoad();
    levelPointsTop = gameRef.levelPointTop.toString();
    positionType = PositionType.game;
    text = 'Best Level: $levelPointsTop';
    position = Vector2(12.5,-1);
    scale = Vector2(0.1, 0.1 );
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 13, color:Colors.yellow.shade900, fontWeight: FontWeight.w600));
    priority = 3;
  }

  @override
  void update(double dt){
    super.update(dt);
    levelPointsTop = gameRef.levelPointTop.toString();
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 13, color:Colors.yellow.shade900, fontWeight: FontWeight.w600));
    text = 'Best Level: $levelPointsTop';
  }
}