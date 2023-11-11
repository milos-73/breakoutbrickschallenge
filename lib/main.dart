import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


import 'package:initial_project/ui/overlay_builder.dart';

import 'forge2d_game_world.dart';
import 'main_game.dart';

Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Flame.device.fullScreen();
  await Firebase.initializeApp();


  runApp(const MyApp());
}

//final _brickBreakGame = BrickBreakGame();

class MyApp extends StatelessWidget {
  const MyApp({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      return const MainGame();

      //   MaterialApp(
      // home: Scaffold(backgroundColor: Colors.black,
      //   body: Container(constraints: const BoxConstraints.expand(),decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg/levels2.jpg"),fit: BoxFit.cover)),
      //     child: GameWidget(
      //               game: _brickBreakGame,
      //               overlayBuilderMap: {
      //                 'PreGame': (context, BrickBreakGame game) {return OverlayBuilder.preGame(context, _brickBreakGame); },
      //                 'PostGame': (context, BrickBreakGame game) {return OverlayBuilder.postGame(context, _brickBreakGame); },
      //                 'WinGame': (context, BrickBreakGame game) {return OverlayBuilder.winGame(context, _brickBreakGame); },
      //                 'LostLife': (context, BrickBreakGame game) {return OverlayBuilder.lostLife(context, _brickBreakGame); },
      //                 'MainMenu': (context, BrickBreakGame game) {return OverlayBuilder.mainMenu(context, _brickBreakGame); },
      //                 'LevelsMap': (context, BrickBreakGame game) {return OverlayBuilder.levelsMap(context, _brickBreakGame); },
      //                 'blackScreen': (context, BrickBreakGame game) {return OverlayBuilder.blackScreen(context, _brickBreakGame); },
      //                 'NextLevelChallengeModeOverlay': (context, BrickBreakGame game) {return OverlayBuilder.nextLevelChallengeModeOverlay(context, _brickBreakGame); },
      //                 'ChallengeGameOverOverlay': (context, BrickBreakGame game) {return OverlayBuilder.challengeGameOverOverlay(context, _brickBreakGame); },
      //                 'GamePausedMenuOverlay': (context, BrickBreakGame game) {return OverlayBuilder.gamePausedMenuOverlay(context, _brickBreakGame); },
      //                 'MyAccount': (context, BrickBreakGame game) {return OverlayBuilder.myAccount(context, _brickBreakGame); },
      //                 //'LogInScreen': (context, BrickBreakGame game) {return OverlayBuilder.logInScreen(context, _brickBreakGame); },
      //                 'LoginPageWidget': (context, BrickBreakGame game) {return OverlayBuilder.loginPageWidget(context, _brickBreakGame); },
      //                 'FriendsList': (context, BrickBreakGame game) {return OverlayBuilder.friendsList(context, _brickBreakGame); },
      //                 'LeaderBoard': (context, BrickBreakGame game) {return OverlayBuilder.leaderBoard(context, _brickBreakGame); },
      //                 'SearchFriend': (context, BrickBreakGame game) {return OverlayBuilder.searchFriend(context, _brickBreakGame); },
      //                 'SignWithGoogle': (context, BrickBreakGame game) {return OverlayBuilder.signWithGoogle(context, _brickBreakGame); },
      //               },
      //
      //
      //       initialActiveOverlays: const ['MainMenu'],),
      //   ),
      //
      //   ),
      // );
  }
}
