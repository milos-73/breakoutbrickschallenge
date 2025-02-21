
import 'dart:convert';
import 'dart:math';

//import 'package:firebase_database/firebase_database.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:brickbreaker/components/walls_1.dart';
import 'package:brickbreaker/components/walls_2.dart';
import 'package:games_services/games_services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../forge2d_game_world.dart';
import '../services/saved_values.dart';
import 'brick.dart';
import 'brick2.dart';
import 'brick3.dart';
import 'brick_crack_1.dart';
import 'brick_crack_2.dart';
import 'google_play_game_services.dart';

// 1
class BrickWall extends Component with HasGameRef<BrickBreakGame> {

  final Vector2 position;
  final Size? size;
  final int levelNumber;

  // 2
  BrickWall({Vector2? position, this.size, required this.levelNumber}) : position = position ?? Vector2.zero();

  SavedValues savedValues = SavedValues();
  final googlePlayGameServices = GooglePlayGameServices();

  Size brickSize = const Size(3.09,1.6);
  int levelPointsTop = 0;
  int numberOfStarsPerLevel = 0;
  int numberOfStarsPointsPerLevel = 0;
  int? currentLevelNumber;
  int? challengeLevelNumber;
  int? currentChallengeLevelPoints;
  int starsNumber = 0;
  int challengeLevels = 0;
  late int lastFinishedLevel;
  //int challengeLevelsInRowCounter = 0;
  //int challengeGameCounterHelper = 0;

  int _counterTotal = 0;


  List brickSound = ['brick1.mp3','brick2.mp3',];

  // 3
  @override
  Future<void> onLoad() async {
    super.onLoad();
    gameRef.wallStatus = WallStatus.inBuild;
    //gameRef.counterGame = await gameRef.prefs.getInt('counter') ?? 0;
    await buildWall(levelNumber);
    children.register<Brick>();
    children.register<Brick3>();
    children.register<BrickCracked1>();
    children.register<BrickCracked2>();
    //print('BRICKS NUMBER FROM onLOAD: ${i}');
    //await countBricksInCurrentLevel(i);
    //print('gameRef.numberOfBrickHits FROM WALL ONLOAD${gameRef.numberOfBrickHits}');
    //print('numberOfBrickHitsLeft FROM WALL ONLOAD:${gameRef.numberOfBrickHitsLeft}');
  }

  @override
  Future<void> update(double dt) async {

    var numberOfBrick = children.query<Brick>();
    var numberOfBrick3 = children.query<Brick3>();
    var numberOfBrickCracked1 = children.query<BrickCracked1>();
    var numberOfBrickCracked2 = children.query<BrickCracked2>();

    bool signInStatus = await googlePlayGameServices.getSignInStatus();
if(gameRef.wallStatus == WallStatus.ready){
    gameRef.numberOfBrickHits = numberOfBrick.length + numberOfBrick3.length + numberOfBrickCracked1.length + numberOfBrickCracked2.length;}

    // print('gameRef.wallStatus FROM WALL UPDATE: ${gameRef.wallStatus}');
    // print('gameRef.numberOfBrickHits FROM WALL UPDATE: ${gameRef.numberOfBrickHits}');
    // print('numberOfBrickHitsLeft FROM WALL UPDATE: ${gameRef.numberOfBrickHitsLeft}');

    if (numberOfBrick.isEmpty && numberOfBrick3.isEmpty && numberOfBrickCracked1.isEmpty && numberOfBrickCracked2.isEmpty && gameRef.gameState == GameState.running){
      if (game.audioSettings == AudioSettings.on)  {
        FlameAudio.play('levelUp1.mp3');}

      gameRef.particleState = ParticleState.off;
      gameRef.cannonBall?.resetCannonBall();
      gameRef.bullets?.resetAllBullets();

      if (gameRef.gameMode == GameMode.challenge) {

        //print('========1========');

        challengeLevelNumber = await gameRef.prefs.getInt('challengeLevel') ?? 0;
        currentChallengeLevelPoints = await gameRef.prefs.getInt('challengeLevelPoints$challengeLevelNumber') ?? 0;

        if (gameRef.levelPoints > currentChallengeLevelPoints! ) {await gameRef.prefs.setInt('challengeLevelPoints$challengeLevelNumber', currentChallengeLevelPoints!); print('========2========');}

        ///Writes TOTAL CURRENT GAME POINTS to existing TOTAL POINTS IN CURRENT GAME.
        //gameRef.totalPointsInCurrentGame = gameRef.totalPointsInCurrentGame + gameRef.levelPoints;
        await gameRef.prefs.setInt('totalPointsInCurrentGame', gameRef.totalPointsInCurrentGame);

        ///COMPARING Total Points In Current Game with Total Points and WRITING the Current Game Points to Total Game Points if larger
        if(gameRef.totalPointsInCurrentGame > gameRef.totalGamePoints){
          //print('========3========');
        await gameRef.prefs.setInt('totalGamePoints', gameRef.totalPointsInCurrentGame);

        if (signInStatus == true && await InternetConnection().hasInternetAccess == true){
          await Leaderboards.submitScore(score: Score(androidLeaderboardID:'CgkIq5OYv8wYEAIQAQ', value:  gameRef.totalPointsInCurrentGame ));}
         }

        ///GETTING Total Level Points from Shared Preferences
        levelPointsTop = gameRef.prefs.getInt('topLevelPoints$challengeLevelNumber') ?? 0;

        ///COMPARING Level Points with Total Level Points and writes Level Points to Total Level Points if larger
        if (levelPointsTop < gameRef.levelPoints) {
          //print('========4========');
          await gameRef.prefs.setInt('topLevelPoints$challengeLevelNumber', gameRef.levelPoints);
          //print('*********challengeLevelNumber**********: ${challengeLevelNumber}');

        } else {

          //gameRef.levelPoints = 0;
          //print('========5========');
          //print('GAME STATUS: ${gameRef.gameState}');
        }
        ///SET Game Status to ChallengeNextLevel
        // if(gameRef.challengeGameCounterHelper == 0) {
        //   gameRef.challengeGameCounterHelper = 1;
        //   //gameRef.challengeLevelsPerGame++;
        //   //await gameRef.prefs.setInt('challengeLevelsPerGame', gameRef.challengeLevelsPerGame);
        // print('***gameRef.challengeGameCounterHelper*** ${gameRef.challengeGameCounterHelper}');
        // print('***gameRef.challengeLevelsPerGame*** ${gameRef.challengeLevelsPerGame}');
        // }
        gameRef.wallStatus = WallStatus.inBuild;

        //print('++++gameRef.challengeLevelsPerGame++++ ${gameRef.challengeLevelsPerGame}');
        gameRef.gameState = GameState.challengeNextLevel;
        //gameRef.challengeCurrentLevel = await randomChallengeLevelNumber();
        //challengeLevelgameRef.updatePointsCounter();
      }

      if (gameRef.gameMode == GameMode.levels){

       lastFinishedLevel = await savedValues.getLastFinishedLevel();
       gameRef.updateBrickBreakedAchievements();

        if (currentLevelNumber! <= lastFinishedLevel){

          numberOfStarsPerLevel = gameRef.prefs.getInt('numberOfStars$currentLevelNumber') ?? 0;
          numberOfStarsPointsPerLevel = gameRef.prefs.getInt('starsPoints$currentLevelNumber') ?? 0;

          if (numberOfStarsPerLevel < gameRef.currentGameLevelStars){

            int totalStars = gameRef.totalStars! + (gameRef.currentGameLevelStars - numberOfStarsPerLevel);
            int totalStarsPoints = gameRef.totalStarsPoints! + (gameRef.currentGameLevelStarsPoints - numberOfStarsPointsPerLevel);

            await gameRef.prefs.setInt('numberOfStars$currentLevelNumber', gameRef.currentGameLevelStars);
            await gameRef.prefs.setInt('totalStars', totalStars);
            await gameRef.prefs.setInt('starsPoints$currentLevelNumber', gameRef.currentGameLevelStarsPoints);
            await gameRef.prefs.setInt('totalStarsPoints', totalStarsPoints);

            if (signInStatus == true && await InternetConnection().hasInternetAccess == true){
              await Leaderboards.submitScore(score: Score(androidLeaderboardID:'CgkIq5OYv8wYEAIQAQ', value:  totalStars ));
              await Leaderboards.submitScore(score: Score(androidLeaderboardID:'CgkIq5OYv8wYEAIQCg', value:  totalStarsPoints ));
            }

            gameRef.totalStars = totalStars;
            gameRef.totalStarsPoints = totalStarsPoints;

            }
          gameRef.wallStatus = WallStatus.inBuild;
          gameRef.gameState = GameState.won;
          gameRef.numberOfBrickHits = 0;
          gameRef.numberOfBrickHitsLeft = 0;
        }

        if (currentLevelNumber == lastFinishedLevel + 1) {

          await gameRef.prefs.setInt('lastFinishedLevel', currentLevelNumber!);
          gameRef.lastFinishedLevel = currentLevelNumber;

          int totalStars = gameRef.totalStars! + gameRef.currentGameLevelStars;
          int totalStarsPoints = gameRef.totalStarsPoints! + gameRef.currentGameLevelStarsPoints;
          //int percentage = ((totalStars/(currentLevelNumber!*5)*100)*100).toInt();

          await gameRef.prefs.setInt('numberOfStars$currentLevelNumber', gameRef.currentGameLevelStars);
          //await gameRef.prefs.setString('starsPerLevelInString', gameRef.starsPerLevelInStringLocal!);
          await gameRef.prefs.setInt('totalStars', gameRef.totalStars! + gameRef.currentGameLevelStars);
          await gameRef.prefs.setInt('starsPoints$currentLevelNumber', gameRef.currentGameLevelStarsPoints);
          await gameRef.prefs.setInt('totalStarsPoints', gameRef.currentGameLevelStarsPoints + gameRef.totalStarsPoints!);


          if (signInStatus == true && await InternetConnection().hasInternetAccess == true){
            await Leaderboards.submitScore(score: Score(androidLeaderboardID:'CgkIq5OYv8wYEAIQAQ', value:  totalStars ));
            await Leaderboards.submitScore(score: Score(androidLeaderboardID:'CgkIq5OYv8wYEAIQCg', value:  totalStarsPoints ));
          }

          gameRef.totalStars = totalStars;
          gameRef.totalStarsPoints = totalStarsPoints;

        }
        gameRef.wallStatus = WallStatus.inBuild;
        gameRef.gameState = GameState.won;
        await gameRef.updateCounters();
        gameRef.numberOfBrickHits = 0;
        gameRef.numberOfBrickHitsLeft = 0;
      }
    }

    for (final child in [... children]){
      if (child is Brick && child.destroy){
        for ( final fixture in [...child.body.fixtures]){
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        // FlameAudio.play(brickSound[Random().nextInt(2)]);
        if (game.audioSettings == AudioSettings.on)  {
          //print('BRICK SOUND');
          FlameAudio.play('brick3.mp3');}
        remove(child);
        gameRef.breakedBricksCounter++;
      }

      if (child is Brick3 && child.crack1){

        for ( final fixture in [...child.body.fixtures]){
          var brickPosition = child.body.position;
          add(BrickCracked1(size: brickSize, position: brickPosition, spriteName: 'bricks3/orange1.png'));

          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
      }

      if (child is BrickCracked1 && child.crack2){

        for ( final fixture in [...child.body.fixtures]){
          var brickPosition = child.body.position;
          add(BrickCracked2(size: brickSize, position: brickPosition, spriteName: 'bricks3/pink1.png'));
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
      }

      if (child is BrickCracked2 && child.destroy){

        for (final fixture in [...child.body.fixtures]){
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
        gameRef.breakedBricksCounter++;
      }
    }
    super.update(dt);
  }

  Future<int> randomChallengeLevelNumber() async {
  final _random = Random();
  int countLevels = brickList_2.length;
  int challengeLevel = _random.nextInt(countLevels);
  await gameRef.prefs.setInt('challengeLevel', challengeLevel+1);
  gameRef.currentPlayedLevelNumber = challengeLevel +1;

  return challengeLevel;
}

  Future<void> buildWall(int levelNumber) async {

    //int challengeLevelNumber = await randomChallengeLevelNumber();

    if(gameRef.gameMode == GameMode.levels){
      gameRef.currentPlayedLevelNumber = levelNumber;
      List brickList = brickList_1[levelNumber - 1];

      var i = 0;
      for (var r = 0; r < brickList.length; r++){
        if (brickList == []){continue;}
        for (var c = 0; c < brickList[r].length; c++) {
          var brick = brickList[r][c] > 83 ? await getBrick(brickList[r][c]) : brickList[r][c];

          if (brick == '' || brick == '10' || brick == '0') {continue;}

          if (brickList[r][c] > 10 && brickList[r][c] <= 83){await add(Brick(spriteName: 'bricks4/b${brickList[r][c]}.png',size: brickSize,position: Vector2((c * brickSize.width) + 2.45, ((r * brickSize.height) + 20)))); i = i + 1; }
          if (brickList[r][c] > 93 && brickList[r][c] <= 99 ){await add(Brick2(spriteName: 'bricks3/$brick',size: brickSize,position: Vector2((c * brickSize.width) + 2.45, ((r * brickSize.height) + 20))));}
          if (brickList[r][c] > 98 ){await add(Brick3(spriteName: 'bricks3/$brick',size: brickSize,position: Vector2((c * brickSize.width) + 2.45, ((r * brickSize.height) + 20))));i = i + 3; }
        }
        //gameRef.wallStatus = WallStatus.ready;
      }


      //print('brickList LENGHT2: ${i}');
      gameRef.numberOfBrickHits = i;
      gameRef.starInterval = i~/5;
      gameRef.starInterval = (i - (i~/5))~/5;
      gameRef.numberOfBrickHitsLeft =  i - (i~/5);
      gameRef.wallStatus = WallStatus.ready;
      // print('BRICKS i:${i}');
      // print('MODULO (i~/5): ${(i~/5)}');
      // print('gameRef.starInterval${gameRef.starInterval}');
      // print('Lef BRICKS? ${i}-${i~/5}');
      // print('gameRef.numberOfBrickHitsLeftStart${gameRef.numberOfBrickHitsLeft}');


    }

    else{
      //int challengeLevelNumber = await randomChallengeLevelNumber();

      List brickList = brickList_2[levelNumber];

    for (var r = 0; r < brickList.length; r++){
      if (brickList == []){continue;}

      for (var c = 0; c < brickList[r].length; c++) {

        var brick = brickList[r][c] > 83 ? await getBrick(brickList[r][c]) : brickList[r][c];
        if (brick == '' || brick == '10' || brick == '0') {continue;}

        if (brickList[r][c] > 10 && brickList[r][c] <= 83){await add(Brick(spriteName: 'bricks4/b${brickList[r][c]}.png',size: brickSize,position: Vector2((c * brickSize.width) + 2.45, ((r * brickSize.height) + 20))));}
        if (brickList[r][c] > 93 && brickList[r][c] <= 99 ){await add(Brick2(spriteName: 'bricks3/$brick',size: brickSize,position: Vector2((c * brickSize.width) + 2.45, ((r * brickSize.height) + 20))));}
        if (brickList[r][c] > 98 ){await add(Brick3(spriteName: 'bricks3/$brick',size: brickSize,position: Vector2((c * brickSize.width) + 2.45, ((r * brickSize.height) + 20))));}
      }
    }
    }
    //await countBricksInCurrentLevel(i);
  }

   ///CHOOSE BRICK
  Future<String> getBrick(int brickType) async {

    //final brickWallPosition = Vector2(0.1, gameRef.size.y * 0.075);
    const hudSize = 7.0;
    const bannerSize = 7.0;
    const distanceFromTop = hudSize+bannerSize;

    switch (brickType) {

      case 94:
        String brick = 'nonBreak1.png';
        return brick;
      case 95:
        String brick = 'nonBreak2.png';
        return brick;
      case 96:
        String brick = 'nonBreak3.png';
        return brick;
      case 97:
        String brick = 'nonBreak4.png';
        return brick;
      case 98:
        String brick = 'nonBreak5.png';
        return brick;
      case 99:
        String brick = 'green1.png';
        return brick;
      case 100:
        String brick = 'purple1.png';
        return brick;
      default:
        String brick = '';
        return brick;
    }
  }

  Future<void> resetWall(i) async {
    //print('RESET WALL: ${i}');

    removeAll(children);
    await buildWall(i);
  }

  Future<void> pickWall(int i) async {
    removeAll(children);
    currentLevelNumber = i;

    // children.register<Brick>();
    // children.register<Brick3>();
    // children.register<BrickCracked1>();
    // children.register<BrickCracked2>();
    await buildWall(i);
  }

  // Future <void> updateCounterBrickBreakeAchievemnts() async {
  //   gameRef.breakedBricksCounter++;
  //   if (_counterTotal == 40) {print('COUNTER 40 Bricks');}
  //    }
}