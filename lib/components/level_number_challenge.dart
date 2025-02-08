import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../forge2d_game_world.dart';

class LevelNumberChallenge extends TextComponent with HasGameRef<BrickBreakGame> {

  late String levelNumberChallenge;


  @override
  Future<void> onLoad() async {

    levelNumberChallenge  =await gameRef.prefs.getInt('challengeLevel').toString();

    await super.onLoad();
    positionType = PositionType.game;
    text = 'Level No. $levelNumberChallenge';
    position = Vector2(12.5,- 2.2);
    scale = Vector2(0.1, 0.1 );
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 13, color:Colors.yellow.shade900, fontWeight: FontWeight.w600));
    priority = 3;
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    levelNumberChallenge  = await gameRef.prefs.getInt('challengeLevel').toString();
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 13, color:Colors.yellow.shade900, fontWeight: FontWeight.w600));
    text = 'Level No. $levelNumberChallenge';
  }
}