import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:initial_project/components/star.dart';
import 'package:initial_project/forge2d_game_world.dart';

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

    print('gameRef.gameState: ${gameRef.gameState}');
    print('vectorX: ${vectorX}');
    print('vectorY: ${vectorY}');

    if(gameRef.gameState == GameState.running){
      print('---- ....STAR SHOULD BE ADDEDE... ----');

      Star star = Star(size: Vector2(2,2), position: Vector2(vectorX, vectorY));
      add(star);
    }
  }

  Future<void> resetFallingStars() async {
    removeAll(children);
     }
}


// class FallingStars extends Component with HasGameRef<BrickBreakGame> {
//
//   late TimerComponent starsTimer;
//   int elapseTics = 0;
//   late TimerComponent starPeriod;
//
//   int count = 0;
//
//   dynamic fallingStar;
//   StarState state = StarState.normal;
//
// //List zoznam = [Brick(size: null, position: null, spriteName: ''), Ball(position: null, radius: null)];
//
//   @override
//   Future<void> onLoad() async {
//     super.onLoad();
//     starsTimer = TimerComponent(period: 4,removeOnFinish: true, repeat: true,onTick: (){elapseTics += 1;getStar();});
//     //print('ELAPSE TIME: $elapseTics');
//     add(starsTimer);
//
//     final exp1 = await gameRef.loadSprite('stars/star1.png');
//     final exp2 = await gameRef.loadSprite('stars/star2.png');
//     final exp3 = await gameRef.loadSprite('stars/star3.png');
//     final exp4 = await gameRef.loadSprite('stars/star4.png');
//     final exp5 = await gameRef.loadSprite('stars/star5.png');
//     final exp6 = await gameRef.loadSprite('stars/star6.png');
//
//
//     fallingStar = SpriteAnimation.spriteList([
//       exp1,
//       exp2,
//       exp3,
//       exp4,
//       exp5,
//       exp6,
//     ], stepTime: 0.1, loop: true);
//       }
//
//   @override
//   Future<void> update(double dt) async {
//
//     for (final child in [... children]){
//       print('OTHER FROM FALLING STARS OBJECT:${child}');
//       print('START STATE FALLING STARS OBJECT:${gameRef.starState}');
//       if (child is Star && gameRef.starState == StarState.remove ){
//         print('DESTROY STAR: ${child.destroy}');
//         for ( final fixture in [...child.body.fixtures]){
//           print('DESTROY STAR FROM FALLING STAR: ${child.destroy}');
//           child.body.destroyFixture(fixture);
//         }
//         gameRef.world.destroyBody(child.body);
//         gameRef.starState = StarState.normal;
//         remove(child);
//         print('STAR REMOVED');
//       }
//     }
//     super.update(dt);
//   }
//
//   Future<void>getStar()async {
//
//     final starPosition = Vector2((Random().nextInt(30)+5).toDouble(), (Random().nextInt(30)+10).toDouble());
//     final animationComponent = SpriteAnimationComponent(position:starPosition, animation: fallingStar.clone(), anchor: Anchor.center, size: Vector2(0.7,0.7),);
//
//    // state = StarState.falling;
//
//     Star star = Star(position: starPosition, starComponent: animationComponent, size: Vector2(1,1));
//
//     if(gameRef.gameState == GameState.running){add(star..priority = 3);}
//   }
//
//   Future<void> resetFallingPoints() async {
//
//     starsTimer.removeFromParent();
//     //gameRef.ticks = 1;
//
//     removeAll(children);
//     elapseTics = 0;
//     starsTimer = TimerComponent(period: 4,removeOnFinish: true, repeat: true,onTick: (){elapseTics += 1;getStar();});
//     add(starsTimer);
//   }
//
// }

// class FallingStars extends Component with HasGameRef<BrickBreakGame> {
//
//   TimerComponent? starsTimer;
//   int elapseTics = 0;
//   TimerComponent? starPeriod;
//
//   int count = 0;
//
//   dynamic fallingStar;
//   StarState state = StarState.normal;
//
// //List zoznam = [Brick(size: null, position: null, spriteName: ''), Ball(position: null, radius: null)];
//
//   @override
//   Future<void> onLoad() async {
//     super.onLoad();
//     starsTimer = TimerComponent(period: 15, removeOnFinish: true, repeat: true, onTick: (){elapseTics += 1; if (elapseTics <= 5) {getStar();}});
//     add(starsTimer!);
//   }
//
//   @override
//   Future<void> update(double dt) async {
//
//     for (final child in [... children]){
//       if (child is Star && child.destroy ){
//         for ( final fixture in [...child.body.fixtures]){
//           child.body.destroyFixture(fixture);
//         }
//         gameRef.world.destroyBody(child.body);
//         remove(child);
//       }
//     }
//     super.update(dt);
//   }
//
//   Future<void>getStar()async {
//
//     //final starPosition = Vector2((Random().nextInt(30)+5).toDouble(), (Random().nextInt(30)+10).toDouble());
//     //final animationComponent = SpriteAnimationComponent(position:starPosition, animation: fallingStar.clone(), anchor: Anchor.center, size: Vector2(0.7,0.7),);
//
//     // state = StarState.falling;
//     double vectorX = (Random().nextInt(30)+5).toDouble();
//     double vectorY = (Random().nextInt(30)+10).toDouble();
//
//     Star star = Star(size: Vector2(2,2), position: Vector2(vectorX, vectorY));
//
//     if(gameRef.gameState == GameState.running){add(star..priority = 3);}
//   }
//
//   Future<void> resetFallingStars() async {
//
//     starsTimer?.removeFromParent();
//     //gameRef.ticks = 1;
//
//     removeAll(children);
//     elapseTics = 0;
//     starsTimer = TimerComponent(period: 15,removeOnFinish: true, repeat: true,onTick: (){elapseTics += 1; if(elapseTics <= 5) {getStar();}});
//     add(starsTimer!);
//   }
//
// }
