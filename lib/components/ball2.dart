import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:initial_project/components/paddle.dart';

import '../forge2d_game_world.dart';
import 'ball_sticky.dart';

// 1
class Ball2 extends BodyComponent<BrickBreakGame> with ContactCallbacks{
  // 2
  final Vector2 position;
  final double radius;


  Ball2(this.position,{required this.radius, super.priority = 3});

  late TimerComponent slow;
  late TimerComponent bonusTime;

  late final StickyBall stickyBall;

  int count = 0;
  int count2 = 0;
  var destroy = false;


  @override
  Future<void> onLoad() async{
    await super.onLoad();
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
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
      ..linearVelocity = Vector2(0, -40)
    //..gravityOverride = Vector2(0, 3)
      ..angularVelocity = 4.0
      ..position = position!;

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

  @override
  void beginContact(Object other, Contact contact) {
    if(other is Paddle){

      if(gameRef.stickyBallBonus == 1 && gameRef.stickyBallState == StickyBallState.inProgress2){
        body.linearDamping = 5000;
        body.linearVelocity.length = 0;
        gameRef.ball2On = 0;
        gameRef.stickyBallOn = 1;
        removeFromParent();

        gameRef.stickyBallPosition = body.localPoint(contact.bodyA.position);
        gameRef.stickyBallState = StickyBallState.newBall;
      }
    }
  }

  @override
  void preSolve(Object other, Contact contact, Manifold oldManifold){
         }

  @override
  void postSolve(Object other, Contact contact, ContactImpulse impulse,){
     }

  @override
  void endContact(Object other, Contact contact){
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



}