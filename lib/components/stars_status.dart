import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../forge2d_game_world.dart';

class StarsStatusPerLevel extends TextComponent with HasGameRef<BrickBreakGame> {

  late String numberOfStars;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    numberOfStars = gameRef.currentGameLevelStars.toString();
    positionType = PositionType.game;
    numberOfStars == '0'
        ? text = '☆☆☆☆☆'
        : numberOfStars == '1'
        ? text = '★☆☆☆☆'
        : numberOfStars == '2'
        ? text = '★★☆☆☆'
        : numberOfStars == '3'
        ? text = '★★★☆☆'
        : numberOfStars == '4'
        ? text = '★★★★☆'
        : numberOfStars == '5'
        ? text = '★★★★★'
        : text = '☆☆☆☆☆';

    position = Vector2(3,0);
    scale = Vector2(0.1, 0.1 );
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 18, color:Colors.yellow.shade800, fontWeight: FontWeight.w600));
    priority = 6;
  }

  @override
  void update(double dt){
    super.update(dt);
    numberOfStars = gameRef.currentGameLevelStars.toString();
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 18, color:Colors.yellow.shade800, fontWeight: FontWeight.w600));
    numberOfStars == '0'
        ? text = '☆☆☆☆☆'
        : numberOfStars == '1'
        ? text = '★☆☆☆☆'
        : numberOfStars == '2'
        ? text = '★★☆☆☆'
        : numberOfStars == '3'
        ? text = '★★★☆☆'
        : numberOfStars == '4'
        ? text = '★★★★☆'
        : numberOfStars == '5'
        ? text = '★★★★★'
        : text = '☆☆☆☆☆';

    position = Vector2(3,0);
    scale = Vector2(0.1, 0.1 );
    priority = 6;
  }
}