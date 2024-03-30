
import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:initial_project/components/walls_1.dart';
import 'package:initial_project/components/walls_2.dart';
import '../forge2d_game_world.dart';
import '../services/saved_values.dart';
import 'brick.dart';
import 'brick2.dart';
import 'brick3.dart';
import 'brick_crack_1.dart';
import 'brick_crack_2.dart';

// 1
class BrickWall extends Component with HasGameRef<BrickBreakGame> {

  final Vector2 position;
  final Size? size;
  final int levelNumber;

  // 2
  BrickWall({Vector2? position, this.size, required this.levelNumber}) : position = position ?? Vector2.zero();

  SavedValues savedValues = SavedValues();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Size brickSize = const Size(3.09,1.6);
  int levelPointsTop = 0;
  int numberOfStarsPerLevel = 0;
  int? currentLevelNumber;
  int starsNumber = 0;
  late int lastFinishedLevel;

  List brickSound = ['brick1.mp3','brick2.mp3',];

  // 3
  @override
  Future<void> onLoad() async {
    super.onLoad();

    await buildWall(levelNumber);
    children.register<Brick>();
    children.register<Brick3>();
    children.register<BrickCracked1>();
    children.register<BrickCracked2>();
   }

  @override
  Future<void> update(double dt) async {

    var numberOfBrick = children.query<Brick>();
    var numberOfBrick3 = children.query<Brick3>();
    var numberOfBrickCracked1 = children.query<BrickCracked1>();
    var numberOfBrickCracked2 = children.query<BrickCracked2>();

    gameRef.numberOfBrickHits = numberOfBrick.length + numberOfBrick3.length + numberOfBrickCracked1.length + numberOfBrickCracked2.length;
    //var starInterval = (numberOfBrick.length+numberOfBrick3.length+numberOfBrickCracked1.length+numberOfBrickCracked2.length)~/5;

    if (numberOfBrick.isEmpty && numberOfBrick3.isEmpty && numberOfBrickCracked1.isEmpty && numberOfBrickCracked2.isEmpty && gameRef.gameState == GameState.running){
      if (game.audioSettings == AudioSettings.on)  {
      FlameAudio.play('levelUp1.mp3');}

      gameRef.particleState = ParticleState.off;
      gameRef.cannonBall?.resetCannonBall();
      gameRef.bullets?.resetAllBullets();

      if (gameRef.gameMode == GameMode.challenge) {

       ///Writes TOTAL CURRENT GAME POINTS to existing TOTAL POINTS IN CURRENT GAME.
        //gameRef.totalPointsInCurrentGame = gameRef.totalPointsInCurrentGame + gameRef.levelPoints;
        await gameRef.prefs.setInt('totalPointsInCurrentGame', gameRef.totalPointsInCurrentGame);

        ///COMPARING Total Points In Current Game with Total Points and WRITING the Current Game Points to Total Game Points if larger
        if(gameRef.totalPointsInCurrentGame > gameRef.totalGamePoints){

          await gameRef.logInStatus();

          if(gameRef.loggedIn != null && gameRef.totalPointsInCurrentGame > gameRef.publicTopTotalPoints!) {

            await gameRef.prefs.setInt('totalGamePoints', gameRef.totalPointsInCurrentGame);

            gameRef.publicTopTotalPoints = gameRef.totalPointsInCurrentGame;

            DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('leaderboard/${gameRef.keyID}');

            await dbRef.update({
              'points': gameRef.totalPointsInCurrentGame,
              'userName' : gameRef.publicUserProfileName,
            });
          }else{
            //ToDo DIALOG S možnosťou prihlásenia
            print('PLEASE LOG IN');}
          await gameRef.prefs.setInt('totalGamePoints', gameRef.totalPointsInCurrentGame);
        }

        ///GETTING Total Level Points from Shared Preferences
        levelPointsTop = gameRef.prefs.getInt('topLevelPoints$levelNumber') ?? 0;

        ///COMPARING Level Points with Total Level Points and writes Level Points to Total Level Points if larger
        if (levelPointsTop < gameRef.levelPoints) {
          await gameRef.prefs.setInt('topLevelPoints$levelNumber', gameRef.levelPoints);

        } else {
          //gameRef.levelPoints = 0;
          print('GAME STATUS: ${gameRef.gameState}');
        }
        ///SET Game Status to ChallengeNextLevel
        gameRef.challengeCurrentLevel = gameRef.challengeCurrentLevel + 1;
        gameRef.gameState = GameState.challengeNextLevel;
      }

      if (gameRef.gameMode == GameMode.levels){

      lastFinishedLevel = await savedValues.getLastFinishedLevel();

        if (currentLevelNumber! <= lastFinishedLevel){

          numberOfStarsPerLevel = gameRef.prefs.getInt('numberOfStars$currentLevelNumber') ?? 0;

          if (numberOfStarsPerLevel < gameRef.currentGameLevelStars){

            gameRef.starsPerLevelInIntListLocal[currentLevelNumber!-1] = gameRef.currentGameLevelStars;
            gameRef.starsPerLevelInStringLocal = gameRef.starsPerLevelInIntListLocal.join(',');
            //gameRef.starsPerLevelInStringLocal = utf8.decode(gameRef.starsPerLevelInIntListLocal);
            //gameRef.starsPerLevelInStringLocal = gameRef.starsPerLevelInIntListLocal.map((e) => e.toString()).join(',');

            int totalStars = gameRef.totalStars! + (gameRef.currentGameLevelStars - numberOfStarsPerLevel);

            await gameRef.prefs.setString('starsPerLevelInString', gameRef.starsPerLevelInStringLocal!);
            await gameRef.prefs.setInt('numberOfStars$currentLevelNumber', gameRef.currentGameLevelStars);
            await gameRef.prefs.setInt('totalStars', totalStars);

            gameRef.totalStars = totalStars;

            print('gameRef.loggedIn: ${gameRef.loggedIn}');

           if(gameRef.loggedIn != null){

              DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('leaderboard/${gameRef.keyID}');

              await dbRef.update({
                'listOfStarsPerLevel': gameRef.starsPerLevelInStringLocal,
                'stars' : gameRef.totalStars,
                'userName' : gameRef.publicUserProfileName,
              });
              } else {
              print('PLEASE LOG IN to upload game DATA');}
            }
          gameRef.gameState = GameState.won;
          }

        if (currentLevelNumber == lastFinishedLevel + 1) {
          await gameRef.prefs.setInt('lastFinishedLevel', currentLevelNumber!);

          print('currentGameLevelStars***0***: ${gameRef.currentGameLevelStars}');
          print('starsPerLevelInIntListLocal***0***: ${gameRef.starsPerLevelInIntListLocal}');


          gameRef.currentGameLevelStars > 0 ? gameRef.starsPerLevelInIntListLocal.add(gameRef.currentGameLevelStars) : gameRef.starsPerLevelInIntListLocal.add(0);

          print('currentGameLevelStars: ${gameRef.currentGameLevelStars}');
          print('starsPerLevelInIntListLocal: ${gameRef.starsPerLevelInIntListLocal}');


          gameRef.starsPerLevelInStringLocal =  gameRef.starsPerLevelInIntListLocal.join(',');
          //gameRef.starsPerLevelInStringLocal = gameRef.starsPerLevelInIntListLocal.map((e) => e.toString()).join(',');

          print('gameRef.starsPerLevelInStringLocal: ${gameRef.starsPerLevelInStringLocal}');

              int totalStars = gameRef.totalStars! + gameRef.currentGameLevelStars;

          print('totalStars2: ${totalStars}');

              await gameRef.prefs.setInt('numberOfStars$currentLevelNumber', gameRef.currentGameLevelStars);
              await gameRef.prefs.setString('starsPerLevelInString', gameRef.starsPerLevelInStringLocal!);
              await gameRef.prefs.setInt('totalStars', gameRef.totalStars! + gameRef.currentGameLevelStars);

              gameRef.totalStars = totalStars;

          print('//////////////starsPerLevelInIntListLocal-2/////////////: ${gameRef.starsPerLevelInIntListLocal}');

          print('gameRef.loggedIn: ${gameRef.loggedIn}');
          if(gameRef.loggedIn != null){

            DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('leaderboard/${gameRef.keyID}');

          await dbRef.update({
            'listOfStarsPerLevel': gameRef.starsPerLevelInStringLocal,
            'stars' : gameRef.totalStars,
            'userName' : gameRef.publicUserProfileName,
            'lastFinishedLevel' : currentLevelNumber
          });}else{
            print('PLEASE LOG IN to upload game DATA');}
          }
          gameRef.gameState = GameState.won;
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


      if (child is Brick3 && child.destroy){
        for ( final fixture in [...child.body.fixtures]){
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        // FlameAudio.play(brickSound[Random().nextInt(2)]);
        if (game.audioSettings == AudioSettings.on)  {
          //print('BRICK SOUND');
          FlameAudio.play('brick3.mp3');}
        remove(child);
      }

      if (child is BrickCracked1 && child.destroy){
        for ( final fixture in [...child.body.fixtures]){
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        // FlameAudio.play(brickSound[Random().nextInt(2)]);
        if (game.audioSettings == AudioSettings.on)  {
          //print('BRICK SOUND');
          FlameAudio.play('brick3.mp3');}
        remove(child);
      }


      if (child is BrickCracked2 && child.destroy){

        for (final fixture in [...child.body.fixtures]){
         child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
      }
    }
        super.update(dt);
  }

  Future<void> buildWall(int levelNumber) async {

    if(gameRef.gameMode == GameMode.levels){
      List brickList = brickList_1[levelNumber - 1];

    var i = 0;
    for (var r = 0; r < brickList.length; r++){
      if (brickList == []){continue;}
      for (var c = 0; c < brickList[r].length; c++) {
        var brick = brickList[r][c] > 83 ? await getBrick(brickList[r][c]) : brickList[r][c];

        if (brick == '' || brick == '10' || brick == '0') {continue;}

        if (brickList[r][c] > 10 && brickList[r][c] <= 83){await add(Brick(spriteName: 'bricks4/b${brickList[r][c]}.png',size: brickSize,position: Vector2((c * brickSize.width) + 2.45, ((r * brickSize.height) + 20))));i = i + 1;}
        if (brickList[r][c] > 93 && brickList[r][c] <= 99 ){await add(Brick2(spriteName: 'bricks3/$brick',size: brickSize,position: Vector2((c * brickSize.width) + 2.45, ((r * brickSize.height) + 20))));}
        if (brickList[r][c] > 98 ){await add(Brick3(spriteName: 'bricks3/$brick',size: brickSize,position: Vector2((c * brickSize.width) + 2.45, ((r * brickSize.height) + 20))));i = i + 3;}

       }
    }
    //gameRef.starInterval = i~/5;
    gameRef.starInterval = (i - (i~/5))~/5;
    gameRef.numberOfBrickHitsLeft =  i - (i~/5);
    }
    else{ List brickList = brickList_2[levelNumber - 1];

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

    await buildWall(i);

      }
}