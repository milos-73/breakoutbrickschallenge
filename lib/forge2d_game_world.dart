import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart' hide Particle;
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:initial_project/components/cannon_ball.dart';
import 'package:initial_project/components/falling_bonus.dart';
import 'package:initial_project/components/falling_points.dart';
import 'package:initial_project/components/paralax_background.dart';
import 'package:initial_project/components/stars_status.dart';
import 'package:initial_project/components/total_stars_hud.dart';
import 'package:initial_project/services/saved_values.dart';
import 'package:initial_project/ui/dbTools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:username_gen/username_gen.dart';
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
  //Star? star;

  late final Background background;
  late final Arena arena;
  late final Paddle paddle;
  late final DeadZone deadZone;
  late final BrickWall brickWall;
  late final HudBar hudBar;
  HudBar? hudBarLevels;
  HudBar? hudBarChallenge;
  late final Obstacles obstacles;
  late final FallingBonus fallingBonus;
  FallingStars? fallingStars;
  // BulletLeft? bulletLeft;
  // BulletRight? bulletRight;
  FallingPoints? fallingPoints;
  Bullets? bullets;
  CannonBall? cannonBall;
  late TimerComponent interval;
  //late TimerComponent bulletsInterval;
  TimerComponent? bullet;
  TimerComponent? gun;
  TotalPointCounter? totalPointCounter;
  TotalStarsCounter? totalStarsCounter;
  //late TimerComponent stickyBall;

  late final SharedPreferences prefs;

  GameState gameState = GameState.initializing;
  StickyBallState stickyBallState = StickyBallState.off;
  BallStatus ballStatus = BallStatus.alreadyCreated;
  SavedValues savedValues = SavedValues();
  StarState starState = StarState.normal;
  GameMode gameMode = GameMode.initializing;
  ParticleState particleState = ParticleState.off;
  AudioSettings audioSettings = AudioSettings.on;
  SyncStatus syncStatus = SyncStatus.off;
  BallState ballState = BallState.inGame;
  PauseButtonState pauseButtonState = PauseButtonState.off;

  int life = 3;
  int? localLastFinishedLevel;
  int? lastFinishedLevelDb;
  int  currentPlayedLevelNumber = 1;

  int numberOfObstacles = 0;

  int numberOfBrickHits = 0;
  int starInterval = 0;
  int numberOfBrickHitsLeft = 0;

  int fastBonus = 0;
  int slowBonus = 0;
  int cannonBallStatus = 0;
  int powerBallBonus = 0;
  GunState gunState = GunState.off;
  int ticks = 1;
  int countDown = 0;
  int countDown2 = 0;
  int countDown3 = 0;
  //int countDown4 = 0;

  int levelPoints = 0;
  int levelPointTop = 0;
  int totalPointsInCurrentGame = 0;
  int totalGamePoints = 0;

  int levelStars = 0;
  int currentGameLevelStars = 0;
  int? totalStars;

  String? starsPerLevelInStringLocal = '';
  List<String?> starsPerLevelInStringListLocal = [];
  List<int?> starsPerLevelInIntListLocal = [];

  String? starsPerLevelInStringDB = '';
  List<String?> starsPerLevelInStringListDB = [];
  List<int?> starsPerLevelInIntListDB = [];

  int starPoints = 0;

  int challengeCurrentLevel = 1;
  int challengeFinishedLevel = 0;

  int stickyBallBonus = 0;
  Vector2 stickyBallPosition = Vector2(0, 0);
  Vector2 stickyBallEndPosition = Vector2(0, 0);
  Vector2 ball2Position = Vector2(0, 0);
  Vector2 ball2Velocity = Vector2(0, 0);
  int stickyBallOn = 0;
  int ball2On = 0;

 String? loggedInName = '';
 String? localUserProfileName = '';
 String? publicUserProfileName = '';

 String? loggedInEmail = '';
 String? keyID;

 String? userSignedInProvider;
 String? loggedIn;

 int? publicTopTotalPoints = 0;
 int? publicTotalStars = 0;

 String? syncErrorMessage;

 String? searchedFriend = '';
 Map? profileOfSearchedFriend;


 late FirebaseAuth _auth;
 final GoogleSignIn _googleSignIn = GoogleSignIn();
 final DbTools dbTools = DbTools();

 //bool loggedInWithEmail = false;

  Vector2 ballPosition = Vector2(18, 60);
  Vector2 position = Vector2(0, 0);
  MouseJoint? mouseJoint;

final random = Random();
final Tween<double> noise = Tween(begin: -1, end: 1);

  @override
  Future<void> onLoad() async {

    super.onLoad();

    await FlameAudio.audioCache.loadAll(['plop1.mp3','collectCoin1.mp3','plop2.mp3','plop3.mp3','brick1.mp3','brick2.mp3','brick3.mp3','brickNoBreak.mp3','levelUp1.mp3','gameOver.mp3', 'lostBall1.mp3', 'gameOver.mp3','button3.mp3','levelSelection.mp3','bottomTap.mp3','wrong1.mp3','cannon.mp3','bullet.mp3','bonus.mp3','positiveNumber.mp3','negativeNumber.mp3']);

    prefs = await SharedPreferences.getInstance();

    FirebaseApp defaultApp = await Firebase.initializeApp();
    _auth = FirebaseAuth.instanceFor(app: defaultApp);

    camera.viewport = FixedResolutionViewport(Vector2(1080,2340));

    await Flame.device.fullScreen();
    await Flame.device.setPortrait();

    localUserProfileName = prefs.getString('customUserProfileName' ?? '');
    if(localUserProfileName == '') {prefs.setString('customUserProfileName', 'user name not set');}
    localLastFinishedLevel = prefs.getInt('lastFinishedLevel') ?? 0;
    totalGamePoints = prefs.getInt('totalGamePoints') ?? 0;
    totalStars = prefs.getInt('totalStars') ?? 0;
    starsPerLevelInStringLocal = prefs.getString('starsPerLevelInString') ?? '';

    //await loadLevelDataForLocalUse();
    await logInStatus();
    //await getUserData();
    await _initializeGame();
    }

   List particleLife = [0.04,0.08 ,0.1, 0.12, 0.18, 0.22, 0.26,0.3];

  @override
  void update(double dt) {
    super.update(dt);

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

    if(gameMode == GameMode.levels){
     // print('+++++++++numberOfBrickHits+++++++++++: ${numberOfBrickHits}');
      //print('+++++++++numberOfBrickHitsLeft+++++++++: ${numberOfBrickHitsLeft}');

    if ((numberOfBrickHits == numberOfBrickHitsLeft) && (numberOfBrickHits > starInterval-1)){

        //print('EQUAL NUMBERS for STAR to be ADDED ');
        fallingStars?.getStar();
        numberOfBrickHitsLeft = numberOfBrickHitsLeft - starInterval;
      }}

    if(numberOfBrickHits < numberOfBrickHitsLeft){

      //print('******************PROBLEM WITH BRICKS NUMBER*******************');
      if ((numberOfBrickHitsLeft - starInterval) > 0) {
        fallingStars?.getStar();
        numberOfBrickHitsLeft = numberOfBrickHitsLeft - starInterval;
      }else{numberOfBrickHitsLeft = numberOfBrickHitsLeft;}
    }


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

Future<void>uploadLevelData() async {

  starsPerLevelInStringLocal = prefs.getString('starsPerLevelInString');
  totalStars = prefs.getInt('totalStars');
  localLastFinishedLevel = await savedValues.getLastFinishedLevel();
  localUserProfileName = prefs.getString('customUserProfileName' ?? '');

  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('leaderboard/$keyID');
  await dbRef.update({
    'listOfStarsPerLevel': starsPerLevelInStringLocal,
    'stars' : totalStars,
    'lastFinishedLevel' : localLastFinishedLevel,
    'userName' : localUserProfileName
  });
}

  Future<void> resetLocalGameData() async {

    int? numberOfLevels = prefs.getInt('lastFinishedLevel') ?? 0;

    if (numberOfLevels > 0) {
      for (var i = 1; i < numberOfLevels + 1; i++ ){
        await prefs.remove('numberOfStars$i');
      }
    }

    await prefs.remove('starsPerLevelInString');
    await prefs.remove('lastFinishedLevel');
    await prefs.remove('totalGamePoints');
    await prefs.remove('totalStars');
    await prefs.remove('currentPlayedLevelNumber');
    await prefs.remove('levelInProgress');

    levelPoints = 0;
    levelPointTop = 0;
    totalPointsInCurrentGame = 0;
    totalGamePoints = 0;

    levelStars = 0;
    currentGameLevelStars = 0;
    totalStars;

    publicTopTotalPoints = 0;
    publicTotalStars = 0;

    starsPerLevelInStringLocal = '';
    starsPerLevelInStringListLocal = [];
    starsPerLevelInIntListLocal = [];

    starsPerLevelInStringDB = '';
    starsPerLevelInStringListDB = [];
    starsPerLevelInIntListDB = [];

    life = 3;
    localLastFinishedLevel;
    lastFinishedLevelDb;
    currentPlayedLevelNumber = 1;

  }

Future<void> resetGameData() async {

    int? numberOfLevels = prefs.getInt('lastFinishedLevel') ?? 0;

    if (numberOfLevels > 0) {
      for (var i = 1; i < numberOfLevels + 1; i++ ) {
        await prefs.remove('numberOfStars$i');
    }
   }

    await prefs.remove('starsPerLevelInString');
    await prefs.remove('lastFinishedLevel');
    await prefs.remove('totalGamePoints');
    await prefs.remove('totalStars');
    await prefs.remove('currentPlayedLevelNumber');
    await prefs.remove('levelInProgress');

    levelPoints = 0;
    levelPointTop = 0;
    totalPointsInCurrentGame = 0;
    totalGamePoints = 0;

    levelStars = 0;
    currentGameLevelStars = 0;
    totalStars;

    publicTopTotalPoints = 0;
    publicTotalStars = 0;

    starsPerLevelInStringLocal = '';
    starsPerLevelInStringListLocal = [];
    starsPerLevelInIntListLocal = [];

    starsPerLevelInStringDB = '';
    starsPerLevelInStringListDB = [];
    starsPerLevelInIntListDB = [];

    life = 3;
    localLastFinishedLevel;
    lastFinishedLevelDb;
    currentPlayedLevelNumber = 1;
    
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('leaderboard/$keyID');

    await dbRef.update({
      'lastFinishedLevel': 0,
      'stars': 0,
      'points': 0,
      'listOfStarsPerLevel' : ''
    });
}

  ///Set the list of stars amount pre each level if user is logged in

  Future<void> setLevelDataWhileOnline() async {

    print('************starsPerLevelInStringDB***********: ${starsPerLevelInStringDB}');

    if(starsPerLevelInStringDB != 'error'){
      starsPerLevelInStringListLocal = starsPerLevelInStringDB!.split(',');

      print('++++++starsPerLevelInStringDB+++++${starsPerLevelInStringDB}');
      print('${starsPerLevelInStringListLocal}');
      int counter = 0;
      int numberOfAllStars = 0;

      for (var i in starsPerLevelInStringListLocal) {

        print('++++++++++ i ++++++++++ ${i}');
        int? value = int.tryParse(i!) ?? 0;

        print('++++++++++ value ++++++++++ ${value}');

        starsPerLevelInIntListLocal.add(value);
        prefs.setInt('numberOfStars${counter + 1}', value);
        if (value != 0){counter = counter + 1;};
        numberOfAllStars = numberOfAllStars + value;

      }

      print('=================== ${counter} ===================');
      syncStatus = SyncStatus.ok;
      prefs.setInt('lastFinishedLevel', counter);
      localLastFinishedLevel = counter;
      totalStars = numberOfAllStars;

    } else  {
      print('ERROR in STARTS DB');
      starsPerLevelInIntListLocal = [];}
  }

  ///Set user data if user is not logged

  Future<void> setLevelDataWhileOffline() async {

    loggedInName = '';
    localUserProfileName = prefs.getString('customUserProfileName' ?? '');
    publicUserProfileName = prefs.getString('customUserProfileName' ?? '');
    totalStars = prefs.getInt('totalStars') ?? 0;
    totalGamePoints = prefs.getInt('totalGamePoints') ?? 0;
    localLastFinishedLevel = prefs.getInt('lastFinishedLevel') ?? 0;
    starsPerLevelInStringLocal = prefs.getString('starsPerLevelInString') ?? '';

    ///Set the list of stars amount pre each level if user is NOT logged in

    if(starsPerLevelInStringLocal != ''){

      starsPerLevelInStringListLocal = starsPerLevelInStringLocal!.split(',');

      int counter = 0;
      for (var i in starsPerLevelInStringListLocal) {

        int? value = int.tryParse(i!);
        starsPerLevelInIntListLocal.add(value);
        counter = counter + 1;
      }
    } else {
      starsPerLevelInIntListLocal = [];}
   }

  ///Check if user is logged, which provider is used and update user data accordingly

  Future<void> logInStatus() async {
    print('+++++++ IN LOGIN STATUS ++++++++');

  loggedIn = FirebaseAuth.instance.currentUser?.email;
  userSignedInProvider = FirebaseAuth.instance.currentUser?.displayName;

  print('loggedIn: ${loggedIn}');
  print('userSignedInProvider: ${userSignedInProvider}');

  if (loggedIn != null) {
    if (userSignedInProvider != null) {
      print('==========LOG IN WITH GOOGLE GETTING DATA==========');
      loggedInName = _auth.currentUser?.displayName;
      localUserProfileName = prefs.getString('customUserProfileName' ?? '');
      publicUserProfileName = await dbTools.getUserName(_auth.currentUser!.uid);

      //if(loggedInName == ''){publicUserProfileName = localUserProfileName;}
      loggedInEmail = _auth.currentUser?.email;
      keyID = _auth.currentUser?.uid;
      if (publicUserProfileName != localUserProfileName) {
        await getUserData();
      }
      if (publicUserProfileName == localUserProfileName) {
        await updateUserData();
      }
    }

    if (userSignedInProvider == null) {
        print('=======LOG IN WITH EMAIL GETTING DATA==========');
        loggedInName = await dbTools.getUserName(FirebaseAuth.instance.currentUser!.uid);
        print('**loggedInName**:${loggedInName}');
        publicUserProfileName = loggedInName;
        localUserProfileName = prefs.getString('customUserProfileName' ?? '');
        //if(loggedInName == ''){publicUserProfileName = localUserProfileName;}
        print('**publicUserProfileName**:${publicUserProfileName}');
        loggedInEmail = FirebaseAuth.instance.currentUser?.email;
        keyID = FirebaseAuth.instance.currentUser?.uid;
        print('**localUserProfileName**:${localUserProfileName}');
        if (publicUserProfileName != localUserProfileName) {
          await getUserData();
        }
        if (publicUserProfileName == localUserProfileName) {
          await updateUserData();
        }

    }
  }else{
    await setLevelDataWhileOffline();
  }
}

  ///Get user data if user has changed the account in phone

  Future<void> getUserData() async {

   await prefs.clear();

   starsPerLevelInStringListLocal = [];
   starsPerLevelInIntListLocal = [];

   starsPerLevelInStringListDB = [];
   starsPerLevelInIntListDB = [];


   prefs.setString('customUserProfileName', publicUserProfileName ?? '');

   publicTopTotalPoints = await dbTools.checkTopTotalPoints(keyID!) ?? 0;
   await prefs.setInt('totalGamePoints', publicTopTotalPoints!);

   publicTotalStars = await dbTools.checkTotalStars(keyID!) ?? 0;
   await prefs.setInt('totalStars', publicTotalStars!);
   totalStars = publicTotalStars;

   starsPerLevelInStringDB = await dbTools.getAllLevelsStarsString(keyID!) ?? '';
   if (starsPerLevelInStringDB != 'error') {
     await prefs.setString( 'starsPerLevelInString', starsPerLevelInStringDB ?? '');
     starsPerLevelInStringLocal = starsPerLevelInStringDB;
   } else {
     await prefs.setString( 'starsPerLevelInString','');
     starsPerLevelInStringLocal = '';
   }

   localLastFinishedLevel = await dbTools.getLastFinishedLevel(keyID!) ?? 0;
   await prefs.setInt('lastFinishedLevel', localLastFinishedLevel ?? 0);

   await setLevelDataWhileOnline();
 }

  ///Update user data if user has logged in with the same account as was set in SharedPreferences

  Future<void> updateUserData() async {

    lastFinishedLevelDb = await dbTools.getLastFinishedLevel(keyID!);
    localLastFinishedLevel = prefs.getInt('lastFinishedLevel') ?? 0;

    if (lastFinishedLevelDb! < localLastFinishedLevel!){

      DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('leaderboard/$keyID');

      await dbRef.update({
        'lastFinishedLevel': localLastFinishedLevel,
      });
    }
    if (lastFinishedLevelDb! < localLastFinishedLevel!){
      prefs.setInt('lastFinishedLevel', lastFinishedLevelDb!);
    }

    if (lastFinishedLevelDb! == localLastFinishedLevel!){
      prefs.setInt('lastFinishedLevel', lastFinishedLevelDb!);
    }

    publicTopTotalPoints = await dbTools.checkTopTotalPoints(keyID!) ?? 0;

    publicTopTotalPoints ??= totalGamePoints;

    if (publicTopTotalPoints != null && publicTopTotalPoints! > totalGamePoints) {
      totalGamePoints = publicTopTotalPoints!;
      await prefs.setInt('totalGamePoints', publicTopTotalPoints!);
    }

    if (publicTopTotalPoints != null &&
        publicTopTotalPoints! < totalGamePoints) {
      publicTopTotalPoints = totalGamePoints;

      DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('leaderboard/$keyID');

      await dbRef.update({
        'points': totalGamePoints,
      });
    }

    publicTotalStars = await dbTools.checkTotalStars(keyID!) ?? 0;
    totalStars = prefs.getInt('totalStars') ?? 0;
    starsPerLevelInStringDB = await dbTools.getAllLevelsStarsString(keyID!) ?? '';
    starsPerLevelInStringLocal = prefs.getString('starsPerLevelInString');

    publicTotalStars ??= totalStars;

    if (publicTotalStars != null && publicTotalStars! > totalStars!) {
      totalStars = publicTotalStars!;

      await prefs.setInt('totalStars', publicTotalStars!);

        if (starsPerLevelInStringDB != 'error') {
        await prefs.setString('starsPerLevelInString', starsPerLevelInStringDB ?? '');
        starsPerLevelInStringLocal = starsPerLevelInStringDB;
      } else {
        await prefs.setString('starsPerLevelInString', '');
        starsPerLevelInStringLocal = '';
      }
    }

    if (publicTotalStars != null && publicTotalStars! < totalStars!) {
      DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('leaderboard/$keyID');

      await dbRef.update({
        'stars': totalStars,
        'listOfStarsPerLevel': starsPerLevelInStringLocal
      });
      starsPerLevelInStringDB = starsPerLevelInStringLocal;
    }

    if (publicTotalStars != null && publicTotalStars! == totalStars!) {
      if (lastFinishedLevelDb! < localLastFinishedLevel!) {
        starsPerLevelInStringDB = starsPerLevelInStringLocal;
      } else {
        starsPerLevelInStringLocal = starsPerLevelInStringDB;
      }

      if (lastFinishedLevelDb! > localLastFinishedLevel!) {
        localLastFinishedLevel = lastFinishedLevelDb;
      }
      await prefs.setInt('lastFinishedLevel', lastFinishedLevelDb ?? 0);
      if (lastFinishedLevelDb! < localLastFinishedLevel!) {
        lastFinishedLevelDb = localLastFinishedLevel;
      }
      DatabaseReference dbRef = FirebaseDatabase.instance.ref().child(
          'leaderboard/$keyID');

      await dbRef.update({
        'lastFinishedLevel': localLastFinishedLevel
      });

      print('IN UPDATE USER DATA');
      await setLevelDataWhileOnline();
    }
  }

  Future<void> getCustomUserName(String? keyID) async {

    localUserProfileName = UsernameGen().generate();
    prefs.setString('customUserProfileName', localUserProfileName ?? '');

    publicUserProfileName = localUserProfileName;

    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('leaderboard/$keyID');
    await dbRef.update({'userName': localUserProfileName,});
  }

  Future<void> _initializeGame() async {

     ///HUD BAR and BUTTONS

    hudBar = HudBar();
    add(hudBar);
    //hudBarChallenge = HudBar(children: [LifeCounter(), TotalPointInCurrentGame(), TotalPointCounter(), LevelPointCounter(), LevelPointTopCounter()]);
    hudBarChallenge = HudBar(children: [TotalPointInCurrentGame(), LevelPointCounter(), LevelPointTopCounter()]);
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
    particleState = ParticleState.off;
    bool? hudBarLevelsMounted = hudBarLevels?.isMounted;
    bool? hudBarChallengeMounted = hudBarChallenge?.isMounted;
    bool? fallingStarsMounted = fallingStars?.isMounted;
    //bool? starMounted = star?.isMounted;
    bool? fallingPointsMounted = fallingPoints?.isMounted;
    bool? totalPointCounterMounted = totalPointCounter?.isMounted;
    bool? starsLevelTotalMounted = totalStarsCounter?.isMounted;
    currentPlayedLevelNumber = prefs.getInt('currentPlayedLevelNumber') ?? 0;
    levelPointTop = prefs.getInt('topLevelPoints1') ?? 0;
    totalGamePoints = prefs.getInt('totalGamePoints') ?? 0;
    totalStars = prefs.getInt('totalStars') ?? 0;
    levelStars = prefs.getInt('numberOfStars$currentPlayedLevelNumber') ?? 0;
    localLastFinishedLevel = prefs.getInt('lastFinishedLevel') ?? 0;

    currentGameLevelStars = 0;
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

    print('starsPerLevelInIntListLocal***FROM PICK LEVEL***: ${starsPerLevelInIntListLocal}');

  gameState = GameState.initializing;
  particleState = ParticleState.off;
  bool? hudBarLevelsMounted = hudBarLevels?.isMounted;
  bool? hudBarChallengeMounted = hudBarChallenge?.isMounted;
  bool? fallingStarsMounted = fallingStars?.isMounted;
  bool? fallingPointsMounted = fallingPoints?.isMounted;
  bool? ball2Mounted = ball2?.isMounted;
  bool? totalPointCounterMounted = totalPointCounter?.isMounted;
  bool? starsLevelTotalMounted = totalStarsCounter?.isMounted;

  currentGameLevelStars = 0;
  totalPointsInCurrentGame = 0;
  levelPoints = 0;
  currentPlayedLevelNumber = level;

  levelPointTop = prefs.getInt('topLevelPoints$level') ?? 0;
  totalGamePoints = prefs.getInt('totalGamePoints') ?? 0;
  totalStars = prefs.getInt('totalStars') ?? 0;
  levelStars = prefs.getInt('numberOfStars$level') ?? 0;
  localLastFinishedLevel = prefs.getInt('lastFinishedLevel') ?? 0;

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
    levelPointTop = prefs.getInt('topLevelPoints$level') ?? 0;
    levelStars = prefs.getInt('numberOfStars$level') ?? 0;
    await prefs.setInt('currentPlayedLevelNumber', currentPlayedLevelNumber + 1);
    localLastFinishedLevel = prefs.getInt('lastFinishedLevel') ?? 0;

    print('$currentPlayedLevelNumber');

    currentGameLevelStars = 0;
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

}
