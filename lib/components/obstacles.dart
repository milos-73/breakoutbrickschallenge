import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../forge2d_game_world.dart';
import 'obstacle.dart';

class Obstacles extends Component with HasGameRef<BrickBreakGame>{

  Obstacles() : super(priority: 3);

  late TimerComponent obstacleTimer;
  int elapseTics = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    obstacleTimer = TimerComponent(period: 8,removeOnFinish: true, repeat: true,onTick: (){elapseTics += 1;if(gameRef.numberOfObstacles < 6){addObstacles();}});
    add(obstacleTimer);
  }

  @override
  Future<void> update(double dt) async {
    for (final child in [... children]){
      if (child is Obstacle1 && child.destroy){
        for ( final fixture in [...child.body.fixtures]){
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
      }
    }
    super.update(dt);
  }

  Future<String>getSpriteName()async {

    var indexNumber = Random().nextInt(2+1)+1;

    switch (indexNumber) {
      case 1:
        String brick = 'objects/object1.png';
        return brick;
      case 2:
        String brick = 'objects/object2.png';
        return brick;
     default:
        String brick = 'objects/object1.png';
        return brick;
    }
  }

  Future<void>addObstacles() async {

    double vectorX = (Random().nextInt(30)+5).toDouble();
    double vectorY = (Random().nextInt(45)+25).toDouble();

    Obstacle1 obstacle1 = Obstacle1(size: const Size(3,3), position: Vector2(vectorX,vectorY), spriteName: await getSpriteName());

    if(gameRef.gameState == GameState.running){
      add(obstacle1..priority = 3);
      gameRef.numberOfObstacles = gameRef.numberOfObstacles + 1;
    };

  }

  Future<void> resetObstacle() async {

    obstacleTimer.removeFromParent();
    gameRef.numberOfObstacles = 0;
    removeAll(children);
    elapseTics = 0;
    var obstacleTimerNew = TimerComponent(period: 8,removeOnFinish: true, repeat: true,onTick: (){elapseTics += 1;if(gameRef.numberOfObstacles < 6){addObstacles();}});
    add(obstacleTimerNew);
  }

}