import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import '../forge2d_game_world.dart';

/// Class
class HudBarLevels extends BodyComponent<BrickBreakGame> with ContactCallbacks, TapCallbacks{

  HudBarLevels({
    super.children,
    super.priority = 3,
  });

  @override
  Future<void> onLoad() async{
    await super.onLoad();
    final sprite = await gameRef.loadSprite('bg/topBar.png');
    renderBody = false;
    add(SpriteComponent(sprite: sprite, size: Vector2(36, 10), anchor: Anchor.centerLeft));
  }

  /// Create Body
  @override
  Body createBody() {;
  final bodyDef = BodyDef()
    ..type = BodyType.static
    ..position = Vector2(0, 10);

  final brickBody = world.createBody(bodyDef);

  /// Shape with default values
  final shape = PolygonShape()
    ..setAsBox(
      80,
      3,
      Vector2(0.0, 0.0),
      0.0,
    );

  /// Create Fixture
  brickBody.createFixture(
    FixtureDef(shape)
      ..density = 100.0
      ..friction = 0.0
      ..userData = this
      ..restitution = 0.1,
  );

  return brickBody;
  }

  Future<void> resetHudBarStars() async {
    print('RESET HUD BAR STARS');
    removeFromParent();
    final sprite = await gameRef.loadSprite('bg/topBar.png');
    renderBody = false;
    add(SpriteComponent(sprite: sprite, size: Vector2(36, 10), anchor: Anchor.centerLeft));
  }
}