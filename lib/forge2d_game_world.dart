import 'dart:math';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart' hide Particle;
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:brickbreaker/components/cannon_ball.dart';
import 'package:brickbreaker/components/falling_bonus.dart';
import 'package:brickbreaker/components/falling_points.dart';
import 'package:brickbreaker/components/paralax_background.dart';
import 'package:brickbreaker/components/stars_status.dart';
import 'package:brickbreaker/components/total_stars_hud.dart';
import 'package:brickbreaker/services/saved_values.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:username_gen/username_gen.dart';
import 'components/google_play_game_services.dart';
import 'components/level_number_challenge.dart';
import 'components/arena.dart';
import 'components/back_to_menu_button.dart';
import 'components/ball.dart';
import 'components/ball2.dart';
import 'components/ball_sticky.dart';
import 'components/bottom_bar.dart';
import 'components/brick_wall.dart';
import 'components/bullets.dart';
import 'components/falling_stars.dart';
import 'components/gun.dart';
import 'components/hud_bar.dart';
import 'components/level_number.dart';
import 'components/life_counter.dart';
import 'components/obstacles.dart';
import 'components/paddle.dart';
import 'components/dead_zone.dart';
import 'components/pause_button.dart';
import 'components/points_current_game.dart';
import 'components/points_level.dart';
import 'components/points_level_top.dart';
import 'components/points_total.dart';
import 'components/stars_level_total.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'components/walls_2.dart';


enum ConnectionStatus {
  offline,
  online,
  singInError
}

enum WallStatus {
  inBuild,
  ready
}

enum PauseButtonState {
  on,
  ballLost,
  startGame,
  gameRunning,
  off
}

enum BallState {
  inGame,
  lost
}

enum SyncStatus {
  off,
  ok,
  error
}

enum AudioSettings{
  off,
  on
}

enum ParticleState{
  off,
  on
}

enum AllLevelsStarsSync{
  off,
  upload,
  download
}

enum GameState {
  initializing,
  ready,
  running,
  paused,
  won,
  restart,
  lost,
  challengeNextLevel,
  challengeLost,
  preGamePaused,
}

enum GameMode {
  initializing,
  levels,
  challenge
}

enum BallStatus{
  newBall,
  alreadyCreated,
  inAir,
  reset,
  normal
}

enum BrickState{
  normal,
  crack1,
  crack2,
}

enum ObjectState {
  normal,
  breaking1,
  breaking2,
  explode,
}
enum StarState {
  normal,
  falling,
  remove
}


enum GunState {
  off,
  on,
  inProgress,
  through
}

enum StickyBallState{
  on,
  start,
  timerOff,
  inProgress,
  inProgress2,
  newBall,
  off
}

class BrickBreakGame extends Forge2DGame with HasDraggables, HasTappables, MultiTouchDragDetector {
@override
Color backgroundColor() =>  const Color(0x00FF9000);

  BrickBreakGame() : super(gravity: Vector2.zero(),zoom: 30,);

BannerAd? _bannerAd;
bool _bannerAdIsLoaded = false;

  late Ball ball;
  Ball2? ball2;
  StickyBall? stickyBall;

  late final Background background; ///Game component
  late final Arena arena; ///Game component
  late final Paddle paddle; ///Game component
  late final DeadZone deadZone; ///Game component
  late final BrickWall brickWall; //Game component
  late final HudBar hudBar; ///Game component
  HudBar? hudBarLevels; ///Game component
  HudBar? hudBarChallenge; //Game component
  late final Obstacles obstacles; ///Game component
  late final FallingBonus fallingBonus; ///Game component
  FallingStars? fallingStars; ///Game component
  FallingPoints? fallingPoints; ///Game component
  Bullets? bullets; ///Game component
  CannonBall? cannonBall; ///Game component
  late TimerComponent interval; ///Time component
  TimerComponent? bullet; ///Time component
  TimerComponent? gun; ///Time component

  TotalPointCounter? totalPointCounter; ///Game component
  TotalStarsCounter? totalStarsCounter; ///Game component

  late final SharedPreferences prefs; /// system

  GameState gameState = GameState.initializing; ///component state
  StickyBallState stickyBallState = StickyBallState.off; ///component state
  BallStatus ballStatus = BallStatus.alreadyCreated; ///component state
  WallStatus wallStatus = WallStatus.inBuild;
  ConnectionStatus connectionStatus = ConnectionStatus.offline;

  StarState starState = StarState.normal; ///component state
  GameMode gameMode = GameMode.initializing; ///component state
  ParticleState particleState = ParticleState.off; ///component state
  AudioSettings audioSettings = AudioSettings.on; ///component state
  SyncStatus syncStatus = SyncStatus.off; ///component state
  BallState ballState = BallState.inGame; //component state
  PauseButtonState pauseButtonState = PauseButtonState.off; ///component state

  int life = 3; ///initial lives per game for LIFE COUNTER

  int? lastFinishedLevel; ///number of LAST FINISHED level | Levels mode
  int  currentPlayedLevelNumber = 1; ///number of CURRENTLY PLAYED Level

  int numberOfObstacles = 0; ///initial number of OBSTACLES | obstacles.dart TIMER
  int numberOfBrickHits = 0; ///initial value used to count number of BRICKS in the played WALL
  int starInterval = 0; /// initial value used to count interval time of stars based on number of BRICKS in the WALL
  int numberOfBrickHitsLeft = 0; ///initial value used to count number of BRICKS in the played WALL left for plaing

  int fastBonus = 0; ///initial vale used for visibility of the BONUS
  int slowBonus = 0; ///initial vale used for visibility of the BONUS
  int cannonBallStatus = 0; ///initial vale used for visibility of the BONUS
  int powerBallBonus = 0; ///initial vale used for visibility of the BONUS
  int stickyBallBonus = 0; ///initial vale used for visibility of the BONUS
  GunState gunState = GunState.off; ///component state
  int ticks = 1; ///used in TIMER fow FALLING BONUS
  int countDown = 0; ///used in TIMER fow FALLING BONUS | initial value
  int countDown2 = 0; ///used in TIMER fow FALLING BONUS | initial value
  int countDown3 = 0; ///used in TIMER fow FALLING BONUS | initial value

  int levelPoints = 0; ///initial value for points in finished level of CHALLENGE MODE game used for comparing and counting FINAL game POINTS
  int levelPointTop = 0; ///holds the previous TOP POINTS for currently played CHALLENGE MODE level
  int totalGamePoints = 0; ///holds the previous TOP POINTS for CHALLENGE MODE game | all finished levels in one row
  int totalPointsInCurrentGame = 0; ///holds the FINAL POINTS for currently played CHALLENGE MODE game | all finished levels in one row

  int levelStars = 0; ///initial value for number of previously collected STARS in currently played LEVEL
  int currentGameLevelStars = 0; ///initial value for number of collected STARS in currently played LEVEL
  int? totalStars; ///hold the number of all collected STARS

  int? fiveStarsLevels = 0; ///holds the value for number of 5* LEVELS
  int challengeLevelsPerGame = 0; ///holds the TOP number of CHALLENGE MODE game LEVELS played in one row

  int? totalStarsPoints; ///holds the TOTAL points for collected STARS
  int  currentGameLevelStarsPoints = 0; ///holds points for collected STARS in currently played LEVEL

  int challengeCurrentLevel = 1; ///initial value for number of RANDOM CHALLENGE MODE wall

  Vector2 stickyBallPosition = Vector2(0, 0); ///used for STICKY BALL component
  Vector2 stickyBallEndPosition = Vector2(0, 0); ///used for STICKY BALL component
  Vector2 ball2Position = Vector2(0, 0); ///used for STICKY BALL component
  Vector2 ball2Velocity = Vector2(0, 0); ///used for STICKY BALL component
  int stickyBallOn = 0; ///used for STICKY BALL component
  int ball2On = 0; ///used for STICKY BALL component

Vector2 ballPosition = Vector2(18, 60);
Vector2 position = Vector2(0, 0);
MouseJoint? mouseJoint;

Random random = Random();
GooglePlayGameServices googlePlayGameServices = GooglePlayGameServices();
SavedValues savedValues = SavedValues();

final Tween<double> noise = Tween(begin: -1, end: 1);

int breakedBricksCounter = 0; //initial value for counting BREAKED BRICKS in current LEVEL or CHALLENGE mode game
int allTimeStarsCollected = 0; //initial value for counting Collected STARS in current LEVEL or CHALLENGE mode game
int allTimePointsCounter = 0; //initial value for ALL TIME POINTS counter

//*** ********** ************************ ************ ***
//                        TO-DO
// *** ********** ************************ ************ ***
int gamesInRowCounter = 0;
//int challengeFinishedLevel = 0;
//int starPoints = 0; //initial value for ALL TIME STARS points
// int? challengeLevels = 0; //?????

@override
  Future<void> onLoad() async {

    super.onLoad();

    googlePlayGameServices.signIn();
    //await googlePlayGameServices.signInMain();

   await FlameAudio.audioCache.loadAll(['plop1.mp3','collectCoin1.mp3','plop2.mp3','plop3.mp3','brick1.mp3','brick2.mp3','brick3.mp3','brickNoBreak.mp3','levelUp1.mp3','gameOver.mp3', 'lostBall1.mp3', 'gameOver.mp3','button3.mp3','levelSelection.mp3','bottomTap.mp3','wrong1.mp3','cannon.mp3','bullet.mp3','bonus.mp3','positiveNumber.mp3','negativeNumber.mp3']);

    prefs = await SharedPreferences.getInstance();

    camera.viewport = FixedResolutionViewport(Vector2(1080,2340));

    await Flame.device.fullScreen();
    await Flame.device.setPortrait();

    lastFinishedLevel = prefs.getInt('lastFinishedLevel') ?? 0;
    totalGamePoints = prefs.getInt('totalGamePoints') ?? 0;
    totalStars = prefs.getInt('totalStars') ?? 0;
    totalStarsPoints = prefs.getInt('totalStarsPoints') ?? 0;

    fiveStarsLevels = prefs.getInt('fiveStarsLevels') ?? 0;
    //challengeLevels = prefs.getInt('challengeLevels') ?? 0;

       await _initializeGame();
    }

   List particleLife = [0.04,0.08 ,0.1, 0.12, 0.18, 0.22, 0.26,0.3];

  @override
  void update(double dt) {
    super.update(dt);
    //print('${wallStatus}');

    //print('NUMBER OF BRICK HITS: ${numberOfBrickHits}');
   //print('NUMBER OF BRICK HITS LEFT:${numberOfBrickHitsLeft}');

    //print('allTimePointsCounter: ${allTimePointsCounter}');
    //print('totalPointsInCurrentGame: ${totalPointsInCurrentGame}');
    //print('levelPoints: ${levelPoints}');

   // print('counterGame: ${counterGame}');
    //print('totalPointsInCurrentGame: ${totalPointsInCurrentGame}');
    //print('pointsCounter: ${pointsCounter}');
    //print('currentPlayedLevelNumber: ${currentPlayedLevelNumber}');

    if (particleState == ParticleState.on && stickyBallState == StickyBallState.off){
    add(ParticleSystemComponent(
        position: Vector2(ball.body.position.x, ball.body.position.y),
        particle: Particle.generate(
          lifespan: particleLife[Random().nextInt(8)],
            count:5,
            generator: (i) {
              return AcceleratedParticle(

                  speed: Vector2(noise.transform(random.nextDouble()),
                    noise.transform(random.nextDouble()),)*i.toDouble(),
                  child: CircleParticle(
                      radius: 0.2,
                      paint: Paint()..color = Color.lerp(Colors.white, Colors.green, Random().nextDouble())!,));
            }
        )
    ));}

    if((gameMode == GameMode.levels) && (wallStatus == WallStatus.ready)){
     // print('+++++++++numberOfBrickHits+++++++++++: ${numberOfBrickHits}');
      //print('+++++++++numberOfBrickHitsLeft+++++++++: ${numberOfBrickHitsLeft}');

    if ((numberOfBrickHits == numberOfBrickHitsLeft) && (numberOfBrickHits > starInterval-1)){

      //print('****numberOfBrickHits***: ${numberOfBrickHits}');
      //print('****numberOfBrickHitsLeft****:${numberOfBrickHitsLeft}');
      //print('starInterval:${starInterval}');
      //print('EQUAL NUMBERS for STAR to be ADDED ');
        fallingStars?.getStar();
        numberOfBrickHitsLeft = numberOfBrickHitsLeft - starInterval;
      }

    if(numberOfBrickHits < numberOfBrickHitsLeft){
      // print('******************numberOfBrickHits******************${numberOfBrickHits}');
      // print('******************numberOfBrickHitsLeft******************${numberOfBrickHitsLeft}');
      // print('******************PROBLEM WITH BRICKS NUMBER*******************');
      if ((numberOfBrickHitsLeft - starInterval) > 0) {
        //print('>0');
        fallingStars?.getStar();
        numberOfBrickHitsLeft = numberOfBrickHitsLeft - starInterval;
      }else{numberOfBrickHitsLeft = numberOfBrickHitsLeft;
        //print('EQUAL');
      }
    }}


    if(stickyBallState == StickyBallState.start){addStickyBall(); stickyBallState = StickyBallState.inProgress;}
    if(stickyBallState == StickyBallState.newBall){addStickyBall(); stickyBallState = StickyBallState.inProgress;}

    if (gunState == GunState.on) {gunState = GunState.inProgress; addGuns(); bullets?.getBulletsTimer();}
    if (gunState == GunState.through) {gunState = GunState.inProgress; addCannon(); cannonBall?.getCannonBallTimer();}

    if(ballStatus == BallStatus.newBall){ball.body.linearVelocity.length = 30;ballStatus = BallStatus.alreadyCreated;}
    if(ballStatus == BallStatus.inAir){ball.body.linearVelocity.length = 30;ballStatus = BallStatus.alreadyCreated;}

    if (gameState == GameState.restart) {
      pauseEngine();
      overlays.add('LostLife');
    }
    if (gameState == GameState.lost) {
      pauseEngine();

      overlays.add('PostGame');
    }
    if (gameState == GameState.won) {
      pauseEngine();
      currentGameLevelStars = 0;
      overlays.add('WinGame');
    }
    if (gameState == GameState.challengeNextLevel) {
      pauseEngine();
      randomChallengeWallNumber();
      updatePointsCounter();
      overlays.add('NextLevelChallengeModeOverlay');
    }
    if (gameState == GameState.challengeLost) {
      pauseEngine();
      overlays.add('ChallengeGameOverOverlay');
    }
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateInfo info) {
    position = info.eventPosition.game;
    super.onDragUpdate(pointerId, info);

    final mouseJointDef = MouseJointDef()
      ..maxForce = 3000 * paddle.body.mass * 10
      ..dampingRatio = 0.1
      ..frequencyHz = 5
      ..target.setFrom(paddle.body.position)
      ..collideConnected = false
      ..bodyA = arena.body
      ..bodyB = paddle.body;

    if (mouseJoint == null) {
      mouseJoint = MouseJoint(mouseJointDef);
      world.createJoint(mouseJoint!);
    }
    mouseJoint?.setTarget(info.eventPosition.game);
    return false;
  }

  @override
  bool onDragEnd(int pointerId, DragEndInfo info) {
    super.onDragEnd(pointerId, info);
    if (mouseJoint == null) {
      return true;

    }
    world.destroyJoint(mouseJoint!);
    mouseJoint = null;
    if(stickyBallState == StickyBallState.on){
    stickyBallState = StickyBallState.inProgress;}

    return false;
  }

  Future<void> resetLocalGameData() async {

    int? numberOfLevels = prefs.getInt('lastFinishedLevel') ?? 0;

    if (numberOfLevels > 0) {
      for (var i = 1; i < numberOfLevels + 1; i++ ){
        await prefs.remove('numberOfStars$i');
        await prefs.remove('starsPoints$i');

      }
    }

    await prefs.remove('starsPerLevelInString');
    await prefs.remove('lastFinishedLevel');
    await prefs.remove('totalGamePoints');
    await prefs.remove('totalStars');
    await prefs.remove('totalStarsPoints');
    await prefs.remove('currentPlayedLevelNumber');
    await prefs.remove('levelInProgress');
    await prefs.remove('totalStarsPoints');
    await prefs.remove('counter');

    levelPoints = 0;
    levelPointTop = 0;
    totalPointsInCurrentGame = 0;
    totalGamePoints = 0;

    levelStars = 0;
    currentGameLevelStars = 0;
    currentGameLevelStarsPoints = 0;
    totalStars;
    totalStarsPoints;

    life = 3;
    lastFinishedLevel;
    //lastFinishedLevelDb;
    currentPlayedLevelNumber = 1;

  }

  Future<void> _initializeGame() async {

     ///HUD BAR and BUTTONS

    hudBar = HudBar();
    add(hudBar);
    //hudBarChallenge = HudBar(children: [LifeCounter(), TotalPointInCurrentGame(), TotalPointCounter(), LevelPointCounter(), LevelPointTopCounter()]);
    hudBarChallenge = HudBar(children: [TotalPointInCurrentGame(), LevelPointCounter(), LevelNumberChallenge(), LevelPointTopCounter()]);
    hudBarLevels = HudBar(children: [LevelNumber(), StarsLevelTotal(), StarsStatusPerLevel()]);
    //hudBarLevels = HudBar(children: [StarsStatusPerLevel(), StarsLevelTotal()]);
    //hudBarLevels = HudBar(children: [LifeCounter(), StarsStatusPerLevel(), StarsLevelTotal()]);

    add(BackToMenuButton());
    add(PauseButton());

    add(LifeCounter()..priority = 6);
    //add(TotalPointCounter()..priority = 6);

    totalPointCounter = TotalPointCounter()..priority = 6;
    totalStarsCounter = TotalStarsCounter()..priority = 6;

    ///BOTTOM BAR
    add(BottomBar());

    // bannerAdComponent = BannerAdComponent();
    // add(bannerAdComponent);

    ///OBSTACLES
    obstacles = Obstacles();
    await add(obstacles);

    ///BONUS
    fallingBonus = FallingBonus();
    print('FALLING BONUS to be added');
    await add(fallingBonus);

    ///POINTS
    fallingPoints = FallingPoints();
    //await add(fallingPoints!);

    ///STARS
    fallingStars = FallingStars();
      //await add(fallingStars!);

     bullets = Bullets();
     await add(bullets!);

     cannonBall = CannonBall();
     await add(cannonBall!);

    ///DEATh ZONE
    final deadZoneSize = Size(size.x, size.y * 0.08);
    final deadZonePosition = Vector2(
      size.x / 2,
      size.y - (size.y * 0.05)/2
    );

   deadZone = DeadZone(
      size: deadZoneSize,
      position: deadZonePosition,
    );
    await add(deadZone);

    ///ARENA
    arena = Arena();
    await add(arena);

    final brickWallPosition = Vector2(0.0, size.y * 0.075);

    ///WALL
    brickWall = BrickWall(levelNumber: currentPlayedLevelNumber, position: brickWallPosition);
    await add(brickWall..priority = 2);

    ///PADDLE
    const paddleSize = Size(7,1.3);
    final paddlePosition = Vector2(
      size.x / 2.0,
      size.y - deadZoneSize.height - (paddleSize.height + (paddleSize.height*1.2)),
    );

    paddle = Paddle(
      ground: arena,
      size: paddleSize,
      position: paddlePosition,
    );
    await add(paddle..priority=3);

    ///BALL
    //final ballPosition = Vector2(size.x / 2.0, paddlePosition.y - 2*(paddleSize.height) );

    ball = Ball(
      ballPosition,
      radius: 0.7,
    );
    await add(ball);

    // bulletLeft = BulletLeft(position: Vector2(paddle.body.position.x-2.5, paddle.body.position.y), radius: 0.8);
    // bulletRight = BulletRight(position: Vector2(paddle.body.position.x+2.5, paddle.body.position.y), radius: 0.8);

    ///BACKGROUND
    background = Background();
    await add(background..priority = -1);

    FlutterNativeSplash.remove();

     gameState = GameState.ready;

  }

  ///RESET LEVEL
  Future<void> resetGame() async {
    gameState = GameState.initializing;
    wallStatus = WallStatus.inBuild;
    numberOfBrickHitsLeft = 0;
    numberOfBrickHits = 0;
    particleState = ParticleState.off;
    bool? hudBarLevelsMounted = hudBarLevels?.isMounted;
    bool? hudBarChallengeMounted = hudBarChallenge?.isMounted;
    bool? fallingStarsMounted = fallingStars?.isMounted;
    //bool? starMounted = star?.isMounted;
    bool? fallingPointsMounted = fallingPoints?.isMounted;
    bool? totalPointCounterMounted = totalPointCounter?.isMounted;
    bool? starsLevelTotalMounted = totalStarsCounter?.isMounted;
    challengeLevelsPerGame = 0;
    currentPlayedLevelNumber = prefs.getInt('currentPlayedLevelNumber') ?? 0;
    levelPointTop = prefs.getInt('topLevelPoints') ?? 0;
    totalGamePoints = prefs.getInt('totalGamePoints') ?? 0;
    totalStars = prefs.getInt('totalStars') ?? 0;
    totalStarsPoints = prefs.getInt('totalStarsPoints') ?? 0;
    levelStars = prefs.getInt('numberOfStars$currentPlayedLevelNumber') ?? 0;
    lastFinishedLevel = prefs.getInt('lastFinishedLevel') ?? 0;

    //updateBrickBreakedAchievements();

    currentGameLevelStars = 0;
    currentGameLevelStarsPoints = 0;
    totalPointsInCurrentGame = 0;
    levelPoints = 0;

    if(ball2On == 1){
      ball2On = 0;
      ball2?.removeFromParent();
      ball = Ball(Vector2(18,67));
      add(ball);
      ballState = BallState.inGame;
      paddle.reset();
      obstacles.resetObstacle();
      fallingBonus.resetFallingBonus();

      levelPoints = 0;

      if (gameMode == GameMode.challenge) {

        if (fallingStarsMounted == true) {fallingStars?.removeFromParent();}
        if (fallingPointsMounted == true){fallingPoints?.resetFallingPoints();} else {add(fallingPoints!);}

        if (starsLevelTotalMounted == true){totalStarsCounter?.removeFromParent();}
        if (totalPointCounterMounted != true){add(totalPointCounter!);}

        if (hudBarChallengeMounted == true && hudBarLevelsMounted == true ){
          hudBarLevels?.removeFromParent();
        } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == true) {
          hudBarLevels?.removeFromParent();
          await add(hudBarChallenge!);
        } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == false) {
          await add(hudBarChallenge!);
        } else {}
      }

      if (gameMode == GameMode.levels) {

        if (fallingPointsMounted == true){fallingPoints?.removeFromParent();}
        if (fallingStarsMounted == true) {fallingStars?.resetFallingStars();}else{add(fallingStars!);}

        if (totalPointCounterMounted == true){totalPointCounter?.removeFromParent();}
        if (starsLevelTotalMounted != true){add(totalStarsCounter!);}

        if (hudBarLevelsMounted == true && hudBarChallengeMounted == true ){
          hudBarChallenge?.removeFromParent();
        } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == true) {
          hudBarChallenge?.removeFromParent();
          await add(hudBarLevels!);
        } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == false) {
          await add(hudBarLevels!);
        } else {}
      }

      //fallingStars?.resetFallingStars();
      deadZone.setLives(3);
      await brickWall.pickWall(currentPlayedLevelNumber);

      gameState = GameState.ready;
      life = 3;
      levelPoints = 0;
      background.resetBackground();

      overlays.remove(overlays.activeOverlays.first);
      if(overlays.isActive('BannerAdOverlay')){overlays.remove('BannerAdOverlay');}
      await overlays.add('BannerAdOverlay');
      overlays.add('PreGame');
      resumeEngine();

    }
    else if(stickyBallOn == 1){
      stickyBallOn = 0;
      paddle.remove(stickyBall!);
      ball = Ball(Vector2(18,67));
      await add(ball);
      ballState = BallState.inGame;
      paddle.reset();
      obstacles.resetObstacle();
      fallingBonus.resetFallingBonus();

      if (gameMode == GameMode.challenge) {

        if (fallingStarsMounted == true) {fallingStars?.removeFromParent();}
        if (fallingPointsMounted == true){fallingPoints?.resetFallingPoints();} else {add(fallingPoints!);}

        if (starsLevelTotalMounted == true){totalStarsCounter?.removeFromParent();}
        if (totalPointCounterMounted != true){add(totalPointCounter!);}

        if (hudBarChallengeMounted == true && hudBarLevelsMounted == true ){
          hudBarLevels?.removeFromParent();
        } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == true) {
          hudBarLevels?.removeFromParent();
          await add(hudBarChallenge!);
        } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == false) {
          await add(hudBarChallenge!);
        } else {}
      }

      if (gameMode == GameMode.levels) {

        if (fallingPointsMounted == true){fallingPoints?.removeFromParent();}
        if (fallingStarsMounted == true) {fallingStars?.resetFallingStars();}else{add(fallingStars!);}

        if (totalPointCounterMounted == true){totalPointCounter?.removeFromParent();}
        if (starsLevelTotalMounted != true){add(totalStarsCounter!);}

        if (hudBarLevelsMounted == true && hudBarChallengeMounted == true ){
          hudBarChallenge?.removeFromParent();
        } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == true) {
          hudBarChallenge?.removeFromParent();
          await add(hudBarLevels!);
        } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == false) {
          await add(hudBarLevels!);
        } else {}
      }

      //fallingStars?.resetFallingStars();
      deadZone.setLives(3);
      await brickWall.pickWall(currentPlayedLevelNumber);

      gameState = GameState.ready;
      life = 3;
      levelPoints = 0;
      background.resetBackground();

      overlays.remove(overlays.activeOverlays.first);
      if(overlays.isActive('BannerAdOverlay')){overlays.remove('BannerAdOverlay');}
      await overlays.add('BannerAdOverlay');
      overlays.add('PreGame');
      resumeEngine();
    }
    else {
      ball.reset();
      ballState = BallState.inGame;
      paddle.reset();
      obstacles.resetObstacle();
      fallingBonus.resetFallingBonus();

      if (gameMode == GameMode.challenge) {

        if (fallingStarsMounted == true) {fallingStars?.removeFromParent();}
        if (fallingPointsMounted == true){fallingPoints?.resetFallingPoints();} else {add(fallingPoints!);}

        if (starsLevelTotalMounted == true){totalStarsCounter?.removeFromParent();}
        if (totalPointCounterMounted != true){add(totalPointCounter!);}

        if (hudBarChallengeMounted == true && hudBarLevelsMounted == true ){
          hudBarLevels?.removeFromParent();
        } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == true) {
          hudBarLevels?.removeFromParent();
          await add(hudBarChallenge!);
        } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == false) {
          await add(hudBarChallenge!);
        } else {}
      }

      if (gameMode == GameMode.levels) {

        if (fallingPointsMounted == true){fallingPoints?.removeFromParent();}
        if (fallingStarsMounted == true) {fallingStars?.resetFallingStars();}else{add(fallingStars!);}

        if (totalPointCounterMounted == true){totalPointCounter?.removeFromParent();}
        if (starsLevelTotalMounted != true){add(totalStarsCounter!);}

        if (hudBarLevelsMounted == true && hudBarChallengeMounted == true ){
          hudBarChallenge?.removeFromParent();
        } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == true) {
          hudBarChallenge?.removeFromParent();
          await add(hudBarLevels!);
        } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == false) {
          await add(hudBarLevels!);
        } else {}
      }
      //fallingStars?.resetFallingStars();
      deadZone.setLives(3);
      await brickWall.pickWall(currentPlayedLevelNumber);

      gameState = GameState.ready;
      life = 3;
      levelPoints = 0;
      background.resetBackground();


      overlays.remove(overlays.activeOverlays.first);
      if(overlays.isActive('BannerAdOverlay')){overlays.remove('BannerAdOverlay');}
      overlays.add('BannerAdOverlay');
      overlays.add('PreGame');
      resumeEngine();
    }
  }

  ///PICK LEVEL
  Future<void> pickLevel(int level) async {

  gameState = GameState.initializing;
  wallStatus = WallStatus.inBuild;
  numberOfBrickHitsLeft = 0;
  numberOfBrickHits = 0;
  particleState = ParticleState.off;
  bool? hudBarLevelsMounted = hudBarLevels?.isMounted;
  bool? hudBarChallengeMounted = hudBarChallenge?.isMounted;
  bool? fallingStarsMounted = fallingStars?.isMounted;
  bool? fallingPointsMounted = fallingPoints?.isMounted;
  bool? ball2Mounted = ball2?.isMounted;
  bool? totalPointCounterMounted = totalPointCounter?.isMounted;
  bool? starsLevelTotalMounted = totalStarsCounter?.isMounted;

  currentGameLevelStars = 0;
  currentGameLevelStarsPoints = 0;
  totalPointsInCurrentGame = 0;
  levelPoints = 0;
  challengeLevelsPerGame = 0;
  currentPlayedLevelNumber = level;

  levelPointTop = prefs.getInt('topLevelPoints$level') ?? 0;
  totalGamePoints = prefs.getInt('totalGamePoints') ?? 0;
  totalStars = prefs.getInt('totalStars') ?? 0;
  totalStarsPoints = prefs.getInt('totalStarsPoints') ?? 0;
  levelStars = prefs.getInt('numberOfStars$level') ?? 0;
  lastFinishedLevel = prefs.getInt('lastFinishedLevel') ?? 0;

  //updateBrickBreakedAchievements();

  print('levelStars $level ${levelStars}');
  await prefs.setInt('currentPlayedLevelNumber', level);

  if (ball2On == 1) {
    if(overlays.isActive('BannerAdOverlay')){overlays.remove('BannerAdOverlay');}
    await overlays.add('BannerAdOverlay');
    ball2On = 0;
    stickyBallState = StickyBallState.off;
    ball2?.removeFromParent();
    ball = Ball(Vector2(18, 67));
    add(ball);


    ballState = BallState.inGame;
    paddle.reset();
    obstacles.resetObstacle();
    fallingBonus.resetFallingBonus();

    if (gameMode == GameMode.challenge) {

      if (fallingStarsMounted == true) {fallingStars?.removeFromParent();}
      if (fallingPointsMounted == true){fallingPoints?.resetFallingPoints();} else {add(fallingPoints!);}

      if (starsLevelTotalMounted == true){totalStarsCounter?.removeFromParent();}
      if (totalPointCounterMounted != true){add(totalPointCounter!);}

      if (hudBarChallengeMounted == true && hudBarLevelsMounted == true ){
        hudBarLevels?.removeFromParent();
      } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == true) {
        hudBarLevels?.removeFromParent();
        await add(hudBarChallenge!);
      } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == false) {
        await add(hudBarChallenge!);
      } else {}
    }

    if (gameMode == GameMode.levels) {

      if (fallingPointsMounted == true){fallingPoints?.removeFromParent();}
      if (fallingStarsMounted == true) {fallingStars?.resetFallingStars();}else{add(fallingStars!);}

      if (totalPointCounterMounted == true){totalPointCounter?.removeFromParent();}
      if (starsLevelTotalMounted != true){add(totalStarsCounter!);}

      if (hudBarLevelsMounted == true && hudBarChallengeMounted == true ){
        hudBarChallenge?.removeFromParent();
      } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == true) {
        hudBarChallenge?.removeFromParent();
        await add(hudBarLevels!);
      } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == false) {
        await add(hudBarLevels!);
      } else {}
    }

    deadZone.setLives(3);
    await brickWall.pickWall(level);

    gameState = GameState.ready;
    life = 3;
    levelPoints = 0;
    background.resetBackground();

    if(overlays.isActive('MainMenu')){overlays.remove('MainMenu');}
    if(overlays.isActive('PostGame')){overlays.remove('PostGame');}
    overlays.add('PreGame');
    resumeEngine();
  }
  else if (stickyBallOn == 1) {
    if(overlays.isActive('BannerAdOverlay')){overlays.remove('BannerAdOverlay');}
    await overlays.add('BannerAdOverlay');
    stickyBallState = StickyBallState.off;
    stickyBallOn = 0;
    if(ball2Mounted == true){ball2?.removeFromParent();}
    //paddle.remove(stickyBall!);
    stickyBall?.removeFromParent();
    ball = Ball(Vector2(18, 67));
    await add(ball);

      ballState = BallState.inGame;
    paddle.reset();
    obstacles.resetObstacle();
    fallingBonus.resetFallingBonus();

    if (gameMode == GameMode.challenge) {

      if (fallingStarsMounted == true) {fallingStars?.removeFromParent();}
      if (fallingPointsMounted == true){fallingPoints?.resetFallingPoints();} else {add(fallingPoints!);}

      if (starsLevelTotalMounted == true){totalStarsCounter?.removeFromParent();}
      if (totalPointCounterMounted != true){add(totalPointCounter!);}

      if (hudBarChallengeMounted == true && hudBarLevelsMounted == true ){
        hudBarLevels?.removeFromParent();
      } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == true) {
        hudBarLevels?.removeFromParent();
        await add(hudBarChallenge!);
      } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == false) {
        await add(hudBarChallenge!);
      } else {}
    }

    if (gameMode == GameMode.levels) {

      if (fallingPointsMounted == true){fallingPoints?.removeFromParent();}
      if (fallingStarsMounted == true) {fallingStars?.resetFallingStars();}else{add(fallingStars!);}

      if (totalPointCounterMounted == true){totalPointCounter?.removeFromParent();}
      if (starsLevelTotalMounted != true){add(totalStarsCounter!);}

      if (hudBarLevelsMounted == true && hudBarChallengeMounted == true ){
        hudBarChallenge?.removeFromParent();
      } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == true) {
        hudBarChallenge?.removeFromParent();
        await add(hudBarLevels!);
      } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == false) {
        await add(hudBarLevels!);
      } else {}
    }

    deadZone.setLives(3);
    await brickWall.pickWall(level);

    gameState = GameState.ready;
    life = 3;
    levelPoints = 0;
    background.resetBackground();

    if(overlays.isActive('MainMenu')){overlays.remove('MainMenu');}
    if(overlays.isActive('PostGame')){overlays.remove('PostGame');}
    overlays.add('PreGame');
    resumeEngine();
  }
  else {
    if(overlays.isActive('BannerAdOverlay')){overlays.remove('BannerAdOverlay');}
    await overlays.add('BannerAdOverlay');
    ball.reset();
    ballState = BallState.inGame;
    paddle.reset();
    obstacles.resetObstacle();
    fallingBonus.resetFallingBonus();

    if (gameMode == GameMode.challenge) {

      if (fallingStarsMounted == true) {fallingStars?.removeFromParent();}
      if (fallingPointsMounted == true){fallingPoints?.resetFallingPoints();} else {add(fallingPoints!);}

      if (starsLevelTotalMounted == true){totalStarsCounter?.removeFromParent();}
      if (totalPointCounterMounted != true){add(totalPointCounter!);}

      if (hudBarChallengeMounted == true && hudBarLevelsMounted == true ){
        hudBarLevels?.removeFromParent();
      } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == true) {
        hudBarLevels?.removeFromParent();
        await add(hudBarChallenge!);
      } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == false) {
        await add(hudBarChallenge!);
      } else {}
    }

    if (gameMode == GameMode.levels) {

      if (fallingPointsMounted == true){fallingPoints?.removeFromParent();}
      if (fallingStarsMounted == true) {fallingStars?.resetFallingStars();}else{add(fallingStars!);}

      if (totalPointCounterMounted == true){totalPointCounter?.removeFromParent();}
      if (starsLevelTotalMounted != true){add(totalStarsCounter!);}

      if (hudBarLevelsMounted == true && hudBarChallengeMounted == true ){
        hudBarChallenge?.removeFromParent();
      } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == true) {
        hudBarChallenge?.removeFromParent();
        await add(hudBarLevels!);
      } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == false) {
        await add(hudBarLevels!);
      } else {}
    }
    deadZone.setLives(3);
    await brickWall.pickWall(level);

    gameState = GameState.ready;
    life = 3;
    levelPoints = 0;
    background.resetBackground();

    if(overlays.isActive('MainMenu')){overlays.remove('MainMenu');}
    if(overlays.isActive('PostGame')){overlays.remove('PostGame');}
    overlays.add('PreGame');
    resumeEngine();
    }

    //ballStatus = BallStatus.reset;
}

  ///STICKY BALL
  Future<void> addStickyBall() async {
    stickyBall = StickyBall(Vector2(stickyBallPosition.x, -1.5), radius: 0.7);
    paddle.add(stickyBall!);
      }

  Future<void> addBall2(position)async {
    ball2 = Ball2(Vector2(position.x - stickyBallPosition.x, 60), radius: 0.7);
    add(ball2!);
      }

  Future<void> removeStickyBall() async {
    await stickyBall?.removeStickyBall();
  }

  Future<void> stickyBallReplacement()async {
    Vector2 stickyBallCurrentPosition = Vector2(0, 0);
    Vector2 ball2BallCurrentPosition = Vector2(0, 0);

    if (stickyBallOn == 1) {
      stickyBallOn = 0;
      stickyBallCurrentPosition = Vector2(paddle.body.position.x - stickyBallPosition.x,68);
      paddle.remove(stickyBall!);
      ball = Ball(stickyBallCurrentPosition);
      await add(ball);
      stickyBallState = StickyBallState.off;
      ballStatus = BallStatus.newBall;

      }

    if (ball2On == 1){
      ball2On = 0;
      ball2BallCurrentPosition = ball2!.body.position;
      ball2Velocity = ball2!.body.linearVelocity;
      ball2?.removeFromParent();

      ballPosition = ball2BallCurrentPosition;
      ball = Ball(ballPosition);
      await add(ball);

      ballStatus = BallStatus.inAir;
      stickyBallState = StickyBallState.off;
    }
    }

  ///NEXT LEVEL
  Future<void> nextLevel({required int level}) async {

    gameState = GameState.initializing;
    particleState = ParticleState.off;
    bool? hudBarLevelsMounted = hudBarLevels?.isMounted;
    bool? hudBarChallengeMounted = hudBarChallenge?.isMounted;
    bool? fallingStarsMounted = fallingStars?.isMounted;
    bool? fallingPointsMounted = fallingPoints?.isMounted;
    bool? totalPointCounterMounted = totalPointCounter?.isMounted;
    bool? starsLevelTotalMounted = totalStarsCounter?.isMounted;
    currentPlayedLevelNumber = prefs.getInt('currentPlayedLevelNumber') ?? 0;
    totalGamePoints = prefs.getInt('totalGamePoints') ?? 0;
    totalStars = prefs.getInt('totalStars') ?? 0;
    totalStarsPoints = prefs.getInt('totalStarsPoints') ?? 0;
    levelPointTop = prefs.getInt('topLevelPoints$level') ?? 0;
    levelStars = prefs.getInt('numberOfStars$level') ?? 0;
    await prefs.setInt('currentPlayedLevelNumber', currentPlayedLevelNumber + 1);
    lastFinishedLevel = prefs.getInt('lastFinishedLevel') ?? 0;

    //print('$currentPlayedLevelNumber');

    currentGameLevelStars = 0;
    currentGameLevelStarsPoints = 0;
    levelPoints = 0;

    if(ball2On == 1){
      if(overlays.isActive('BannerAdOverlay')){overlays.remove('BannerAdOverlay');}
      overlays.add('BannerAdOverlay');
      ball2On = 0;
      ball2?.removeFromParent();
      ball = Ball(Vector2(18,67));
      add(ball);
      ballState = BallState.inGame;
      paddle.reset();
      obstacles.resetObstacle();
      fallingBonus.resetFallingBonus();

      if (gameMode == GameMode.challenge) {

        if (fallingStarsMounted == true) {fallingStars?.removeFromParent();}
        if (fallingPointsMounted == true){fallingPoints?.resetFallingPoints();} else {add(fallingPoints!);}

        if (starsLevelTotalMounted == true){totalStarsCounter?.removeFromParent();}
        if (totalPointCounterMounted != true){add(totalPointCounter!);}

        if (hudBarChallengeMounted == true && hudBarLevelsMounted == true ){
          hudBarLevels?.removeFromParent();
        } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == true) {
          hudBarLevels?.removeFromParent();
          await add(hudBarChallenge!);
        } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == false) {
          await add(hudBarChallenge!);
        } else {}
      }

      if (gameMode == GameMode.levels) {

        deadZone.setLives(3);

        if (fallingPointsMounted == true){fallingPoints?.removeFromParent();}
        if (fallingStarsMounted == true) {fallingStars?.resetFallingStars();}else{add(fallingStars!);}

        if (totalPointCounterMounted == true){totalPointCounter?.removeFromParent();}
        if (starsLevelTotalMounted != true){add(totalStarsCounter!);}

        if (hudBarLevelsMounted == true && hudBarChallengeMounted == true ){
          hudBarChallenge?.removeFromParent();
        } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == true) {
          hudBarChallenge?.removeFromParent();
          await add(hudBarLevels!);
        } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == false) {
          await add(hudBarLevels!);
        } else {}
      }

      await brickWall.pickWall(currentPlayedLevelNumber + 1);

      gameState = GameState.ready;
      //life = 3;
      levelPoints = 0;
      background.resetBackground();

      overlays.remove(overlays.activeOverlays.first);
      overlays.add('PreGame');
      resumeEngine();
    }
    else if(stickyBallOn == 1){
      if(overlays.isActive('BannerAdOverlay')){overlays.remove('BannerAdOverlay');}
      overlays.add('BannerAdOverlay');
      stickyBallOn = 0;
      paddle.remove(stickyBall!);
      ball = Ball(Vector2(18,67));
      await add(ball);
      ballState = BallState.inGame;
      paddle.reset();
      obstacles.resetObstacle();
      fallingBonus.resetFallingBonus();

      if (gameMode == GameMode.challenge) {

        if (fallingStarsMounted == true) {fallingStars?.removeFromParent();}
        if (fallingPointsMounted == true){fallingPoints?.resetFallingPoints();} else {add(fallingPoints!);}

        if (starsLevelTotalMounted == true){totalStarsCounter?.removeFromParent();}
        if (totalPointCounterMounted != true){add(totalPointCounter!);}

        if (hudBarChallengeMounted == true && hudBarLevelsMounted == true ){
          hudBarLevels?.removeFromParent();
        } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == true) {
          hudBarLevels?.removeFromParent();
          await add(hudBarChallenge!);
        } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == false) {
          await add(hudBarChallenge!);
        } else {}
      }

      if (gameMode == GameMode.levels) {

        deadZone.setLives(3);

        if (fallingPointsMounted == true){fallingPoints?.removeFromParent();}
        if (fallingStarsMounted == true) {fallingStars?.resetFallingStars();}else{add(fallingStars!);}

        if (totalPointCounterMounted == true){totalPointCounter?.removeFromParent();}
        if (starsLevelTotalMounted != true){add(totalStarsCounter!);}

        if (hudBarLevelsMounted == true && hudBarChallengeMounted == true ){
          hudBarChallenge?.removeFromParent();
        } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == true) {
          hudBarChallenge?.removeFromParent();
          await add(hudBarLevels!);
        } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == false) {
          await add(hudBarLevels!);
        } else {}
      }

      await brickWall.pickWall(currentPlayedLevelNumber + 1);

      gameState = GameState.ready;
      //life = 3;
      levelPoints = 0;
      background.removeFromParent();
      await add(background..priority = -1);

      overlays.remove(overlays.activeOverlays.first);
      overlays.add('PreGame');
      resumeEngine();
    }
    else{
      if(overlays.isActive('BannerAdOverlay')){overlays.remove('BannerAdOverlay');}
      overlays.add('BannerAdOverlay');
      ball.reset();
      ballState = BallState.inGame;
      paddle.reset();
      obstacles.resetObstacle();
      fallingBonus.resetFallingBonus();

      if (gameMode == GameMode.challenge) {

        if (fallingStarsMounted == true) {fallingStars?.removeFromParent();}
        if (fallingPointsMounted == true){fallingPoints?.resetFallingPoints();} else {add(fallingPoints!);}

        if (starsLevelTotalMounted == true){totalStarsCounter?.removeFromParent();}
        if (totalPointCounterMounted != true){add(totalPointCounter!);}

        if (hudBarChallengeMounted == true && hudBarLevelsMounted == true ){
          hudBarLevels?.removeFromParent();
        } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == true) {
          hudBarLevels?.removeFromParent();
          await add(hudBarChallenge!);
        } else if (hudBarChallengeMounted == false && hudBarLevelsMounted == false) {
          await add(hudBarChallenge!);
        } else {}
      }

      if (gameMode == GameMode.levels) {

        deadZone.setLives(3);

        if (fallingPointsMounted == true){fallingPoints?.removeFromParent();}
        if (fallingStarsMounted == true) {fallingStars?.resetFallingStars();}else{add(fallingStars!);}

        if (totalPointCounterMounted == true){totalPointCounter?.removeFromParent();}
        if (starsLevelTotalMounted != true){add(totalStarsCounter!);}

        if (hudBarLevelsMounted == true && hudBarChallengeMounted == true ){
          hudBarChallenge?.removeFromParent();
        } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == true) {
          hudBarChallenge?.removeFromParent();
          await add(hudBarLevels!);
        } else if (hudBarLevelsMounted == false && hudBarChallengeMounted == false) {
          await add(hudBarLevels!);
        } else {}
      }

      await brickWall.pickWall(currentPlayedLevelNumber + 1);

      gameState = GameState.ready;
      //life = 3;
      levelPoints = 0;
      background.resetBackground();

      overlays.remove(overlays.activeOverlays.first);
      overlays.add('PreGame');
      resumeEngine();
    }

  }

  ///RESET BALL
  Future<void> resetBall() async {
    gameState = GameState.initializing;

    if(ball2On == 1){
      ball2On = 0;
      ball2?.removeFromParent();
      ball = Ball(Vector2(18,67));
      add(ball);
      paddle.reset();

      gameState = GameState.ready;
      if(overlays.isActive('LostLife')){overlays.remove('LostLife');}
      //overlays.remove(overlays.activeOverlays.first);
      resumeEngine();
      ballStatus = BallStatus.reset;

    }else{
      ball.reset();
      paddle.reset();


      gameState = GameState.ready;

      if(overlays.isActive('LostLife')){overlays.remove('LostLife');}
      //overlays.remove(overlays.activeOverlays.first);
      //overlays.add('PreGame');
      resumeEngine();
      ballState = BallState.inGame;
      ballStatus = BallStatus.reset;
    }
      }

  Future<void>addGuns() async {

    final gun1 = Gun(position: Vector2(-2.5,-1), size: Vector2(1, 1.1));
    final gun2 = Gun(position: Vector2(2.5,-1), size: Vector2(1, 1.1));

    paddle.add(gun1);
    paddle.add(gun2);

    gun = TimerComponent(period: 0.5, repeat: true, removeOnFinish: true,autoStart: true, onTick:() {
      countDown2++;
      if(countDown2 == 10){bullet?.timer.stop();paddle.remove(gun1);paddle.remove(gun2);remove(gun!);countDown2=0;}});

    add(gun!);
    }

Future<void>addCannon() async {

  final gun1 = Gun(position: Vector2(0,-1), size: Vector2(1, 1.1));

  paddle.add(gun1);

  gun = TimerComponent(period: 0.5, repeat: true, removeOnFinish: true,autoStart: true, onTick:() {
    countDown2++;
    if(countDown2 == 10){bullet?.timer.stop();paddle.remove(gun1);remove(gun!);countDown2=0;}});

  add(gun!);
}

Future<void> lostBallReset() async {

  particleState = ParticleState.off;
  cannonBall?.resetCannonBall();
  bullets?.resetAllBullets();
  obstacles.resetObstacle();
  fallingBonus.resetFallingBonus();

  if(gameMode == GameMode.challenge)
  {fallingPoints?.resetFallingPoints();}

  if(gameMode == GameMode.levels){
    fallingStars?.resetFallingStars();}
  resetBall();
  ballState = BallState.inGame;
  if(overlays.isActive('GamePausedMenuOverlay')){overlays.remove('GamePausedMenuOverlay');}
  if(overlays.isActive('LostLife')){overlays.remove('LostLife');}
  gameState = GameState.restart;

}

Future<void> updateAllTimeBreakedBricks() async {
  int? breakedBricks = await prefs.getInt('allTimeBricksCounter') ?? 0;
  await prefs.setInt('allTimeBricksCounter', breakedBricksCounter + breakedBricks);
  // print('breakedBricks FROM UPADATE:${breakedBricks}');
  // print('breakedBricksCounter: ${breakedBricksCounter}');
  await updateBrickBreakedAchievements();
  breakedBricksCounter = 0;
  }

Future <void> updateBrickBreakedAchievements() async {
  int? breakedBricks = await prefs.getInt('allTimeBricksCounter') ?? 0;
  print('allTimeBricksCounter:${breakedBricks}');
  if (breakedBricks >= 50 && breakedBricks < 1000){
    await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQJg'));}
    if (breakedBricks >= 1000 && breakedBricks < 5000){
      await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQEQ'));}
    if (breakedBricks >= 5000 && breakedBricks < 10000){
      await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQEg'));}
    if (breakedBricks >= 10000 && breakedBricks < 20000){
      await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQEw'));}
    if (breakedBricks >= 20000 && breakedBricks < 50000){
      await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQIg'));}
    if (breakedBricks >= 50000 && breakedBricks < 100000){
      await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQIw'));}
    if (breakedBricks >= 100000 && breakedBricks < 200000){
      await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQJA'));}
      //breakedBricksCounter = 0;}
}

  Future<void> updateAllTimeCollectedStars() async {
    int? collectedStars = await prefs.getInt('allTimeCollectedStars') ?? 0;
    await prefs.setInt('allTimeCollectedStars', allTimeStarsCollected + collectedStars);
    print('***allTimeStarsCollected***:${allTimeStarsCollected}');
    allTimeStarsCollected = 0;
    await updateAllTimeCollectedStarsAchievements();

  }

  Future <void> updateAllTimeCollectedStarsAchievements() async {
    int? collectedStars = await prefs.getInt('allTimeCollectedStars') ?? 0;
    print('all time stars:${collectedStars}');
    if (collectedStars >= 10 && collectedStars < 100){
      await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQJQ'));}
    if (collectedStars >= 100 && collectedStars < 500){
      await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQCw'));}
    if (collectedStars >= 500 && collectedStars < 1000){
      await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQDA'));}
    if (collectedStars >= 1000 && collectedStars < 2000){
      await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQDQ'));}
    if (collectedStars >= 2000 && collectedStars < 5000){
      await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQDg'));}
    if (collectedStars >= 5000 && collectedStars < 10000){
      await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQDw'));}
     }

 Future<void> updatePointsCounter() async {
   bool signInStatus = await googlePlayGameServices.getSignInStatus();
    int? collectedPoints = await prefs.getInt('allTimePoints') ?? 0;
    await prefs.setInt('allTimePoints', allTimePointsCounter + collectedPoints);
    allTimePointsCounter = 0;
    if (signInStatus == true && await InternetConnection().hasInternetAccess == true) {
      updateALlTimePointsAchievements();
    }
  }

  Future<void> updateALlTimePointsAchievements() async {
    int? collectedPoints = await prefs.getInt('allTimePoints') ?? 0;
    print('all time Points:${collectedPoints}');
    if (collectedPoints >= 65000 && collectedPoints < 10000){
    await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQGw'));}
    if (collectedPoints >= 10000 && collectedPoints < 20000){
    await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQHA'));}
    if (collectedPoints >= 20000 && collectedPoints < 50000){
    await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQHQ'));}
    if (collectedPoints >= 50000 && collectedPoints < 100000){
    await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQHg'));}
    if (collectedPoints >= 100000 && collectedPoints < 200000){
    await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQHw'));}
    if (collectedPoints >= 200000 && collectedPoints < 500000){
    await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQIA'));}
    if (collectedPoints >= 500000 && collectedPoints < 1000000){
    await Achievements.unlock(achievement: Achievement(androidID:'CgkIq5OYv8wYEAIQIQ'));}
  }

  Future<void> updateCounters()  async {
    bool signInStatus = await googlePlayGameServices.getSignInStatus();
    if (signInStatus == true && await InternetConnection().hasInternetAccess == true) {
      await updateAllTimeBreakedBricks();
      await updateAllTimeCollectedStars();
    }
}

  Future<int> randomChallengeWallNumber() async {
    final _random = Random();
    int countLevels = brickList_2.length;
    int challengeLevel = _random.nextInt(countLevels);
    await prefs.setInt('challengeLevel', challengeLevel+1);
    currentPlayedLevelNumber = challengeLevel +1;

    return challengeLevel;
  }




}
