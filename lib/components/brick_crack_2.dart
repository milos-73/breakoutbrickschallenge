import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:initial_project/components/bullet_right.dart';
import 'package:initial_project/components/bullet_through.dart';
import '../forge2d_game_world.dart';
import 'ball.dart';
import 'ball2.dart';
import 'bullet_left.dart';

/// Class
class BrickCracked2 extends BodyComponent<BrickBreakGame> with ContactCallbacks {
  final Size size;
  final Vector2 position;
  final String spriteName;

  /// Constructor
  BrickCracked2({
    required this.size,
    required this.position,
    required this.spriteName,
    super.priority = 3
  });

  var destroy = false;


  dynamic explosion;
  // dynamic brickBreakAnim1;
  // dynamic brickBreakAnim2;
  ObjectState state = ObjectState.normal;


  @override
  Future<void> onLoad() async{
    await super.onLoad();
    final sprite = await gameRef.loadSprite('bricks3/cracked1b.png');
    renderBody = false;
    add(SpriteComponent(sprite: sprite, size: Vector2(size.width, size.height), anchor: Anchor.center));


    // final   brickBreak1 = await gameRef.loadSprite('bricks3/green2.png');
    // final   brickBreak2 = await gameRef.loadSprite('bricks3/orange3.png');

    final exp1 = await gameRef.loadSprite('explosion/explosion1.png');
    final exp2 = await gameRef.loadSprite('explosion/explosion2.png');
    final exp3 = await gameRef.loadSprite('explosion/explosion3.png');
    final exp4 = await gameRef.loadSprite('explosion/explosion4.png');
    final exp5 = await gameRef.loadSprite('explosion/explosion5.png');
    final exp6 = await gameRef.loadSprite('explosion/explosion6.png');
    final exp7 = await gameRef.loadSprite('explosion/explosion7.png');
    final exp8 = await gameRef.loadSprite('explosion/explosion8.png');
    final exp9 = await gameRef.loadSprite('explosion/explosion9.png');
    final exp10 = await gameRef.loadSprite('explosion/explosion10.png');
    final exp11 = await gameRef.loadSprite('explosion/explosion11.png');
    final exp12 = await gameRef.loadSprite('explosion/explosion12.png');
    final exp13 = await gameRef.loadSprite('explosion/explosion13.png');
    final exp14 = await gameRef.loadSprite('explosion/explosion14.png');
    final exp15 = await gameRef.loadSprite('explosion/explosion15.png');
    final exp16 = await gameRef.loadSprite('explosion/explosion16.png');
    final exp17 = await gameRef.loadSprite('explosion/explosion17.png');
    final exp18 = await gameRef.loadSprite('explosion/explosion18.png');
    final exp19 = await gameRef.loadSprite('explosion/explosion19.png');

    // brickBreakAnim1 = SpriteAnimation.spriteList([brickBreak1], stepTime: 0.05,loop: false);
    // brickBreakAnim2 = SpriteAnimation.spriteList([brickBreak2], stepTime: 0.05,loop: false);

    explosion = SpriteAnimation.spriteList([
      exp1,
      exp2,
      exp3,
      exp4,
      exp5,
      exp6,
      exp7,
      exp8,
      exp9,
      exp10,
      exp11,
      exp12,
      exp13,
      exp14,
      exp15,
      exp16,
      exp17,
      exp18,
      exp19
    ], stepTime: 0.05, loop: false);
  }

  @override
  void beginContact(Object other, Contact contact){

    // if (other is Ball){
    //   //body.applyForce(body.linearVelocity*1000);
    //   print('BRICK TO Ball CONTACT');
    //   destroy = true;
    // }

    if (other is BulletThrough){
      if(state == ObjectState.normal){
        state = ObjectState.explode;
        gameRef.add(SpriteAnimationComponent(position: body.position, animation: explosion.clone(), anchor: Anchor.center, size: Vector2(size.width+2, size.height+2),removeOnFinish: true));}
      destroy = true;
    }

    if (other is Ball){
      state = ObjectState.explode; gameRef.add(SpriteAnimationComponent(position: body.position, animation: explosion.clone(), anchor: Anchor.center, size: Vector2(size.width + 2, size.height + 2), removeOnFinish: true));
      destroy = true;

     }


    if (other is Ball2){

      if(state == ObjectState.normal){state = ObjectState.explode;
      gameRef.add(SpriteAnimationComponent(position: body.position, animation: explosion.clone(), anchor: Anchor.center, size: Vector2(size.width+2, size.height+2),removeOnFinish: true));}
      //body.applyForce(body.linearVelocity*1000);
      //print('BRICK TO Ball CONTACT');
      destroy = true;
    }

    if (other is BulletLeft){
      if(state == ObjectState.normal){state = ObjectState.explode;

      gameRef.add(SpriteAnimationComponent(position: body.position, animation: explosion.clone(), anchor: Anchor.center, size: Vector2(size.width+4, size.height+4),removeOnFinish: true));}
      //body.applyForce(body.linearVelocity*1000);
      print('BRICK TO BULLET CONTACT');
      destroy = true;
    }

    if (other is BulletRight){
      if(state == ObjectState.normal){state = ObjectState.explode;

      gameRef.add(SpriteAnimationComponent(position: body.position, animation: explosion.clone(), anchor: Anchor.center, size: Vector2(size.width+4, size.height+4),removeOnFinish: true));}
      print('BRICK TO BULLET CONTACT');
      destroy = true;
    }
  }

  @override
  void endContact(Object other,Contact contact){
  }

  /// Create Body
  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.static
      ..position = position
      ..angularDamping = 1.0
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
        ..density = 100
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


    canvas.drawRect(
        Rect.fromCenter(
          center: rectangle.centroid.toOffset(),
          width: size.width,
          height: size.height,
        ),
        paint);
  }

}