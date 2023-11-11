import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:initial_project/components/paddle.dart';
import '../forge2d_game_world.dart';
import 'dead_zone.dart';

class BonusSlow extends BodyComponent<BrickBreakGame> with ContactCallbacks{

  final Size size;
  final Vector2 position;

  BonusSlow({required this.size, required this.position});

  bool destroy = false;

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    final sprite = await gameRef.loadSprite('bonus/bonus2.png');
    renderBody = false;
    add(SpriteComponent(sprite: sprite, size: Vector2(size.width, size.height), anchor: Anchor.center));
  }

  @override
  void beginContact(Object other, Contact contact){
    if (other is Paddle){
      if (game.audioSettings == AudioSettings.on) {
        FlameAudio.play('bonus.mp3');
      }
      destroy = true;
      gameRef.slowBonus = 1;
      gameRef.fastBonus = 0;

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