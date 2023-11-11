import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../forge2d_game_world.dart';
import 'overlay_builder.dart';

class ChallengeGameOverOverlay extends StatefulWidget {
  //final String message;
  final BrickBreakGame game;

  const ChallengeGameOverOverlay({
    super.key,
    //required this.message,
    required this.game,
  });

  @override
  State<ChallengeGameOverOverlay> createState() => _ChallengeGameOverOverlayState();
}

class _ChallengeGameOverOverlayState extends State<ChallengeGameOverOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isBoxVisible = false;

  late String reply;
  String reply1 = 'assets/images/buttons/restartButton.png';
  String reply2 = 'assets/images/buttons/restartButton_hover.png';

  late String imgMainMenu;
  String imgMainMenu1 = 'assets/images/buttons/mainMenuButton.png';
  String imgMainMenu2 = 'assets/images/buttons/mainMenuButton_hover.png';


  @override
  void initState() {
    print('WIN CHALLENGE LEVEL OVERLAY: ${widget.game.gameState}');

    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _toggleBoxVisibility();
    imgMainMenu = imgMainMenu1;
    reply = reply1;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleBoxVisibility() {
    setState(() {
      _isBoxVisible = !_isBoxVisible;
      if (_isBoxVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SlideTransition(
            position: _animation,
            child: Stack(alignment: Alignment.center,
              children: [Container(width: widget.game.camera.viewport.effectiveSize.x, height: (widget.game.camera.viewport.canvasSize?.y)!/2.3, color: Colors.black.withOpacity(0.4),),
                const SizedBox(width: 250, height: 150,
                  // decoration: const BoxDecoration(image: DecorationImage(
                  //     image: AssetImage('assets/images/bg/gameOverMenu.png'),
                  //     fit: BoxFit.contain)),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/bg/lostHeading.png',height: (widget.game.camera.viewport.canvasSize?.y)!/10),
                      //Container(width: 300, height: 80, decoration: const BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/bg/lostHeading.png'),fit: BoxFit.contain) ),),
                      _mainMenuButton(context, widget.game),
                      _resetButton(context, widget.game),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainMenuButton(BuildContext context, BrickBreakGame game) {
    return GestureDetector(
      onTapDown: (tap) async {
      setState(() {
        imgMainMenu = imgMainMenu2;
      });
      if (game.audioSettings == AudioSettings.on) {
        await FlameAudio.play('button3.mp3');
      }
      widget.game.pauseEngine();
      widget.game.gameState = GameState.paused;
      if(widget.game.overlays.isActive('ChallengeGameOverOverlay')){widget.game.overlays.remove('ChallengeGameOverOverlay');}
      widget.game.overlays.add('MainMenu');
    },
      onTapUp: (tap) {
        setState(() {
          imgMainMenu = imgMainMenu1;
        });
      },

      onLongPress: () {
        setState(() {
          print('LONG PRESS');
          imgMainMenu = imgMainMenu2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          print('onLongPressStart');
          imgMainMenu = imgMainMenu1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          print('onLongPressDown');
          imgMainMenu = imgMainMenu2;
        });
      },
      child: Image.asset(imgMainMenu, height: (widget.game.camera.viewport.canvasSize?.y)!/15),
    );
  }

  Widget _resetButton(BuildContext context, BrickBreakGame game) {
    return GestureDetector(onTapDown: (tap) async {
      setState(() {
        reply = reply2;
      });
      if (game.audioSettings == AudioSettings.on) {
        await FlameAudio.play('button3.mp3');
      }
      //widget.game.resetGame();
      if(widget.game.overlays.isActive('ChallengeGameOverOverlay')){widget.game.overlays.remove('ChallengeGameOverOverlay');}
      await widget.game.pickLevel(1);
    },
      onTapUp: (tap) {
        setState(() {
          reply = reply1;
        });
      },
      onLongPress: () {
        setState(() {
          print('LONG PRESS');
          reply = reply2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          print('onLongPressStart');
          reply = reply1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          print('onLongPressDown');
          reply = reply2;
        });
      },

      child: Image.asset(reply, height: (widget.game.camera.viewport.canvasSize?.y)!/15),
    );
  }
  }