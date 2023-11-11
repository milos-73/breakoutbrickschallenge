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
// class BrickWallBackup extends Component with HasGameRef<Forge2dGameWorld> {
//   final Vector2? position;
//   final Size? size;
//
//
//   // 2
//   BrickWallBackup({this.position, this.size, double? gap,});
//
//   late final List<Color> _colors;
//   late final double gap;
//   List<BrickWall> brickList = [];
//
//   // 3
//   @override
//   Future<void> onLoad() async {
//     _colors = _colorSet(15);
//     await getBricks();
//
//     // var homeScreen = await TiledComponent.load('screen1.tmx', Vector2(gameRef.size.x, gameRef.size.y).normalized());
//     // add(homeScreen);
//
//     await _buildWall();
//
//     // if (gameRef.levelNumber == 2){
//     //   await _buildWall2();
//     //}
//   }
//
//   @override
//   void update(double dt){
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
//
//     }
//     if (children.isEmpty){
//       gameRef.levelNumber = gameRef.levelNumber + 1;
//       gameRef.gameState = GameState.won;
//     }
//     super.update(dt);
//   }
//
//   Future<List<BrickWall>?> getBricks() async {
//     final response = await WallBricks().readBrickListFromJson(3);
//     //print ('BRICK DATA: ${response.brick![0].bricks![0]?.brickColor}');
//     brickList = response.brick!;
//     return brickList;
//
//   }
//
//
//   Future<void> _buildWall() async {
//
//     const int rows = 4;
//     const columns = 12;
//     gap = gameRef.size.x * 0.021;
//
//     // 1
//     final wallSize = size ??
//         Size(
//           gameRef.size.x * 1,
//           gameRef.size.y * 0.35,
//         );

    // 2
    // final brickSize = Size(
    //   ((wallSize.width - gap * 2.0) - (columns - 2) * gap) / columns,
    //   (wallSize.height - (rows - 1) * gap) / rows,
    // );

    // final brickSize = Size(
    //   (wallSize.width) / columns,
    //   ((wallSize.width) / columns)*0.5,
    // );

    // 3
    // var brickPosition = Vector2(
    //   (brickSize.width + gap),
    //   brickSize.height / 2.0 + position!.y,
    // );


//List wall1bricks = [Vector2(brickSize.width + 0.3, brickSize.height / 2.0 + position.y),Vector2((brickSize.width + 0.3)+0.1, brickSize.height / 2.0 + position.y), Vector2((brickSize.width + 0.3) + 0.2, brickSize.height / 2.0 + position.y) ];
    //List <Size>wall1bricks = [const Size(1, 5),const Size(3,5), const Size(5,5), const Size(7,5),const Size(9,5),const Size(11,5),const Size(13,5),const Size(15,5),const Size(17,5),const Size(19,5) ];
    //List <Size>wall1bricks = [Size((wallSize.width) / columns + brickSize.width, 5), Size(wallSize.width/10 + 4 ,5), Size((wallSize.width) / 10 + 4,5), Size((wallSize.width) / 10, 5 + brickSize.height), Size((wallSize.width) / 10, 5 + 2*brickSize.height), Size((wallSize.width) / 10, 5 + 3*brickSize.height),Size((wallSize.width) / 10, 5 + 4*brickSize.height) ];

    //int number =0;
    //for (var i = 0; i < brickList[0].bricks!.length; i++) {

      //double sizeString = '${brickList[0].bricks![6]?.brickPositionX}' as double;

      //print ('SIZE STRING: ${sizeString}');
      //print ('DLZKA LISTU: ${Vector2(double.tryParse(sizeString) ?? 0.0, 5)}');
      //print ('VECTORX: ${'brickList[0].bricks![i]?.brickPositionX'}');
      //print ('VECTOR: ${Vector2(sizeString,5)}');
      // print ('Brick POSITION 0: ${Vector2(((wallSize.width) / columns), double.tryParse(brickList[0].bricks![i]?.brickPositionY ?? '0.0') ?? 0.0)}');
      // print ('Brick POSITION: ${Vector2(i * brickSize.width,5)}');
      //print ('Brick POSITION normalized: ${Vector2((i.width + gap), i.height).normalized()}');
      // print ('GAP: ${gap}');
      // print ('BRICK SIZE: ${brickSize}');
      // print ('BRICK POSITION: ${brickPosition}');
      // print ('Game SIZE: ${gameRef.size}');
      // print ('Game SIZE Normalized: ${gameRef.size.normalized()}');
      // print ('Brick VYSKA: ${brickSize.height}');
      // print ('NUMBER: ${i}');
      // print (i.width);
      // print (i.height);
      //number++;
    //
    //   await add(Brick2(
    //     size: brickSize,
    //     position: Vector2((i * brickSize.width)+1, double.tryParse(brickList[0].bricks![i]?.brickPositionY ?? '0.0') ?? 0.0),
    //     //color: _colors[i],
    //     //color: Colors.grey,
    //   ));}
    //
    // for (var i = 0; i < brickList[0].bricks!.length; i++) {
    //
    //   await add(Brick(
    //     spriteName: '_0006_Green3.png',
    //     size: brickSize,
    //     position: Vector2((i * brickSize.width)+1, double.tryParse(brickList[0].bricks![i]?.brickPositionY ?? '0.0')! + brickSize.height),
    //     //color: Colors.green,
    //   ));}
    //
    // for (var i = 0; i < brickList[0].bricks!.length; i++) {
    //
    //   await add(Brick(
    //     spriteName: '_0006_Green3.png',
    //     size: brickSize,
    //     position: Vector2((i * brickSize.width)+1, double.tryParse(brickList[0].bricks![i]?.brickPositionY ?? '0.0')! - brickSize.height ?? 0.0),
    //     //color: Colors.green,
    //   ));}
    // 4
    // for (var i = 0; i < 1; i++) {
    //   for (var j = 0; j < columns; j++) {
    //     await add(Brick(
    //       size: brickSize,
    //       position: brickPosition,
    //       color: _colors[i],
    //     ));
    //     brickPosition += Vector2(brickSize.width + gap, 0.0);
    //   }
    //   brickPosition += Vector2( (brickSize.width + gap) - brickPosition.x, brickSize.height + gap,);
    // }
    //
    // for (var i = 1; i < 2; i++) {
    //   for (var j = 0; j < columns - 3; j++) {
    //     await add(Brick(
    //       size: brickSize,
    //       position: brickPosition,
    //       color: _colors[i],
    //     ));
    //     brickPosition += Vector2(gap + brickSize.width + gap / 0.3, 0.0);
    //   }
    //   brickPosition += Vector2( (brickSize.width + gap) - brickPosition.x, brickSize.height + gap,);
    // }
    //
    // for (var i = 2; i < 3; i++) {
    //   for (var j = 0; j < columns -3; j++) {
    //     await add(Brick(
    //       size: brickSize,
    //       position: brickPosition,
    //       color: _colors[i],
    //     ));
    //     brickPosition += Vector2(gap + brickSize.width + gap / 0.3, 0.0);
    //   }
    //   brickPosition += Vector2( (brickSize.width + gap) - brickPosition.x, brickSize.height + gap,);
    // }
    //
    // for (var i = 3; i < 4; i++) {
    //   for (var j = 0; j < columns; j++) {
    //     await add(Brick(
    //       size: brickSize,
    //       position: brickPosition,
    //       color: _colors[i],
    //     ));
    //     brickPosition += Vector2(brickSize.width + gap, 0.0);
    //   }
    //   brickPosition += Vector2( (brickSize.width + gap) - brickPosition.x, brickSize.height + gap,);
    // }
    //
    // for (var i = 5; i < 6; i++) {
    //   for (var j = 0; j < columns - 3; j++) {
    //     await add(Brick(
    //       size: brickSize,
    //       position: brickPosition,
    //       color: _colors[i],
    //     ));
    //     brickPosition += Vector2(gap + brickSize.width + gap / 0.3, 0.0);
    //   }
    //   brickPosition += Vector2( (brickSize.width + gap) - brickPosition.x, brickSize.height + gap,);
    // }
    //
    // for (var i = 6; i < 7; i++) {
    //   for (var j = 0; j < columns-3; j++) {
    //     await add(Brick(
    //       size: brickSize,
    //       position: brickPosition,
    //       color: _colors[i],
    //     ));
    //     brickPosition += Vector2(gap + brickSize.width + gap / 0.3, 0.0);
    //   }
    //   brickPosition += Vector2( (brickSize.width + gap) - brickPosition.x, brickSize.height + gap,);
    // }
    //
    // for (var i = 7; i < 8; i++) {
    //   for (var j = 0; j < columns; j++) {
    //     await add(Brick(
    //       size: brickSize,
    //       position: brickPosition,
    //       color: _colors[i],
    //     ));
    //     brickPosition += Vector2(brickSize.width + gap, 0.0);
    //   }
    //   brickPosition += Vector2( (brickSize.width + gap) - brickPosition.x, brickSize.height + gap,);
    // }

  //}


  // Future<void> _buildWall1() async {
  //
  //   const rows = 6;
  //   const columns = 6;
  //   //const gap = 0.2;
  //
  //   // 1
  //   final wallSize = size ??
  //       Size(
  //         gameRef.size.x,
  //         gameRef.size.y * 0.25,
  //       );
  //
  //   // 2
  //   final brickSize = Size(
  //     ((wallSize.width - gap * 2.0) - (columns - 1) * gap) / columns,
  //     (wallSize.height - (rows - 1) * gap) / rows,
  //   );
  //
  //   // 3
  //   var brickPosition = Vector2(
  //     brickSize.width / 2.0 + gap,
  //     brickSize.height / 2.0 + position.y,
  //   );
  //
  //   // 4
  //   for (var i = 0; i < rows; i = i++) {
  //     for (var j = 0; j < columns; j++) {
  //       await add(Brick(
  //         size: brickSize,
  //         position: brickPosition,
  //         color: _colors[i],
  //       ));
  //       brickPosition += Vector2(brickSize.width + gap, 0.0);
  //     }
  //     brickPosition += Vector2(
  //       (brickSize.width / 2.0 + gap) - brickPosition.x,
  //       brickSize.height + gap,
  //     );
  //   }
  // }

//   Future<void> reset() async {
//     removeAll(children);
//
//     int? level = gameRef.levelNumber;
//
//     if (level == 1){
//       await _buildWall();
//     }
//     if (level == 2){
//       //   await _buildWall2();
//     }
//   }
//
//   // Generate a set of colors for the bricks that span a range of colors.
//   // This color generator creates a set of colors spaced across the
//   // color spectrum.
//   static const transparency = 1.0;
//   static const saturation = 0.85;
//   static const lightness = 0.5;
//
//   List<Color> _colorSet(int count) => List<Color>.generate(
//     count,
//         (int index) => HSLColor.fromAHSL(
//       transparency,
//       index / count * 360.0,
//       saturation,
//       lightness,
//     ).toColor(),
//     growable: false,
//   );
// }