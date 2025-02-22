import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../forge2d_game_world.dart';
import '../services/ad_helper.dart';

class ChallengeGameOverOverlay extends StatefulWidget {
  final BrickBreakGame game;

  const ChallengeGameOverOverlay({
    super.key,
    required this.game,
  });

  @override
  State<ChallengeGameOverOverlay> createState() => _ChallengeGameOverOverlayState();
}

class _ChallengeGameOverOverlayState extends State<ChallengeGameOverOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isBoxVisible = false;
  Random random = new Random();

  static const int maxFailedLoadAttempts = 3;
  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempts = 1;

  late String reply;
  String reply1 = 'assets/images/buttons/restartButton.png';
  String reply2 = 'assets/images/buttons/restartButton_hover.png';

  late String imgMainMenu;
  String imgMainMenu1 = 'assets/images/buttons/mainMenuButton.png';
  String imgMainMenu2 = 'assets/images/buttons/mainMenuButton_hover.png';

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
    if(widget.game.overlays.isActive('ChallengeGameOverOverlay')){widget.game.overlays.remove('ChallengeGameOverOverlay');}
    widget.game.overlays.add('MainMenu');
  }

  Future<void> _replyOverlays() async {
    if(widget.game.overlays.isActive('ChallengeGameOverOverlay')){widget.game.overlays.remove('ChallengeGameOverOverlay');}

    int level = await widget.game.randomChallengeWallNumber();
    await widget.game.prefs.setInt('challengeLevel', level);
    widget.game.challengeCurrentLevel = level;
    await widget.game.pickLevel(level);

    }

  void _showInterstitialAdMainMenu() {
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
    else {_mainMenuOverlays();}
  }

  void _showInterstitialAdReplay() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _replyOverlays();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _replyOverlays();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
    }
    else {_replyOverlays();}
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
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/bg/lostHeading.png',height: (widget.game.camera.viewport.canvasSize?.y)!/10),
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
      _showInterstitialAdMainMenu();
    },
      onTapUp: (tap) {
        setState(() {
          imgMainMenu = imgMainMenu1;
        });
      },

      onLongPress: () {
        setState(() {
          imgMainMenu = imgMainMenu2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          imgMainMenu = imgMainMenu1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          imgMainMenu = imgMainMenu2;
        });
      },
      child: Image.asset(imgMainMenu, height: (widget.game.camera.viewport.canvasSize?.y)!/15),
    );
  }

  Widget _resetButton(BuildContext context, BrickBreakGame game) {
    return GestureDetector(

      onTapDown: (tap) async {
      setState(() {
        reply = reply2;
      });
      if (game.audioSettings == AudioSettings.on) {
        await FlameAudio.play('button3.mp3');
      }
      _showInterstitialAdReplay();
        },

      onTapUp: (tap) async {
        setState(() {
          reply = reply1;
        });

      },
      onLongPress: () {
        setState(() {
          reply = reply2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          reply = reply1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          reply = reply2;
        });
      },

      child: Image.asset(reply, height: (widget.game.camera.viewport.canvasSize?.y)!/15),
    );
  }
  }