// ///PICK LEVEL
// Future<void> pickLevel(int level) async {
//   print('PICK LEVEL');
//   print('GAME MODE FROM PICKL LEVEL: ${gameMode}');
//
//   bool? hudBarLevelsMounted = hudBarLevels?.isMounted;
//   bool? hudBarMounted = hudBar?.isMounted;
//   bool? fallingStarsMounted = fallingStars?.isMounted;
//   bool? fallingPointsMounted = fallingPoints?.isMounted;
//   bool? ball2Mounted = ball2?.isMounted;
//   gameState = GameState.initializing;
//
//   levelPointTop = prefs.getInt('topLevelPoints$level') ?? 0;
//   levelStars = prefs.getInt('numberOfStars$level') ?? 0;
//   totalGamePoints = prefs.getInt('totalGamePoints') ?? 0;
//
//   print('HUD BAR STATUS FROM PICK LEVEL: ${hudBarLevelsMounted}');
//
//   await prefs.setInt('currentPlayedLevelNumber', level);
//
//   if (ball2On == 1) {
//     ball2On = 0;
//     stickyBallState = StickyBallState.off;
//     ball2?.removeFromParent();
//     ball = Ball(Vector2(18, 67));
//     add(ball);
//     paddle.reset();
//     obstacles.resetObstacle();
//     fallingBonus.resetFallingBonus();
//
//     if (gameMode == GameMode.challenge) {
//
//       if (fallingStarsMounted == true) {fallingStars?.removeFromParent();}
//       if (fallingPointsMounted == true){fallingPoints?.resetFallingPoints();} else {add(fallingPoints!);}
//
//       if (hudBarMounted == true && hudBarLevelsMounted == true ){
//         print('HUD BAR EXISTS AND HUD BAR LEVELS EXIST');
//
//         hudBarLevels?.removeFromParent();
//         print('HUD BAR levels REMOVED');
//         // if (hudBarLevelsMounted == true) {
//         //   print('HUD BAR Levels EXISTS');
//         //   hudBarLevels?.removeFromParent();
//         //   print('HUD BAR levels REMOVED');
//         // }
//         //fallingStars?.resetFallingStars();
//         // print('STARS RESET');
//         //  if (hudBarLevelsMounted == false) {
//         //    print('HUD BAR LEVELS DOES NOT EXISTS, No NEED FOR DELETE');
//         //    //fallingStars?.resetFallingStars();
//         //  }
//       }
//       if (hudBarMounted == false && hudBarLevelsMounted == true) {
//         print('HUD BAR DOES NOT EXISTS');
//         print('HUD BAR LEVELS EXISTS');
//         print('HUD BAR LEVELS REMOVED');
//         hudBarLevels?.removeFromParent();
//         print('HUD BAR ADDED');
//         add(hudBar!);
//       }
//       // fallingStars?.resetFallingStars();
//       // print('STARS RESET');
//       if (hudBarMounted == false && hudBarLevelsMounted == false) {
//         print('HUD BAR LEVELS DOES NOT EXISTS, No NEED FOR DELETE');
//         //fallingStars?.resetFallingStars();
//         print('HUD BAR ADDED');
//         add(hudBar!);
//       }
//     }
//
//     if (gameMode == GameMode.levels) {
//
//       if (fallingStarsMounted == true) {fallingStars?.resetFallingStars();}else{add(fallingStars!);}
//       if (fallingPointsMounted == true){fallingPoints?.removeFromParent();}
//
//       if (hudBarLevelsMounted == true && hudBarMounted == true ){
//         print('HUD BAR LEVELS EXIST AND HUD BAR EXISTS');
//
//         hudBar?.removeFromParent();
//         print('HUD BAR REMOVED');
//         // if (hudBarLevelsMounted == true) {
//         //   print('HUD BAR Levels EXISTS');
//         //   hudBarLevels?.removeFromParent();
//         //   print('HUD BAR levels REMOVED');
//         // }
//         //fallingStars?.resetFallingStars();
//         // print('STARS RESET');
//         //  if (hudBarLevelsMounted == false) {
//         //    print('HUD BAR LEVELS DOES NOT EXISTS, No NEED FOR DELETE');
//         //    //fallingStars?.resetFallingStars();
//         //  }
//       }
//       if (hudBarLevelsMounted == false && hudBarMounted == true) {
//         print('HUD BAR LEVELS DOES NOT EXISTS');
//         print('HUD BAR EXISTS');
//         print('HUD BAR REMOVED');
//         hudBar?.removeFromParent();
//         print('HUD BAR LEVELS ADDED');
//         add(hudBarLevels!);
//       }
//       // fallingStars?.resetFallingStars();
//       // print('STARS RESET');
//       if (hudBarLevelsMounted == false && hudBarMounted == false) {
//         print('HUD BAR DOES NOT EXISTS, No NEED FOR DELETE');
//         //fallingStars?.resetFallingStars();
//         print('HUD LEVELS BAR ADDED');
//         add(hudBarLevels!);
//       }
//     }
//
//     deadZone.setLives(3);
//     await brickWall.pickWall(level);
//
//     gameState = GameState.ready;
//     life = 3;
//     levelPoints = 0;
//
//     overlays.remove(overlays.activeOverlays.first);
//     overlays.add('PreGame');
//     resumeEngine();
//   }
//   else if (stickyBallOn == 1) {
//     stickyBallState = StickyBallState.off;
//     stickyBallOn = 0;
//     if(ball2Mounted == true){ball2?.removeFromParent();}
//     //paddle.remove(stickyBall!);
//     stickyBall?.removeFromParent();
//     ball = Ball(Vector2(18, 68));
//     await add(ball);
//     paddle.reset();
//     obstacles.resetObstacle();
//     fallingBonus.resetFallingBonus();
//
//     if (gameMode == GameMode.challenge) {
//
//       if (hudBarMounted == true) {
//         print('HUD BAR EXISTS');
//
//         if (hudBarLevelsMounted == true) {
//           print('HUD BAR Levels EXISTS');
//           hudBarLevels?.removeFromParent();
//           print('HUD BAR levels REMOVED');
//         }
//         fallingStars?.resetFallingStars();
//         print('STARS RESET');
//         if (hudBarLevelsMounted == false) {
//           print('HUD BAR LEVELS DOES NOT EXISTS, No NEED FOR DELETE');
//           fallingStars?.resetFallingStars();
//         }
//       }else{
//         print('HUD BAR DOES NOT EXISTS');
//
//         if (hudBarLevelsMounted == true) {
//           print('HUD BAR LEVELS EXISTS');
//           print('HUD BAR LEVELS REMOVED');
//           hudBarLevels?.removeFromParent();
//           print('HUD BAR ADDED');
//           add(hudBar!);
//         }
//         fallingStars?.resetFallingStars();
//         print('STARS RESET');
//         if (hudBarLevelsMounted == false) {
//           print('HUD BAR DOES NOT EXISTS, No NEED FOR DELETE');
//           fallingStars?.resetFallingStars();
//           print('HUD BAR ADDED');
//           add(hudBar!);
//         }
//
//       }
//     }
//
//     if (gameMode == GameMode.levels) {
//
//       if (hudBarLevelsMounted == true) {
//         print('HUD BAR LEVES EXISTS');
//
//         if (hudBarMounted == true) {
//           print('HUD BAR EXISTS');
//           hudBar?.removeFromParent();
//           print('HUD BAR REMOVED');
//         }
//         fallingStars?.resetFallingStars();
//         print('STARS RESET');
//         if (hudBarMounted == false) {
//           print('HUD BAR DOES NOT EXISTS, No NEED FOR DELETE');
//           fallingStars?.resetFallingStars();
//         }
//       }else{
//         print('HUD BAR LEVELS DOES NOT EXISTS');
//
//         if (hudBarMounted == true) {
//           print('HUD BAR EXISTS');
//           print('HUD BAR REMOVED');
//           hudBar?.removeFromParent();
//           print('HUD BAR LEVELES ADDED');
//           add(hudBarLevels!);
//         }
//         fallingStars?.resetFallingStars();
//         print('STARS RESET');
//         if (hudBarMounted == false) {
//           print('HUD BAR DOES NOT EXISTS, No NEED FOR DELETE');
//           fallingStars?.resetFallingStars();
//           print('HUD BAR LEVELES ADDED');
//           add(hudBarLevels!);
//         }
//
//       }
//     }
//
//     deadZone.setLives(3);
//     await brickWall.pickWall(level);
//
//     gameState = GameState.ready;
//     life = 3;
//     levelPoints = 0;
//
//     overlays.remove(overlays.activeOverlays.first);
//     overlays.add('PreGame');
//     resumeEngine();
//     //ballStatus = BallStatus.reset;
//   }
//   else {
//
//     ball.reset();
//     paddle.reset();
//     obstacles.resetObstacle();
//
//     if (gameMode == GameMode.challenge) {
//
//       if (fallingStarsMounted == true) {fallingStars?.removeFromParent();}
//       if (fallingPointsMounted == true){fallingPoints?.resetFallingPoints();} else {add(fallingPoints!);}
//
//       if (hudBarMounted == true && hudBarLevelsMounted == true ){
//         print('HUD BAR EXISTS AND HUD BAR LEVELS EXIST');
//
//         hudBarLevels?.removeFromParent();
//         print('HUD BAR levels REMOVED');
//         // if (hudBarLevelsMounted == true) {
//         //   print('HUD BAR Levels EXISTS');
//         //   hudBarLevels?.removeFromParent();
//         //   print('HUD BAR levels REMOVED');
//         // }
//         //fallingStars?.resetFallingStars();
//         // print('STARS RESET');
//         //  if (hudBarLevelsMounted == false) {
//         //    print('HUD BAR LEVELS DOES NOT EXISTS, No NEED FOR DELETE');
//         //    //fallingStars?.resetFallingStars();
//         //  }
//       }
//       if (hudBarMounted == false && hudBarLevelsMounted == true) {
//         print('HUD BAR DOES NOT EXISTS');
//         print('HUD BAR LEVELS EXISTS');
//         print('HUD BAR LEVELS REMOVED');
//         hudBarLevels?.removeFromParent();
//         print('HUD BAR ADDED');
//         add(hudBar!);
//       }
//       // fallingStars?.resetFallingStars();
//       // print('STARS RESET');
//       if (hudBarMounted == false && hudBarLevelsMounted == false) {
//         print('HUD BAR LEVELS DOES NOT EXISTS, No NEED FOR DELETE');
//         //fallingStars?.resetFallingStars();
//         print('HUD BAR ADDED');
//         add(hudBar!);
//       }
//     }
//
//     if (gameMode == GameMode.levels) {
//
//       if (fallingStarsMounted == true) {fallingStars?.resetFallingStars();}else{add(fallingStars!);}
//       if (fallingPointsMounted == true){fallingPoints?.removeFromParent();}
//
//       if (hudBarLevelsMounted == true && hudBarMounted == true ){
//         print('HUD BAR LEVELS EXIST AND HUD BAR EXISTS');
//
//         hudBar?.removeFromParent();
//         print('HUD BAR REMOVED');
//         // if (hudBarLevelsMounted == true) {
//         //   print('HUD BAR Levels EXISTS');
//         //   hudBarLevels?.removeFromParent();
//         //   print('HUD BAR levels REMOVED');
//         // }
//         //fallingStars?.resetFallingStars();
//         // print('STARS RESET');
//         //  if (hudBarLevelsMounted == false) {
//         //    print('HUD BAR LEVELS DOES NOT EXISTS, No NEED FOR DELETE');
//         //    //fallingStars?.resetFallingStars();
//         //  }
//       }
//       if (hudBarLevelsMounted == false && hudBarMounted == true) {
//         print('HUD BAR LEVELS DOES NOT EXISTS');
//         print('HUD BAR EXISTS');
//         print('HUD BAR REMOVED');
//         hudBar?.removeFromParent();
//         print('HUD BAR LEVELS ADDED');
//         add(hudBarLevels!);
//       }
//       // fallingStars?.resetFallingStars();
//       // print('STARS RESET');
//       if (hudBarLevelsMounted == false && hudBarMounted == false) {
//         print('HUD BAR DOES NOT EXISTS, No NEED FOR DELETE');
//         //fallingStars?.resetFallingStars();
//         print('HUD LEVELS BAR ADDED');
//         add(hudBarLevels!);
//       }
//     }
//
//
//     deadZone.setLives(3);
//     await brickWall.pickWall(level);
//
//     gameState = GameState.ready;
//     life = 3;
//     levelPoints = 0;
//
//     overlays.remove(overlays.activeOverlays.first);
//     overlays.add('PreGame');
//     resumeEngine();
//     //ballStatus = BallStatus.reset;
//   }
// }