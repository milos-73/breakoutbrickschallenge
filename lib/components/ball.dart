import 'dart:math';

import 'package:flame/components.dart';

import 'package:flame_forge2d/flame_forge2d.dart' hide Particle;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:initial_project/components/paddle.dart';


import '../forge2d_game_world.dart';
import 'ball_sticky.dart';
import 'brick.dart';
import 'brick2.dart';

// 1
class Ball extends BodyComponent<BrickBreakGame> with ContactCallbacks{
  // 2
  Vector2 position;
  double radius;

  Ball (this.position, {this.radius = 0.7, super.priority = 4});

  late TimerComponent slow;
  late TimerComponent bonusTime;
  late final StickyBall stickyBall;

  final random = Random();
  final Tween<double> noise = Tween(begin: -1, end: 1);

  int count = 0;
  int count2 = 0;

    final _gradient = RadialGradient(
    center: Alignment.topLeft,
    colors: [
      const HSLColor.fromAHSL(1.0, 0.0, 0.0, 1.0).toColor(),
      const HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.9).toColor(),
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
      //..gravityOverride = Vector2(0, 3)
      ..angularVelocity = 2.0
      ..position = position;

    // 5
    final ball = world.createBody(bodyDef);

    // 6
    final shape = CircleShape()..radius = radius;

    // 7
    final fixtureDef = FixtureDef(shape)
    ..restitution = 0.8
      ..density = 0.8;
    // 8
    ball.createFixture(fixtureDef);
    return ball;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

  }

  @override
  void update(double dt) {
        super.update(dt);
        //ToDO gameRef.particleState = ParticleState.on; ???
        if(gameRef.ballStatus == BallStatus.reset){body.applyLinearImpulse(Vector2(gameRef.size.x * 9, - gameRef.size.y * 60));gameRef.ballStatus = BallStatus.normal; gameRef.particleState = ParticleState.on;}
    if(gameRef.ballStatus == BallStatus.newBall){body.linearVelocity = Vector2(0, -9) * 30;}
    if(gameRef.ballStatus == BallStatus.inAir){body.linearVelocity = Vector2(gameRef.ball2Velocity.x,-9) * 30;}
    if(gameRef.fastBonus == 0 || gameRef.slowBonus == 0){body.linearVelocity.length = 45;}
    if(gameRef.slowBonus == 1 && gameRef.fastBonus == 0){body.linearVelocity.length = 30;}
    if(gameRef.fastBonus == 1 && gameRef.slowBonus == 0){body.linearVelocity.length = 55;}

    if(gameRef.powerBallBonus == 1 && gameRef.cannonBallStatus == 1){

      body.fixtures[0].setSensor(true);body.linearVelocity.length = 43;
      if(body.position.x > game.size.x-1.3 || body.position.x < 1.3 || body.position.y < 15 || body.position.y > game.size.y - 20 ){body.fixtures[0].setSensor(false);body.setBullet(true);body.linearVelocity.length = 40;}

    } else{body.fixtures[0].setSensor(false);}

  }

  @override
  void beginContact(Object other, Contact contact) {
    if(gameRef.powerBallBonus == 1){
      if(other is Brick2){gameRef.cannonBallStatus = 0;}
      if(other is Brick){gameRef.cannonBallStatus = 1;}
    }

    if(gameRef.stickyBallBonus == 1){

      if(other is Paddle){
        gameRef.particleState = ParticleState.off;
        gameRef.stickyBallState = StickyBallState.on;
        body.linearDamping = 5000;
        body.linearVelocity.length = 0;

        print('LOCAL POINT BEGIN: ${body.localPoint(contact.bodyA.position)}');
        gameRef.stickyBallPosition = body.localPoint(contact.bodyA.position);
        gameRef.stickyBallOn = 1;
        gameRef.ball2On = 0;
        removeFromParent();
        gameRef.stickyBallState = StickyBallState.start;
      }
    }
  }

  @override
  void preSolve(Object other, Contact contact, Manifold oldManifold){
    if(gameRef.powerBallBonus == 1){
      if(other is Brick2){gameRef.cannonBallStatus = 0;}
      if(other is Brick){gameRef.cannonBallStatus = 1;}
    }
    if(gameRef.stickyBallBonus == 1){

      if(other is Paddle) {
        print(
            'LOCAL POINT PRESOLVE: ${body.localPoint(contact.bodyA.position)}');
      }}
  }

  @override
  void postSolve(Object other, Contact contact, ContactImpulse impulse,){
    if(gameRef.stickyBallBonus == 1){

      if(other is Paddle) {
        print('LOCAL POINT POSTSOLVE: ${body.localPoint(
            contact.bodyA.position)}');
      }}
  }

  @override
  void endContact(Object other, Contact contact){
    if(gameRef.stickyBallBonus == 1){

      if(other is Paddle) {
        gameRef.stickyBallEndPosition = body.localPoint(contact.bodyA.position);
        print('LOCAL POINT END: ${body.localPoint(contact.bodyA.position)}');
      }}
      }

    void reset() {
    body.setTransform(Vector2(18, 67), angle);
   //body.angularVelocity = 4.0;
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
    //gameRef.stickyBallState = StickyBallState.inProgress;
    gameRef.paddle.remove(stickyBall);
   }

}