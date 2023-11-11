import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:initial_project/components/bullet_left.dart';
import 'package:initial_project/components/bullet_right.dart';
import 'package:initial_project/components/star.dart';
import 'package:initial_project/forge2d_game_world.dart';

import 'gun.dart';

class Bullets extends Component with HasGameRef<BrickBreakGame> {
  Bullets() : super(priority: 2);

  TimerComponent? bullet;
  //TimerComponent? gun;


  //int countDown2 = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    }

  @override
  Future<void> update(double dt) async {
    for (final child in [... children]){
      if (child is BulletLeft && child.destroy){
        for ( final fixture in [...child.body.fixtures]){
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
      }
      if (child is BulletRight && child.destroy){
        for ( final fixture in [...child.body.fixtures]){
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
      }
    }
    super.update(dt);
  }

Future<void>getBulletsTimer()async {
     int countDown = 0;
     bullet = TimerComponent(period: 0.5, repeat: true, removeOnFinish: true,autoStart: true, onTick:() {
     countDown++; if(countDown == 8){gameRef.gunState = GunState.off; bullet?.timer.stop(); countDown=0; remove(bullet!);}
     getBullets();
    });

  await add(bullet!);
}

Future<void>getBullets()async {
  if (game.audioSettings == AudioSettings.on) {
    await FlameAudio.play('bullet.mp3');
  }
  BulletLeft bulletLeft = BulletLeft(position: Vector2(gameRef.paddle.body.position.x-2.5, gameRef.paddle.body.position.y), radius: 0.8);
  BulletRight bulletRight = BulletRight(position: Vector2(gameRef.paddle.body.position.x+2.5, gameRef.paddle.body.position.y), radius: 0.8);

  await add(bulletLeft);
  await add(bulletRight);
}

  Future<void> resetAllBullets() async {
    gameRef.gun?.removeFromParent();
    removeAll(children);
  }

}
