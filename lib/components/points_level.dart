import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../forge2d_game_world.dart';

class LevelPointCounter extends TextComponent with HasGameRef<BrickBreakGame> {

  late String levelPoints;


  @override
  Future<void> onLoad() async {
    await super.onLoad();
    levelPoints = gameRef.levelPoints.toString();
    positionType = PositionType.game;
    text = 'Level: $levelPoints';
    position = Vector2(3,- 2.2);
    scale = Vector2(0.1, 0.1 );
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4, fontSize: 13, color:Colors.yellow.shade800, fontWeight: FontWeight.w600));
    priority = 6;
  }

  @override
  void update(double dt){
    super.update(dt);
    levelPoints = gameRef.levelPoints.toString();
    text = 'Level: $levelPoints';
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 13, color:Colors.yellow.shade800, fontWeight: FontWeight.w600));
    position = Vector2(3,- 2.2);
    scale = Vector2(0.1, 0.1 );
    priority = 6;
  }

}