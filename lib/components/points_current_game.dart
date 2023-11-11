import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../forge2d_game_world.dart';

class TotalPointInCurrentGame extends TextComponent with HasGameRef<BrickBreakGame> {

  late String totalPoints;


  @override
  Future<void> onLoad() async {
    await super.onLoad();
    totalPoints = gameRef.totalPointsInCurrentGame.toString();
    positionType = PositionType.game;
    text = 'Game: $totalPoints';
    position = Vector2(3,0.4);
    scale = Vector2(0.1, 0.1 );
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 13, color:Colors.yellow.shade800, fontWeight: FontWeight.w600));
    priority = 3;
  }

  @override
  void update(double dt){
    super.update(dt);
    totalPoints = gameRef.totalPointsInCurrentGame.toString();
    text = 'Game: $totalPoints';
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 13, color:Colors.yellow.shade800, fontWeight: FontWeight.w600));
  }

}