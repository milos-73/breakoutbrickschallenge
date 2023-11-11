import 'package:flame/components.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../forge2d_game_world.dart';
import 'brick2.dart';
import 'hud_bar.dart';

class BulletThrough extends BodyComponent<BrickBreakGame> with ContactCallbacks {

  final Vector2 size;
  final Vector2 position;

  /// Constructor
  BulletThrough({
    required this.size,
    required this.position,
    super.priority = 2,
  });

  var destroy = false;

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    final sprite = await gameRef.loadSprite('bullets/bullet2.png');
    renderBody = false;
    add(SpriteComponent(sprite: sprite, size: size, anchor: Anchor.center));
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
    if (other is Brick2){
      print('BRICK TO Bullet CONTACT');
      destroy = true;
      }
    // if (other is Obstacle1){
    //   print('BRICK TO Bullet CONTACT');
    //   destroy = true;
    // }
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
      ..position = position
      ..linearVelocity = Vector2(0, -40)
    //..gravityOverride = Vector2(0, 4)
      //..angularVelocity = 4
    ;

    final bulletThrough = world.createBody(bodyDef);

    /// Shape with default values
    final shape = PolygonShape()
      ..setAsBox(

        size.x / 2.0,
        size.y / 2.0,
        Vector2(0.0, 0.0),
        0.0,
      );

    /// Create Fixture
    bulletThrough.createFixture(
      FixtureDef(shape)
        ..density = 1000
        ..isSensor = true
        ..userData = this
        ..restitution = 0.0,
    );
    return bulletThrough;
  }
}