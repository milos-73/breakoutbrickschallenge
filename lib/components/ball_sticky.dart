import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:initial_project/components/paddle.dart';

import '../forge2d_game_world.dart';
import 'brick.dart';
import 'brick2.dart';

// 1
class StickyBall extends BodyComponent<BrickBreakGame> with ContactCallbacks{
  // 2
  final Vector2 position;
  final double radius;

  StickyBall(this.position, {this.radius = 0.7, super.priority = 4});

  late TimerComponent slow;
  late TimerComponent bonusTime;
  int count = 0;
  int count2 = 0;

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    //final sprite = await gameRef.loadSprite('bullets/bulletL1.png');
    //renderBody = false;
    //add(SpriteComponent(sprite: sprite, size: Vector2.all(radius), anchor: Anchor.center, position: position));
  }

  @override
  Future<void> update(double dt) async {

    //print('BALL 2 VELOCITY: ${body.linearVelocity.length}');if(gameRef.fastBonus == 0 || gameRef.slowBonus == 0){body.linearVelocity.length = 40;}
    super.update(dt);
  }

  @override
  void beginContact(Object other, Contact contact){
  }

  final _gradient = RadialGradient(
    center: Alignment.topLeft,
    colors: [
      const HSLColor.fromAHSL(0.7, 0.57, 1, 0.5).toColor(),
      const HSLColor.fromAHSL(1.0, 0.6, 1, 0.6).toColor(),
      const HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.4).toColor(),
    ],
    stops: const [0.0, 0.5, 1.0],
    radius: 0.95,
  );


  // 3
  @override
  Body createBody() {
    // 4
    final bodyDef = BodyDef()
      ..allowSleep = true
      ..type = BodyType.dynamic
      ..userData = this
      ..bullet = true
     ..linearVelocity = Vector2.zero()
    //..gravityOverride = Vector2(0, 3)
      ..angularVelocity = 4.0
      ..position = position;

    // 5
    final ball2 = world.createBody(bodyDef);

    // 6
    final shape = CircleShape()..radius = radius;

    // 7
    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.8
      ..isSensor = false
      ..density = 0.8;

    // 8
    ball2.createFixture(fixtureDef);
    return ball2;
  }

  void reset() {

    body.setTransform(position, angle);
    body.angularVelocity = 4.0;
    body.linearVelocity = Vector2.zero();
  }

  //1
  @override
  void render(Canvas canvas) {

    // 2
    final circle = body.fixtures.first.shape as CircleShape;

    // 3
    final paint = Paint()
      ..shader = _gradient.createShader(Rect.fromCircle(
        center: circle.position.toOffset(),
        radius: radius,
      ))
      ..style = PaintingStyle.fill;

    // 4
    canvas.drawCircle(circle.position.toOffset(), radius, paint);
  }

  Future<void> removeStickyBall() async {
    removeFromParent();
  }

}