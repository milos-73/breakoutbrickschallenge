import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import '../components/ball.dart';
import '../forge2d_game_world.dart';

// 1
class BrickBackup extends BodyComponent<BrickBreakGame> with ContactCallbacks {
  final Size size;
  final Vector2 position;
  final Color color;

  // 2
  BrickBackup({
    required this.size,
    required this.position,
    required this.color
  });

  var destroy = false;


  @override
  Future<void> onLoad() async{
    await super.onLoad();
    final sprite = await gameRef.loadSprite('bricks/_0009_Red.png');
    renderBody = false;
    add(SpriteComponent(sprite: sprite, size: Vector2(size.width, size.height), anchor: Anchor.center));
  }

  @override
  void beginContact(Object other, Contact contact){
    if (other is Ball){
      destroy = true;
    }
  }

  // 3
  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.static
      ..position = position
      ..angularDamping = 1.0
      ..linearDamping = 1.0;


    final brickBody = world.createBody(bodyDef);

    // 4
    final shape = PolygonShape()
      ..setAsBox(

        size.width / 2.0,
        size.height / 2.0,
        Vector2(0.0, 0.0),
        0.0,
      );

    // 5
    brickBody.createFixture(
      FixtureDef(shape)
        ..density = 100.0
        ..friction = 0.0
        ..userData = this
        ..restitution = 0.1,
    );

    return brickBody;
  }
  @override
  void render(Canvas canvas) {
    if (body.fixtures.isEmpty) {
      return;
    }

    final rectangle = body.fixtures.first.shape as PolygonShape;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1

      ..style = PaintingStyle.fill;

    canvas.drawRect(
        Rect.fromCenter(
          center: rectangle.centroid.toOffset(),
          width: size.width,
          height: size.height,
        ),
        paint);
  }

}