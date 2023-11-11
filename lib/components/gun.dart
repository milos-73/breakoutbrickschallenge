import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:initial_project/forge2d_game_world.dart';

class Gun extends BodyComponent<BrickBreakGame> {

  final Vector2 size;
  final Vector2 position;

  /// Constructor
  Gun({
    required this.size,
    required this.position,
    super.priority = 4,
  });

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    print('POSITION X: ${gameRef.paddle.body.position.x}');
    //final sprite = await gameRef.loadSprite('paddles/gun1.png');
    final sprite = await gameRef.loadSprite('paddles/gun2.png');
    renderBody = false;
    add(SpriteComponent(sprite: sprite, size: size, anchor: Anchor.center,));
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = position;
     // ..gravityOverride = Vector2(0, 4)
    //..userData = this
     // ..linearDamping = 1.0;

    final brickBody = world.createBody(bodyDef);

    /// Shape with default values
    final shape = PolygonShape()
      ..setAsBox(2,2,Vector2(0.0, 0.0), 0.0,);

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
  void reset() {
    removeAll(children);
  }


}