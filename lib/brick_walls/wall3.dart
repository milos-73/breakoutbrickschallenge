// import 'package:flutter/material.dart';
// import 'package:flame/components.dart';
// import 'package:initial_project/brick_walls/brick_wall_json_model.dart';
// import 'package:initial_project/brick_walls/get_wall_bricks.dart';
// import '../components/brick.dart';
// import '../components/brick2.dart';
// import '../forge2d_game_world.dart';
//
//
// // 1
// class BrickWall3 extends Component with HasGameRef<BrickBreakGame> {
//   final Vector2? position;
//   final Size? size;
//
//
//   // 2
//   BrickWall3({this.position, this.size, double? gap,});
//
//   late final List<Color> _colors;
//   //late final double gap;
//   List<BrickWall> brickList = [];
//
//   // 3
//   @override
//   Future<void> onLoad() async {
//
//     //await getBricks();
//
//     // var homeScreen = await TiledComponent.load('screen1.tmx', Vector2(gameRef.size.x, gameRef.size.y).normalized());
//     // add(homeScreen);
//
//     await _buildWall();
//
//   }
//
//   @override
//   Future<void> update(double dt) async {
//     for (final child in [... children]){
//       if (child is Brick && child.destroy){
//         for ( final fixture in [...child.body.fixtures]){
//           child.body.destroyFixture(fixture);
//         }
//         gameRef.world.destroyBody(child.body);
//         remove(child);
//       }
//       if (child is Brick2 && child.destroy){
//         for ( final fixture in [...child.body.fixtures]){
//           child.body.destroyFixture(fixture);
//         }
//         gameRef.world.destroyBody(child.body);
//         remove(child);
//       }
//
//     }
//     if (children.isEmpty){
//       if (gameRef.lastFinishedLevel == gameRef.playedGameLevelNumber){
//         await gameRef.prefs.setInt('levelNumber', gameRef.lastFinishedLevel + 1);
//         await gameRef.prefs.setInt('playedLevelNumber', gameRef.playedGameLevelNumber + 1);
//         gameRef.gameState = GameState.won;
//       } else {
//         await gameRef.prefs.setInt('playedLevelNumber', gameRef.playedGameLevelNumber + 1);
//         gameRef.gameState = GameState.won;}
//
//     }
//     super.update(dt);
//   }
//
//   Future<List<BrickWall>?> getBricks() async {
//     final response = await WallBricks().readBrickListFromJson(3);
//     //print ('BRICK DATA: ${response.brick![0].bricks![0]?.brickColor}');
//     brickList = response.brick!;
//     return brickList;
//   }
//
//   Future<void> _buildWall() async {
//
//     const int rows = 4;
//     const columns = 10;
//     //gap = gameRef.size.x * 0.021;
//
//     // 1
//     final wallSize = size ??
//         Size(
//           gameRef.size.x * 1,
//           gameRef.size.y * 0.35,
//         );
//
//     final brickSize = Size(
//       (wallSize.width) / columns,
//       ((wallSize.width) / columns)*0.5,
//     );
//
//     final List brickList = ['_0011_Purple.png', '_0004_Blue3.png','_0012_Blue.png','_0007_Yellow.png', '_0008_Red2.png'];
//     var spriteImage = 0;
//
//     for (var j = 0; j < 8; j++)
//
//     {
//
//       for (var i = 0; i < 4; i++) {
//
//
//         if (spriteImage == brickList.length) {spriteImage = 0;}
//
//         await add(Brick(
//             spriteName: 'bricks/${brickList[spriteImage]}',
//             //spriteName: 'bricks/_0010_Gold.png',
//             size: brickSize,
//             position: Vector2((i * brickSize.width)+2, (j * 1)+2)
//         ));
//
//         await add(Brick(
//             spriteName: 'bricks/${brickList[spriteImage]}',
//             //spriteName: 'bricks/_0010_Gold.png',
//             size: brickSize,
//             position: Vector2((gameRef.size.x - 2) - (i * brickSize.width), (j * 1)+2)
//
//         ));
//         //print('2.stlpec: ${Vector2((gameRef.size.x - 2) - (i * brickSize.width), (j * 1)+2)}');
//
//
//         spriteImage = spriteImage + 1;
//       }
//
//     }
//
//   }
//
//   Future<void> resetWall() async {
//     removeAll(children);
//     //await _buildWall();
//   }
// }