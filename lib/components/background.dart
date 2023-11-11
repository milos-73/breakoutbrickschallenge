import 'dart:ui';
import 'package:flame/components.dart';

class Backyard extends SpriteComponent with HasGameRef{

  Backyard() : super(priority: 0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load('bg/test25.png');
    final background = SpriteComponent(sprite: sprite, size:gameRef.size);
    add(background);


  }

  @override
  void render(Canvas c) {
    super.render(c);
    return;
  }

}