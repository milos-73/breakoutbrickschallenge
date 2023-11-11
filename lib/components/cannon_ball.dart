import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import '../forge2d_game_world.dart';
import 'bullet_through.dart';
import 'gun.dart';

class CannonBall extends Component with HasGameRef<BrickBreakGame> {
  CannonBall() : super(priority: 2);

  TimerComponent? bullet;

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  Future<void> update(double dt) async {
    for (final child in [... children]){
      if (child is BulletThrough && child.destroy){
        for ( final fixture in [...child.body.fixtures]){
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
      }
    }
    super.update(dt);
  }

  Future<void>getCannonBallTimer()async {
    int countDown = 0;
    print('****Cannon Ball*****');
    bullet = TimerComponent(period: 2, repeat: false, removeOnFinish: true,autoStart: true, onTick:() {
      countDown++; if(countDown == 8){gameRef.gunState = GunState.off; bullet?.timer.stop();countDown=0;remove(bullet!);}
      getBulletThrough();
    });
    add(bullet!);
  }

  Future<void>getBulletThrough()async {
print('------- GET CANNON BALL -------');
if (game.audioSettings == AudioSettings.on) {
  await FlameAudio.play('cannon.mp3');
}
    BulletThrough bulletThrough = BulletThrough(position: Vector2(gameRef.paddle.body.position.x, gameRef.paddle.body.position.y), size:Vector2(1.3,3.5));
    await add(bulletThrough);
  }

  Future<void> resetCannonBall() async {
    gameRef.gun?.removeFromParent();
    removeAll(children);
  }

}