import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:initial_project/components/bullet_left.dart';
import 'package:initial_project/components/bullet_right.dart';
import 'package:initial_project/components/dead_zone.dart';
import 'package:initial_project/components/paddle.dart';
import '../forge2d_game_world.dart';
import 'ball.dart';

/// Class
class Obstacle1 extends BodyComponent<BrickBreakGame> with ContactCallbacks {
  final Size size;
  final Vector2 position;
  final String spriteName;

  /// Constructor
  Obstacle1({
    required this.size,
    required this.position,
required this.spriteName
  });

  Random random = Random();
  var destroy = false;

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    final sprite = await gameRef.loadSprite(spriteName);
    renderBody = false;

    add(SpriteComponent() ..sprite = sprite
        ..size = Vector2(size.width, size.height)
         ..anchor = Anchor.center);
  }

  @override
  void update(double dt){
    super.update(dt);
    body.applyLinearImpulse(Vector2((random.nextInt(50+50)-50), (random.nextInt(50+50)-50))*5);
  }

  @override
  void beginContact(Object other, Contact contact){
    if(other is DeadZone){
      destroy = true;
      gameRef.numberOfObstacles = gameRef.numberOfObstacles - 1;
    }
    if(other is Ball){
      destroy = true;
      gameRef.numberOfObstacles = gameRef.numberOfObstacles - 1;
    }
    if(other is Paddle){
      destroy = true;
      gameRef.numberOfObstacles = gameRef.numberOfObstacles - 1;
    }
    if(other is BulletLeft){
      destroy = true;
      gameRef.numberOfObstacles = gameRef.numberOfObstacles - 1;
    }
    if(other is BulletRight){
      destroy = true;
      gameRef.numberOfObstacles = gameRef.numberOfObstacles - 1;
    }
  }

  /// Create Body
  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = position
      ..angularVelocity = 2
      //..linearVelocity = Vector2((random.nextInt(50+50)-50), (random.nextInt(50+50)-50))
      ..gravityOverride = Vector2(0, 0.02)

   ..userData = this;

    final brickBody = world.createBody(bodyDef);

    /// Shape with default values
    final shape = CircleShape()..radius = gameRef.size.x /22;

    /// Create Fixture
    brickBody.createFixture(
      FixtureDef(shape)
       ..density = 50
       ..friction = 0.5
       ..userData = this
        ..restitution = 0.7,
    );

    return brickBody;
  }

}