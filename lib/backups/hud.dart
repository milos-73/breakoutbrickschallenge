// import 'dart:ui';
//
// import 'package:flame/cache.dart';
// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/input.dart';
// import 'package:initial_project/components/pause_button.dart';
//
// import '../components/back_to_menu_button.dart';
// import '../components/life_counter.dart';
// import '../forge2d_game_world.dart';
//
// class Hud extends PositionComponent with Tappable,HasGameRef<BrickBreakGame> {
//
//   late final TextComponent lifeCounter;
//
//   Hud({
//     super.position,
//     super.size,
//     super.scale,
//     super.angle,
//     super.anchor,
//     super.children,
//     super.priority = 10,
//   }) {
//     positionType = PositionType.game;
//   }
//
//   late TextComponent _liveCounter;
//
//
//   @override
//   Future<void> onLoad() async {
//
//     _liveCounter = LifeCounter();
//
//     await add(_liveCounter);
// }
//
// }