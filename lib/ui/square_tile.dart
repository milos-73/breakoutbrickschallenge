import 'package:flutter/material.dart';
import 'package:initial_project/forge2d_game_world.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onTap;
  final BrickBreakGame game;
  final String buttonText;

  const SquareTile({
    super.key,
    required this.imagePath,
    required this.onTap,
    required this.game,
    required this.buttonText
  });

  @override
  Widget build(BuildContext context) {
    print('ON TAP: ${onTap}');
    return GestureDetector(onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey[200],
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              height: (game.camera.viewport.canvasSize?.y)!/30,
            ),
            SizedBox(width: (game.camera.viewport.canvasSize?.y)!/40,),
            Flexible(child: Text(buttonText, style: const TextStyle(color: Colors.black,fontSize: 17),softWrap: false, overflow: TextOverflow.fade,maxLines: 1,))
          ],
        ),
      ),
    );
  }
}