import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../forge2d_game_world.dart';

class BlackScreen extends StatelessWidget {
  final BrickBreakGame gameRef;

  const BlackScreen({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        ));
  }
}
