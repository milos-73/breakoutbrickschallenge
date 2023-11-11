import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:initial_project/components/paddle.dart';
import '../forge2d_game_world.dart';
import 'dead_zone.dart';

class PointNumber extends BodyComponent<BrickBreakGame> with ContactCallbacks{

  final Size size;
  final Vector2 position;

  PointNumber({required this.size, required this.position});

  List<int> number = [-50,50,-100,100,-200,200,-500,500];

  bool destroy = false;
  int pointIndex = 0;
  int finalPoint = 0;

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    await getPointIndex();
    finalPoint = number[pointIndex];
    final sprite = await gameRef.loadSprite('points/$finalPoint.png');
    renderBody = false;
    add(SpriteComponent(sprite: sprite, size: Vector2(size.width, size.height), anchor: Anchor.center));
  }

  Future<void>getPointIndex() async {
    pointIndex = Random().nextInt(8);
       }

  @override
  void beginContact(Object other, Contact contact){
    if (other is Paddle){
     // print('BONUS SLOW TO PADDLE CONTACT');
      destroy = true;

      if (game.audioSettings == AudioSettings.on && finalPoint > 0 )  {
        FlameAudio.play('positiveNumber.mp3');
      }
      if (game.audioSettings == AudioSettings.on && finalPoint < 0 )  {
        FlameAudio.play('negativeNumber.mp3');
      }

      gameRef.levelPoints = gameRef.levelPoints + finalPoint;
      gameRef.totalPointsInCurrentGame = gameRef.totalPointsInCurrentGame + finalPoint;

    }
    if(other is DeadZone){
      destroy = true;
    }
  }

  /// Create Body
  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = position
      ..gravityOverride = Vector2(0, 4)
    //..userData = this
      ..linearDamping = 1.0;

    final brickBody = world.createBody(bodyDef);

    /// Shape with default values
    final shape = PolygonShape()
      ..setAsBox(

        size.width / 2.0,
        size.height / 2.0,
        Vector2(0.0, 0.0),
        0.0,
      );

    /// Create Fixture
    brickBody.createFixture(
      FixtureDef(shape)
        ..density = 0
        ..friction = 0.0
        ..userData = this
        ..isSensor = true
        ..restitution = 0,
    );

    return brickBody;
  }
}