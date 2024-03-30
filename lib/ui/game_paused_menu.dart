import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../forge2d_game_world.dart';
import '../services/ad_helper.dart';
import 'overlay_builder.dart';

class GamePausedMenuOverlay extends StatefulWidget {
  //final String message;
  final BrickBreakGame game;

  const GamePausedMenuOverlay({
    super.key,
    //required this.message,
    required this.game,
  });

  @override
  State<GamePausedMenuOverlay> createState() => _GamePausedMenuOverlayState();
}

late int currentGameLevel;
const int maxFailedLoadAttempts = 3;

class _GamePausedMenuOverlayState extends State<GamePausedMenuOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isBoxVisible = false;
  Random random = new Random();

  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempts = 1;

  late String reply;
  String reply1 = 'assets/images/buttons/restartButton.png';
  String reply2 = 'assets/images/buttons/restartButton_hover.png';

  late String imgMainMenu;
  String imgMainMenu1 = 'assets/images/buttons/mainMenuButton.png';
  String imgMainMenu2 = 'assets/images/buttons/mainMenuButton_hover.png';

  late String resume;
  String resume1 = 'assets/images/buttons/resumeButton.png';
  String resume2 = 'assets/images/buttons/resumeButton_hover.png';

  late String pickLevel;
  String pickLevel1 = 'assets/images/buttons/pickLevelButton.png';
  String pickLevel2 = 'assets/images/buttons/pickLevelButton_hover.png';


  @override
  void initState() {

    super.initState();

    _createInterstitialAd();

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
    resume = resume1;
    pickLevel = pickLevel1;
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId2,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  Future<void> _mainMenuOverlays() async {

    widget.game.pauseEngine();
    widget.game.gameState = GameState.paused;
    if(widget.game.overlays.isActive('GamePausedMenuOverlay')){widget.game.overlays.remove('GamePausedMenuOverlay');}
    widget.game.overlays.add('MainMenu');
 }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _mainMenuOverlays();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _mainMenuOverlays();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
    }
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
              children: [
                Container(width: widget.game.camera.viewport.effectiveSize.x, height: (widget.game.camera.viewport.canvasSize?.y)!/2, color: Colors.black.withOpacity(0.4),),
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
                      Image.asset('assets/images/bg/gamePaused.png',height: (widget.game.camera.viewport.canvasSize?.y)!/6.5),
                      _resumeButton(context, widget.game),
                      _resetButton(context, widget.game),
                      if (widget.game.gameMode == GameMode.levels) _pickLevelButton(context, widget.game),
                      _mainMenuButton(context, widget.game),
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

  Widget _resumeButton(BuildContext context, BrickBreakGame game) {
    return GestureDetector(onTapDown: (tap) async {
      setState(() {
        resume = resume2;
      });

      if (game.audioSettings == AudioSettings.on) {
        await FlameAudio.play('button3.mp3');
      }

      if(widget.game.overlays.isActive('GamePausedMenuOverlay')){widget.game.overlays.remove('GamePausedMenuOverlay');}

      if(widget.game.pauseButtonState == PauseButtonState.startGame){widget.game.overlays.add('PreGame'); widget.game.gameState = GameState.ready; widget.game.resumeEngine();}

      if(game.ballState == BallState.lost){
        game.lostBallReset();
      }

      widget.game.resumeEngine();

    },
      onTapUp: (tap) {
        setState(() {
          resume = resume1;
        });
      },
      onLongPress: () {
        setState(() {
          print('LONG PRESS');
          resume = resume2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          print('onLongPressStart');
          resume = resume1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          print('onLongPressDown');
          resume = resume2;
        });
      },

      child: Image.asset(resume, height: (widget.game.camera.viewport.canvasSize?.y)!/17),
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
        _showInterstitialAd();
        // widget.game.pauseEngine();
        // widget.game.gameState = GameState.paused;
        // if(widget.game.overlays.isActive('GamePausedMenuOverlay')){widget.game.overlays.remove('GamePausedMenuOverlay');}
        // _showInterstitialAd();
        // widget.game.overlays.add('MainMenu');

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
      child: Image.asset(imgMainMenu, height: (widget.game.camera.viewport.canvasSize?.y)!/17),
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
      currentGameLevel = game.prefs.getInt('currentPlayedLevelNumber') ?? 1;
      if(widget.game.overlays.isActive('GamePausedMenuOverlay')){widget.game.overlays.remove('GamePausedMenuOverlay');}
      if (game.gameMode == GameMode.levels){await widget.game.pickLevel(currentGameLevel);}
      if (game.gameMode == GameMode.challenge){await widget.game.pickLevel(random.nextInt(5) + 1);}

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

      child: Image.asset(reply, height: (widget.game.camera.viewport.canvasSize?.y)!/17),
    );
  }
  Widget _pickLevelButton(BuildContext context, BrickBreakGame game) {
    return GestureDetector(

      onTapDown: (tap) async {
        setState(() {
          pickLevel = pickLevel2;
          //game.nextLevel();
        });
        if (game.audioSettings == AudioSettings.on) {
          await FlameAudio.play('button3.mp3');
        }
        widget.game.pauseEngine();
        widget.game.gameState = GameState.paused;
        if(widget.game.overlays.isActive('WinGame')){widget.game.overlays.remove('WinGame');}
        if(widget.game.overlays.isActive('GamePausedMenuOverlay')){widget.game.overlays.remove('GamePausedMenuOverlay');}
        game.overlays.add('LevelsMap');
      },

      onTapUp: (tap) {
        setState(() {
          pickLevel = pickLevel1;
        });
      },

      onLongPress: () {
        setState(() {
          print('LONG PRESS');
          pickLevel = pickLevel2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          print('onLongPressStart');
          pickLevel = pickLevel1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          print('onLongPressDown');
          pickLevel = pickLevel2;
        });
      },


      child: Image.asset(pickLevel, height: (widget.game.camera.viewport.canvasSize?.y)!/17),
    );
  }
}