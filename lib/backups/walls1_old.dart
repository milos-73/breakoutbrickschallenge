// import 'package:flutter/material.dart';
// import 'package:flame/components.dart';
// import 'package:initial_project/forge2d_game_world.dart';
//
// import 'brick.dart';
//
//
// mixin Wall on Component{
//
//   Future<void> buildWall(BrickBreakGame gameRef,
//       double distanceFromTop) async {
//     const int rows = 4;
//     const columns = 11;
//     //gap = gameRef.size.x * 0.021;
//
//     // 1
//     final wallSize =
//     Size(
//       gameRef.size.x * 1,
//       gameRef.size.y * 0.35,
//     );
//
//     final brickSize = Size(
//       (wallSize.width) / columns,
//       ((wallSize.width) / columns) * 0.5,
//     );
//     add(Brick(
//         spriteName: 'bricks/_0006_Green3.png',
//         size: brickSize,
//         position: Vector2(3, 5+distanceFromTop)));
//     add(Brick(
//         spriteName: 'bricks/_0006_Green3.png',
//         size: brickSize,
//         position: Vector2(5, 8+distanceFromTop)));
//   }
//
//   Future<void> buildWall2(BrickBreakGame gameRef,
//       double distanceFromTop) async {
//     const int rows = 4;
//     const columns = 11;
//     //gap = gameRef.size.x * 0.021;
//
//     // 1
//     final wallSize =
//     Size(
//       gameRef.size.x * 1,
//       gameRef.size.y * 0.35,
//     );
//
//     final brickSize = Size(
//       (wallSize.width) / columns,
//       1
//       //((wallSize.height) / rows) * 0.5,
//     );
//     add(Brick(
//         spriteName: 'bricks/_0006_Green3.png',
//         size: brickSize,
//         position: Vector2(3, 5+distanceFromTop)));
//     add(Brick(
//         spriteName: 'bricks/_0006_Green3.png',
//         size: brickSize,
//         position: Vector2(5, 8+distanceFromTop)));
//
//     add(Brick(
//         spriteName: 'bricks/_0006_Green3.png',
//         size: brickSize,
//         position: Vector2(6, 7+distanceFromTop)));
//   }
//
//   Future<void> buildWall4(BrickBreakGame gameRef,
//       double distanceFromTop) async {
//
//     const int rows = 4;
//     const columns = 10;
//
//
//     // 1
//     final wallSize =
//     Size(
//       gameRef.size.x * 1,
//       gameRef.size.y * 0.35,
//     );
//
//     const brickSize = Size(3.2,1.6);
//
//     final List brickList = ['blue1.png', 'green1.png','orange1.png','yellow1.png', 'red1.png'];
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
//             spriteName: 'bricks2/${brickList[spriteImage]}',
//             //spriteName: 'bricks/_0010_Gold.png',
//             size: brickSize,
//             position: Vector2((i * brickSize.width+3), (j * brickSize.height)+2+distanceFromTop)
//         ));
//
//         await add(Brick(
//             spriteName: 'bricks2/${brickList[spriteImage]}',
//             //spriteName: 'bricks/_0010_Gold.png',
//             size: brickSize,
//             position: Vector2((gameRef.size.x - 3) - (i * brickSize.width), (j * brickSize.height)+2+distanceFromTop)
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
//
//   }
//
//   Future<void> buildWall3(BrickBreakGame gameRef,
//       double distanceFromTop) async {
//
//     const brickSize = Size(3,1.6);
//
//     final List brickList = [
//       [1,2,0,2,3,1,0,2,2,0,2],
//       [3,2,2,0,1,1,2,0,3,1,0],
//       [0,0,0,0,0,1,1,1,0,0,0],
//       [2,2,3,0,0,1,1,2,3,1,3],
//       [],
//       [3,2,1,1,0,3,0,3,1,2,3],
//       [],
//       [1,2,0,2,3,1,0,2,2,0,2],
//       [3,2,2,0,1,1,2,0,3,1,0],
//       [0,0,0,0,0,1,1,1,0,0,0],
//       [2,2,3,0,0,1,1,2,3,1,3],
//       [],
//       [3,2,1,1,0,3,0,3,1,2,3],
//       [],
//       [1,2,0,2,3,1,0,2,2,0,2],
//       [3,2,2,0,1,1,2,0,3,1,0],
//       [0,0,0,0,0,1,1,1,0,0,0],
//       [2,2,3,0,0,1,1,2,3,1,3],
//       [],
//       [3,2,1,1,0,3,0,3,1,2,3],
//     ];
//
//     for (var r = 0; r < brickList.length; r++){
//       if (brickList == []){continue;}
//       for (var c = 0; c < brickList[r].length; c++) {
//       var brick = await getBrick(brickList[r][c]);
//       if (brick == '') {continue;}
//
//       await add(Brick(
//           spriteName: 'bricks2/$brick',
//          size: brickSize,
//           position: Vector2(
//               (c * brickSize.width) + 3, ((r * brickSize.height) + 20))
//       ));
//     }
//      }
//   }
//
//   ///CHOOSE BRICK
//   Future<String> getBrick(int brickType) async {
//
//     //final brickWallPosition = Vector2(0.1, gameRef.size.y * 0.075);
//     const hudSize = 7.0;
//     const bannerSize = 7.0;
//     const distanceFromTop = hudSize+bannerSize;
//
//     switch (brickType) {
//       case 1:
//         String brick = 'blue1.png';
//         return brick;
//       case 2:
//         String brick = 'green1.png';
//         return brick;
//       case 3:
//         String brick = 'orange1.png';
//         return brick;
//       default:
//         String brick = '';
//         return brick;
//     }
//   }
//
// }