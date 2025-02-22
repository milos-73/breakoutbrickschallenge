import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/src/parallax.dart';
import 'package:brickbreaker/forge2d_game_world.dart';

class Background extends ParallaxComponent<BrickBreakGame>{

  int? backgroundNumber;

  Background() : super(priority: 0);

  @override
  Future<void> onLoad() async {
    backgroundNumber =  Random().nextInt(9)+10;
    parallax = await gameRef.loadParallax([ParallaxImageData('bg/bg$backgroundNumber.jpg')]);
  }

  Future<void>resetBackground()async {
    backgroundNumber =  Random().nextInt(9)+10;
    parallax = await gameRef.loadParallax([ParallaxImageData('bg/bg$backgroundNumber.jpg')]);
  }
}