import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:initial_project/components/gun.dart';
import 'package:initial_project/components/star.dart';
import '../forge2d_game_world.dart';
import 'package:flame/input.dart';

import 'ball.dart';
import 'dead_zone.dart';

class Paddle extends BodyComponent<BrickBreakGame> with Draggable, ContactCallbacks {
  final Size size;
  final Vector2 position;
  final BodyComponent ground;

  Paddle({
    required this.size,
    required this.position,
    required this.ground
  });

  MouseJoint? _mouseJoint;
  Vector2 dragStartPosition = Vector2.zero();
  Vector2 dragAccumlativePosition = Vector2.zero();
  
  List ballSound = ['plop1.mp3','plop2.mp3','plop3.mp3'];

  @override
  bool debugMode = false;

  @override
  Future<void> onLoad() async{
    await super.onLoad();

    final sprite = await gameRef.loadSprite('paddles/paddle1_red.png');
    renderBody = false;
    add(SpriteComponent(sprite: sprite, size: Vector2(size.width, size.height), anchor: Anchor.center));
    //add(Gun(position: Vector2(0,0), size: Vector2(5, 5)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    //if(gameRef.bullet == 1){addGun();}
    //if(gameRef.bullet == 1){parent?.add(Gun()..priority=4);}
    //if(gameRef.bullet == 0){parent?.remove(Gun()..priority=4);}
    // print('BULLET: ${gameRef.bullet}');
    // print('PADDLE POSITION: ${body.position}');
      }


  @override
  bool onDragStart(DragStartInfo info) {
    if (_mouseJoint != null) {
      return true;
    }
    dragStartPosition = info.eventPosition.game;
    _setupDragControls();

    // Don't continue passing the event.
    return false;
  }

  // 2
  @override
  bool onDragUpdate(DragUpdateInfo info) {
    dragAccumlativePosition += info.delta.game;
    if ((dragAccumlativePosition - dragStartPosition).length > 0.1) {
      _mouseJoint?.setTarget(dragAccumlativePosition);
      dragStartPosition = dragAccumlativePosition;
    }

    // Don't continue passing the event.
    return false;
  }

  // 3
  @override
  bool onDragEnd(DragEndInfo info) {
    _resetDragControls();

    // Don't continue passing the event.
    return false;
  }

  // 4
  @override
  bool onDragCancel() {
    _resetDragControls();

    // Don't continue passing the event.
    return false;
  }

  @override
  void beginContact(Object other, Contact contact){

    //print('PADDLE OTHER: ${other}');
    if (other is Star){
//print('POSITIONTYPE: ${other.runtimeType}');
      if (game.audioSettings == AudioSettings.on)  {
       FlameAudio.play('collectCoin1.mp3');
      }
      other.removeFromParent();

      //gameRef.levelPoints = gameRef.levelPoints + finalPoint;

    }

    if(other is DeadZone){ 
      other.removeFromParent();
    }
  }

  @override
  void preSolve(Object other, Contact contact, Manifold oldManifold){
    if(other is Ball){
      print('ballSound[Random().nextInt(3)]: ${ballSound[Random().nextInt(3)]}');
      if (game.audioSettings == AudioSettings.on)  {
      FlameAudio.play(ballSound[Random().nextInt(2)]);}
    }
  }

  // 5
  void _setupDragControls() {
    final mouseJointDef = MouseJointDef()
      ..bodyA = ground.body
      ..bodyB = body
      ..frequencyHz = 5.0
      ..dampingRatio = 0.9
      ..collideConnected = false
      ..target.setFrom(body.position)
      ..maxForce = 2000.0 * body.mass;

    _mouseJoint = MouseJoint(mouseJointDef);
    world.createJoint(_mouseJoint!);
  }

  // 6
  // Clear the drag position accumulator and remove the mouse joint.
  void _resetDragControls() {
    dragAccumlativePosition = Vector2.zero();
    if (_mouseJoint != null) {
      world.destroyJoint(_mouseJoint!);
      _mouseJoint = null;
    }
  }

  void reset() {
    body.setTransform(position, angle);
    body.angularVelocity = 0.0;
    body.linearVelocity = Vector2.zero();

  }

  void resetGun() {

    for (final child in [... children]){
      if (child is Gun ){
        for ( final fixture in [...child.body.fixtures]){
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final shape = body.fixtures.first.shape as PolygonShape;

    final paint = Paint()
      ..color = const Color.fromARGB(255, 80, 80, 228)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
        Rect.fromLTRB(
          shape.vertices[0].x,
          shape.vertices[0].y,
          shape.vertices[2].x,
          shape.vertices[2].y,
        ),
        paint);
  }

  @override
  void onMount() {
    super.onMount();

    // 1
    final worldAxis = Vector2(1.0, 0.0);

    // 2
    final travelExtent = (gameRef.size.x / 2) - (size.width / 2.0);

    // 3
    final jointDef = PrismaticJointDef()
      ..enableLimit = true
      ..lowerTranslation = -travelExtent
      ..upperTranslation = travelExtent
      ..collideConnected = true;

    // 4
    jointDef.initialize(body, ground.body, body.worldCenter, worldAxis);
    final joint = PrismaticJoint(jointDef);
    world.createJoint(joint);
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = position
      ..fixedRotation = true
      ..angularDamping = 1.0
      ..linearDamping = 10.0;

    final paddleBody = world.createBody(bodyDef);

    final shape = PolygonShape()
      ..setAsBox(
        size.width / 2.0,
        size.height / 2.0,
        Vector2(0.0, 0.0),
        0.0,
      );

    paddleBody.createFixture(FixtureDef(shape)
      ..density = 100.0
      ..friction = 0.0
      ..userData = this
      ..restitution = 1.0);

    return paddleBody;
  }

  Future<void>addGun() async {
    add (TimerComponent(period: 1, repeat: false, removeOnFinish: true,onTick:() {add(Gun(position: Vector2(body.position.x, body.position.y), size: Vector2(5, 5)));}));
  }

}