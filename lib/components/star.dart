import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:initial_project/components/paddle.dart';
import '../forge2d_game_world.dart';
import 'dead_zone.dart';

class Star extends BodyComponent<BrickBreakGame> with ContactCallbacks{

  final Vector2 size;
  final Vector2 position;
  //final PositionComponent starComponent;

  //Star({required this.position, required this.starComponent, required this.size});
  Star({required this.position, required this.size});

  bool destroy = false;

  @override
  Future<void> onLoad() async{
    await super.onLoad();
   final sprite = await gameRef.loadSprite('stars/star1.png');
    renderBody = false;

    add(SpriteComponent(sprite: sprite, size: Vector2(size.x, size.y), anchor: Anchor.center));
 }

  @override
  Future<void> update(double dt) async {
  super.update(dt);
  }

  @override
  void beginContact(Object other, Contact contact){

    if (other is Paddle){
      destroy = true;
      gameRef.currentGameLevelStars = gameRef.currentGameLevelStars + 1;
    }
    if(other is DeadZone){
      print('STAR IN DEATH ZONE');
      destroy = true;
    }
  }

  /// Create Body
  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = position
      ..userData = this
      ..angularVelocity = 3
      ..gravityOverride = Vector2(0, 4)
      ..linearDamping = 1.0;

    final brickBody = world.createBody(bodyDef);

    /// Shape with default values
    final shape = PolygonShape()
      ..setAsBox(

        2.5,
        2.5,
        Vector2(0.0, 0.0),
        0.0,
      );

    /// Create Fixture
    brickBody.createFixture(
      FixtureDef(shape)
        ..density = 1
        ..friction = 0.2
        ..userData = this
        ..isSensor = true
        ..restitution = 0.8,
    );

    return brickBody;
  }

    Future<void> resetStar() async {
      print('STAR RESET');
      removeFromParent();
    }

}