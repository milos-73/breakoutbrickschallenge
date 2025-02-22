import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../forge2d_game_world.dart';

class LevelPointTopCounter extends TextComponent with HasGameRef<BrickBreakGame> {

  late String levelPointsTop = '0';

  Future<void> getTopPointsForLevel() async {
    int? levelNumber = await gameRef.prefs.getInt('challengeLevel') ?? 0;
    int points = await gameRef.prefs.getInt('topLevelPoints$levelNumber') ?? 0;
    levelPointsTop = points.toString();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await getTopPointsForLevel();
    positionType = PositionType.game;
    text = 'Top Points: $levelPointsTop';
    position = Vector2(12.5,0.4);
    scale = Vector2(0.1, 0.1 );
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 13, color:Colors.yellow.shade900, fontWeight: FontWeight.w600));
    priority = 3;
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    await getTopPointsForLevel();
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 13, color:Colors.yellow.shade900, fontWeight: FontWeight.w600));
    text = 'Top Points: $levelPointsTop' ;
  }
}