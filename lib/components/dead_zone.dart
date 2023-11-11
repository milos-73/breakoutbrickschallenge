

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../forge2d_game_world.dart';
import 'ball.dart';
import 'ball2.dart';

// 1
class DeadZone extends BodyComponent<BrickBreakGame> with ContactCallbacks, Tappable {
  final Size size;
  final Vector2 position;

  DeadZone({
    required this.size,
    required this.position,
  });

  int levelPointsTop = 0;
  int? currentLevelNumber;

  @override
  bool get renderBody => false;


  @override
  Body createBody() {
    final bodyDef = BodyDef()

      ..type = BodyType.static
      ..userData = this
      ..position = position;

    final zoneBody = world.createBody(bodyDef);

    final shape = PolygonShape()
      ..setAsBox(
        size.width,
        size.height,
        Vector2.zero(),
        0.0,
      );

    // 2
    zoneBody.createFixture(FixtureDef(shape)..isSensor = true);

    return zoneBody;
  }

  void setLives(int resetLives){
    gameRef.life = resetLives;
    //print('RESETED LIVES: ${resetLives}');
    //print('Reseted Lives $lives');
  }

  // 3
  @override
  void beginContact(Object other, Contact contact) {

    //print('GAMErEF LIVE: ${gameRef.life}');
    //print('LIVE: ${gameRef.life}');
    //print(gameRef.life);

    if(other is Ball && gameRef.life >= 0){
      gameRef.particleState = ParticleState.off;
      //print('LOST LIVE');
      if (gameRef.life > 0) {
        if (game.audioSettings == AudioSettings.on) {
        FlameAudio.play('lostBall1.mp3');}
      }
      gameRef.life = gameRef.life - 1;

      //gameRef.obstacles.resetObstacle();
      gameRef.particleState = ParticleState.off;
      gameRef.ballState = BallState.lost;
      if (gameRef.overlays.isActive('PostGame')){gameRef.overlays.remove('PostGame');}
      gameRef.gameState = GameState.restart;
    }

    if (other is Ball && gameRef.life < 0) {
      //print('LOST GAME');
      gameRef.particleState = ParticleState.off;

      if (game.audioSettings == AudioSettings.on)  {
       FlameAudio.play('gameOver.mp3');}
      gameRef.life = 3;

      if(gameRef.gameMode == GameMode.challenge){
        levelPointsTop = gameRef.prefs.getInt('topLevelPoints$currentLevelNumber') ?? 0;
        if (levelPointsTop < gameRef.levelPoints) {
          gameRef.prefs.setInt('topLevelPoints$currentLevelNumber', gameRef.levelPoints);
        }
        gameRef.totalPointsInCurrentGame = 0;
        gameRef.levelPoints = 0;
        gameRef.gameState = GameState.challengeLost;
      }
      if(gameRef.gameMode == GameMode.levels){
        gameRef.currentGameLevelStars = 0;
        gameRef.gameState = GameState.lost;
      }
    }

    if(other is Ball2 && gameRef.life >= 0){
      //print('LOST LIVE');
      if (gameRef.life > 0) {
        if (game.audioSettings == AudioSettings.on)  {
        FlameAudio.play('lostBall1.mp3');}
      }
      gameRef.life = gameRef.life - 1;
      gameRef.particleState = ParticleState.off;
      //gameRef.obstacles.resetObstacle();
      gameRef.ballState = BallState.lost;
      if (gameRef.overlays.isActive('PostGame')){gameRef.overlays.remove('PostGame');}
      gameRef.gameState = GameState.restart;
    }

    if (other is Ball2 && gameRef.life < 0) {
      //print('LOST GAME');
      if (game.audioSettings == AudioSettings.on)  {
      FlameAudio.play('gameOver.mp3');}
      gameRef.life = 3;
      gameRef.particleState = ParticleState.off;
      if(gameRef.gameMode == GameMode.challenge){
        levelPointsTop = gameRef.prefs.getInt('topLevelPoints$currentLevelNumber') ?? 0;
        if (levelPointsTop < gameRef.levelPoints) {
          gameRef.prefs.setInt('topLevelPoints$currentLevelNumber', gameRef.levelPoints);
        }
        gameRef.totalPointsInCurrentGame = 0;
        gameRef.levelPoints = 0;
        gameRef.gameState = GameState.challengeLost;
      }
      if(gameRef.gameMode == GameMode.levels){
        gameRef.currentGameLevelStars = 0;
        gameRef.gameState = GameState.lost;
      }

    }
  }

  @override
  bool onTapUp(TapUpInfo info) {


    return false;
  }

  @override
  bool onLongTapDown(TapDownInfo info) {

    if(gameRef.stickyBallState == StickyBallState.inProgress){

      // print('PADDLE POSITION: ${gameRef.paddle.body.position.x}');
      // print('PADDLE SIZE:: ${gameRef.paddle.size}');
      // print('BALL2 POSITION: ${gameRef.stickyBall?.body.position}');

      gameRef.removeStickyBall();
      gameRef.stickyBallOn = 0;
      gameRef.ball2On = 1;
      gameRef.addBall2(Vector2(gameRef.paddle.body.position.x + gameRef.stickyBallPosition.x,-1.5));
      gameRef.stickyBallState = StickyBallState.inProgress2;
    }
    return true;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    print('gameRef.paddle.position: ${gameRef.paddle.position}');
    if (game.audioSettings == AudioSettings.on) {
      FlameAudio.play('bottomTap.mp3');
    }
    gameRef.particleState = ParticleState.on;

    if (gameRef.gameState == GameState.ready) {
      if(gameRef.overlays.isActive('PreGame')){gameRef.overlays.remove('PreGame');}

      if(gameRef.life == 3){gameRef.life = gameRef.life - 1;}

      gameRef.ball.body.applyLinearImpulse(Vector2(gameRef.size.x * 9, - gameRef.size.y * 60));
     gameRef.gameState = GameState.running;
       }
    if (gameRef.gameState == GameState.restart){

             gameRef.cannonBall?.resetCannonBall();
             gameRef.bullets?.resetAllBullets();
             gameRef.obstacles.resetObstacle();
             gameRef.fallingBonus.resetFallingBonus();

             if(gameRef.gameMode == GameMode.challenge)
             {gameRef.fallingPoints?.resetFallingPoints();}

             if(gameRef.gameMode == GameMode.levels){
             gameRef.fallingStars?.resetFallingStars();}
             gameRef.resetBall();
             gameRef.gameState = GameState.running;

           }
    return true;
  }

  @override
  bool onTapCancel() {



    //print("tap cancel");
   return false;
  }


}