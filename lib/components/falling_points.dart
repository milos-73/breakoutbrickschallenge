import 'dart:math';

import 'package:flame/components.dart';
import 'package:initial_project/components/point_number.dart';
import 'package:initial_project/forge2d_game_world.dart';
import 'package:flutter/material.dart';

class FallingPoints extends Component with HasGameRef<BrickBreakGame> {
  FallingPoints()  : super(priority: 3);

  TimerComponent? pointsTimer;
  int elapseTics = 0;
  late TimerComponent pointPeriod;

  int count = 0;

//List zoznam = [Brick(size: null, position: null, spriteName: ''), Ball(position: null, radius: null)];

  @override
  Future<void> onLoad() async {
    super.onLoad();
    pointsTimer = TimerComponent(period: 2,removeOnFinish: true, repeat: true,onTick: (){elapseTics += 1;getPoint();});
    //print('ELAPSE TIME: $elapseTics');
    add(pointsTimer!);
  }

  @override
  Future<void> update(double dt) async {
    for (final child in [... children]){
      if (child is PointNumber && child.destroy){
        for ( final fixture in [...child.body.fixtures]){
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
             }
    }
    super.update(dt);
  }

  Future<void>getPoint()async {

    double vectorX = (Random().nextInt(30)+5).toDouble();
    double vectorY = (Random().nextInt(30)+10).toDouble();

        PointNumber bonus = PointNumber(size: const Size(2.5,1.8), position: Vector2(vectorX, vectorY),);

        if(gameRef.gameState == GameState.running){add(bonus..priority = 3);}
    }

  Future<void> resetFallingPoints() async {

    removeAll(children);
    pointsTimer?.removeFromParent();
    //gameRef.ticks = 1;
    elapseTics = 0;
    pointsTimer = TimerComponent(period: 2,removeOnFinish: true, repeat: true,onTick: (){elapseTics += 1;getPoint();});
    add(pointsTimer!);
  }

}