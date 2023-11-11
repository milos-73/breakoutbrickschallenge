import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../forge2d_game_world.dart';

class StarsLevelTotal extends TextComponent with HasGameRef<BrickBreakGame> {

  late String numberOfTotalStars;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    numberOfTotalStars = gameRef.levelStars.toString();
    positionType = PositionType.game;
    numberOfTotalStars == '0'
        ? text = '☆☆☆☆☆'
        : numberOfTotalStars == '1'
        ? text = '★☆☆☆☆'
        : numberOfTotalStars == '2'
        ? text = '★★☆☆☆'
        : numberOfTotalStars == '3'
        ? text = '★★★☆☆'
        : numberOfTotalStars == '4'
        ? text = '★★★★☆'
        : numberOfTotalStars == '5'
        ? text = '★★★★★'
        : text = '☆☆☆☆☆';
    //text = '☆ Stars Total: $numberOfTotalStars';
    position = Vector2(3,-2.7);
    scale = Vector2(0.1, 0.1 );
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 18, color:Colors.red.shade700, fontWeight: FontWeight.w600));
    priority = 6;
  }

  @override
  void update(double dt){
    super.update(dt);
    numberOfTotalStars = gameRef.levelStars.toString();
    numberOfTotalStars == '0'
        ? text = '☆☆☆☆☆'
        : numberOfTotalStars == '1'
        ? text = '★☆☆☆☆'
        : numberOfTotalStars == '2'
        ? text = '★★☆☆☆'
        : numberOfTotalStars == '3'
        ? text = '★★★☆☆'
        : numberOfTotalStars == '4'
        ? text = '★★★★☆'
        : numberOfTotalStars == '5'
        ? text = '★★★★★'
        : text = '☆☆☆☆☆';

    //text = '☆★ Stars Total: $numberOfTotalStars';
    position = Vector2(3,-2.7);
    scale = Vector2(0.1, 0.1 );
    textRenderer = TextPaint(style: GoogleFonts.reemKufiFun (letterSpacing: 1.4,fontSize: 18, color:Colors.red.shade700, fontWeight: FontWeight.w600));
    priority = 6;
  }
}