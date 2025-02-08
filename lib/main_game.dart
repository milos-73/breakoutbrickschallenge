import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brickbreaker/ui/overlay_builder.dart';
import 'package:oktoast/oktoast.dart';

import 'forge2d_game_world.dart';

class MainGame extends StatefulWidget {
  const MainGame({super.key});

  @override
  State<MainGame> createState() => _MainGameState();
  }

final _brickBreakGame = BrickBreakGame();

class _MainGameState extends State<MainGame> {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        home: Scaffold(backgroundColor: Colors.black,
          body: Container(constraints: const BoxConstraints.expand(),decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg/levels2.jpg"),fit: BoxFit.cover)),
            child: GameWidget(
              game: _brickBreakGame,
              overlayBuilderMap: {
                'PreGame': (context, BrickBreakGame game) {return OverlayBuilder.preGame(context, _brickBreakGame); },
                'PostGame': (context, BrickBreakGame game) {return OverlayBuilder.postGame(context, _brickBreakGame); },
                'WinGame': (context, BrickBreakGame game) {return OverlayBuilder.winGame(context, _brickBreakGame); },
                'LostLife': (context, BrickBreakGame game) {return OverlayBuilder.lostLife(context, _brickBreakGame); },
                'MainMenu': (context, BrickBreakGame game) {return OverlayBuilder.mainMenu(context, _brickBreakGame); },
                'LevelsMap': (context, BrickBreakGame game) {return OverlayBuilder.levelsMap(context, _brickBreakGame); },
                'blackScreen': (context, BrickBreakGame game) {return OverlayBuilder.blackScreen(context, _brickBreakGame); },
                'NextLevelChallengeModeOverlay': (context, BrickBreakGame game) {return OverlayBuilder.nextLevelChallengeModeOverlay(context, _brickBreakGame); },
                'ChallengeGameOverOverlay': (context, BrickBreakGame game) {return OverlayBuilder.challengeGameOverOverlay(context, _brickBreakGame); },
                'GamePausedMenuOverlay': (context, BrickBreakGame game) {return OverlayBuilder.gamePausedMenuOverlay(context, _brickBreakGame); },
                'BannerAdOverlay': (context, BrickBreakGame game) {return OverlayBuilder.bannerAdOverlayBuild(context, _brickBreakGame); },
                'AboutInfo': (context, BrickBreakGame game) {return OverlayBuilder.aboutInfo(context, _brickBreakGame); },
              },
      
      
              initialActiveOverlays: const ['MainMenu'],),
          ),
      
        ),
      ),
    );
  }
}
