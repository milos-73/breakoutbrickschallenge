import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../forge2d_game_world.dart';

class TotalStarsCounter extends TextComponent with HasGameRef<BrickBreakGame> {

  late String totalPoints;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    totalPoints = gameRef.totalStars.toString();
    positionType = PositionType.game;
    text = '★ $totalPoints';
    position = Vector2(2,74);
    scale = Vector2(0.1, 0.1 );
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 18, color:Colors.red.shade400, fontWeight: FontWeight.w600));
    priority = 6;
  }

  @override
  void update(double dt){
    super.update(dt);
    totalPoints = gameRef.totalStars.toString();
    text = '★ $totalPoints';
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 18, color:Colors.red.shade400, fontWeight: FontWeight.w600));
    position = Vector2(2,74);
    scale = Vector2(0.1, 0.1 );
    priority = 6;
  }

}