import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:brickbreaker/components/star.dart';
import 'package:brickbreaker/forge2d_game_world.dart';

class FallingStars extends Component with HasGameRef<BrickBreakGame> {
  FallingStars() : super(priority: 6);

  @override
  Future<void> onLoad() async {
    super.onLoad();
     }

  @override
  Future<void> update(double dt) async {

    for (final child in [... children]){
      if (child is Star && child.destroy ){
        for ( final fixture in [...child.body.fixtures]){
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
      }
    }
    super.update(dt);
  }

  Future<void> getStar() async {

   double vectorX = (Random().nextInt(30)+5).toDouble();
   double vectorY = (Random().nextInt(30)+10).toDouble();

    if(gameRef.gameState == GameState.running){

      Star star = Star(size: Vector2(2,2), position: Vector2(vectorX, vectorY));
      add(star);
    }
  }

  Future<void> resetFallingStars() async {
    removeAll(children);
     }
}
