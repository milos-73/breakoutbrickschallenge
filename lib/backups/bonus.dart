// import 'package:flame/collisions.dart';
// import 'package:flame/components.dart';
// import 'package:flame/game.dart';
// import 'package:flame/input.dart';
// import 'package:flutter/material.dart' hide Image, Draggable;
// import 'package:initial_project/components/paddle.dart';
// import 'package:initial_project/forge2d_game_world.dart';
//
// class MyCollidable extends PositionComponent with HasGameRef<BrickBreakGame>, CollisionCallbacks {
//   late Vector2 velocity;
//   final _collisionColor = Colors.amber;
//   final _defaultColor = Colors.cyan;
//   late ShapeHitbox hitbox;
//
//   MyCollidable(Vector2 position)
//       : super(
//     position: position,
//    size: Vector2.all(0.5),
//     anchor: Anchor.center,
//   );
//
//   @override
//   Future<void> onLoad() async {
//     final defaultPaint = Paint()
//     ..color = Colors.red
//       ..color = _defaultColor
//       ..style = PaintingStyle.stroke;
//     hitbox = CircleHitbox()
//     ..size = Vector2.all(gameRef.size.y /50)
//       ..paint = defaultPaint
//       ..renderShape = true;
//     add(hitbox);
//     final center = Vector2(5, 200);
//     velocity = (center + position)
//       ..scaleTo(5);
//   }
//
//   @override
//   void update(double dt) {
//     super.update(dt);
//     position.add(velocity * dt);
//   }
//
//   @override
//   void onCollisionStart(Set<Vector2> intersectionPoints,
//       PositionComponent other,) {
//     super.onCollisionStart(intersectionPoints, other);
//
//     if (other is Paddle) {
//       print('RINGtoPADDLE contact');
//       removeFromParent();
//       return;
//     }
//   }
// }