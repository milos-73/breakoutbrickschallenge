import 'package:flame/components.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:initial_project/components/brick.dart';
import 'package:initial_project/components/hud_bar.dart';
import 'package:initial_project/components/obstacle.dart';

import '../forge2d_game_world.dart';

class BulletLeft extends BodyComponent<BrickBreakGame> with ContactCallbacks {

  final double? radius;
  final Vector2? position;

  /// Constructor
  BulletLeft({
    required this.radius,
required this.position,
    super.priority = 2,
  });

  var destroy = false;

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    final sprite = await gameRef.loadSprite('bullets/bulletL1.png');
    renderBody = false;
    add(SpriteComponent(sprite: sprite, size: Vector2.all(radius!), anchor: Anchor.center));
    }

  @override
  Future<void> update(double dt) async {
    //print('BULLET POSITION: ${body.position}');
    if(body.position.y < -60){removeFromParent();}
    if(destroy){removeFromParent();}
        super.update(dt);
  }


  @override
  void beginContact(Object other, Contact contact){
    if (other is Brick){
      print('BRICK TO Bullet CONTACT');
      destroy = true;
      }
    if (other is Obstacle1){
      print('BRICK TO Bullet CONTACT');
      destroy = true;
    }
    if (other is HudBar){
      print('BRICK TO Bullet CONTACT');
      destroy = true;
    }

  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..allowSleep = true
      ..type = BodyType.dynamic
      //..userData = this
      ..bullet = true
     ..position = position!
      ..linearVelocity = Vector2(0, -45)
      //..gravityOverride = Vector2(0, 4)
      ..angularVelocity = 4
    ;

    final bulletLeft = world.createBody(bodyDef);

    /// Shape with default values
    final shape = CircleShape()..radius = radius!;

    /// Create Fixture
    bulletLeft.createFixture(
      FixtureDef(shape)
        ..density = 0.2
        ..isSensor = true
        ..userData = this
        ..restitution = 0.1,
    );
    return bulletLeft;
  }

  Future<void> resetBulletLeft() async {
    print('STAR RESET');
    removeAll(children);
  }

  }