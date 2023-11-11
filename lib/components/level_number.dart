import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../forge2d_game_world.dart';

class LevelNumber extends TextComponent with HasGameRef<BrickBreakGame> {

  late String levelNumber;


  @override
  Future<void> onLoad() async {
    await super.onLoad();
    levelNumber = gameRef.currentPlayedLevelNumber.toString();
    positionType = PositionType.game;
    text = 'L $levelNumber';
    position = Vector2(17,- 1.5);
    scale = Vector2(0.1, 0.1 );
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4, fontSize: 23, color:Colors.yellow.shade800, fontWeight: FontWeight.w600));
    priority = 6;
  }

  @override
  void update(double dt){
    super.update(dt);
    levelNumber = gameRef.currentPlayedLevelNumber.toString();
    text = 'L $levelNumber';
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 23, color:Colors.yellow.shade800, fontWeight: FontWeight.w600));
    position = Vector2(17,- 1.5);
    scale = Vector2(0.1, 0.1 );
    priority = 6;
  }

}