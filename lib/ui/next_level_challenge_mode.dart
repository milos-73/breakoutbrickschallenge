
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../forge2d_game_world.dart';
import '../services/ad_helper.dart';

class NextLevelChallengeModeOverlay extends StatefulWidget {
  //final String message;
  final BrickBreakGame game;

  const NextLevelChallengeModeOverlay({
    super.key,
    //required this.message,
    required this.game,
  });

  @override
  State<NextLevelChallengeModeOverlay> createState() => _NextLevelChallengeModeOverlayState();
}

class _NextLevelChallengeModeOverlayState extends State<NextLevelChallengeModeOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isBoxVisible = false;

  static const int maxFailedLoadAttempts = 3;
  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempts = 1;

  late String reply;
  String reply1 = 'assets/images/buttons/restartButton.png';
  String reply2 = 'assets/images/buttons/restartButton_hover.png';

  late String imgMainMenu;
  String imgMainMenu1 = 'assets/images/buttons/mainMenuButton.png';
  String imgMainMenu2 = 'assets/images/buttons/mainMenuButton_hover.png';

  late String nextLevel;
  String nextLevel1 = 'assets/images/buttons/nextLevelButton.png';
  String nextLevel2 = 'assets/images/buttons/nextLevelButton_hover.png';


  @override
  void initState() {
    print('WIN CHALLENGE LEVEL OVERLAY: ${widget.game.gameState}');

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
    nextLevel = nextLevel1;
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
    if(widget.game.overlays.isActive('NextLevelChallengeModeOverlay')){widget.game.overlays.remove('NextLevelChallengeModeOverlay');}
    widget.game.overlays.add('MainMenu');
      }

  Future<void> _replyOverlays() async {
    if(widget.game.overlays.isActive('NextLevelChallengeModeOverlay')){widget.game.overlays.remove('NextLevelChallengeModeOverlay');}
    widget.game.resetGame();
    await widget.game.pickLevel(1);
  }

  Future<void> _nextLevelOverlays() async {
    widget.game.levelPoints = 0;
    if(widget.game.overlays.isActive('NextLevelChallengeModeOverlay')){widget.game.overlays.remove('NextLevelChallengeModeOverlay');}
    widget.game.nextLevel(level: widget.game.challengeCurrentLevel);
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
  }

  void _showInterstitialAdNextLevel() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _nextLevelOverlays();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _nextLevelOverlays();
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
      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SlideTransition(
            position: _animation,
            child: Stack(alignment: Alignment.center,
              children: [
                Container(width: widget.game.camera.viewport.effectiveSize.x, height: (widget.game.camera.viewport.canvasSize?.y)!/2, color: Colors.black.withOpacity(0.4),),
                const SizedBox(width: 300, height: 150,),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/bg/winHeading.png',height: (widget.game.camera.viewport.canvasSize?.y)!/9),
                      //Container(width: 350, height: 160, decoration: const BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/bg/levelCleared.png'),fit: BoxFit.contain)),),
                      _nextLevelButton(context, widget.game),
                      _resetButton(context, widget.game),
                      _mainMenuButton(context, widget.game),
                    ],
                  ),
                )],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainMenuButton(BuildContext context, BrickBreakGame game) {
    return GestureDetector(

      onTapDown: (tap) async {setState(() {
        imgMainMenu = imgMainMenu2;
      });
      if (game.audioSettings == AudioSettings.on) {
        await FlameAudio.play('button3.mp3');
      }
      _showInterstitialAdMainMenu();
      // widget.game.pauseEngine();
      // widget.game.gameState = GameState.paused;
      // if(widget.game.overlays.isActive('NextLevelChallengeModeOverlay')){widget.game.overlays.remove('NextLevelChallengeModeOverlay');}
      // widget.game.overlays.add('MainMenu');

        },
      onTapUp: (tap){setState(() {
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
    return GestureDetector(

      onTapDown: (tap) async {setState(() {
        reply = reply2;
       });
        //game.totalPointsInCurrentGame = 0;
      if (game.audioSettings == AudioSettings.on) {
        await FlameAudio.play('button3.mp3');
       }
      _showInterstitialAdReplay();
      // widget.game.resetGame();
      // await widget.game.pickLevel(1);
      },

      onTapUp: (tap){setState(() {
        reply = reply1;
      });},

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

  Widget _nextLevelButton(BuildContext context, BrickBreakGame game) {
    return GestureDetector(

      onTapDown: (tap) async {setState(() {
        nextLevel = nextLevel2;

       });
      if (game.audioSettings == AudioSettings.on) {
        await FlameAudio.play('button3.mp3');
      }
      _showInterstitialAdNextLevel();
      game.levelPoints = 0;
      game.nextLevel(level: game.challengeCurrentLevel);
        },

      onTapUp: (tap){setState(() {
        nextLevel = nextLevel1;
      });},

      onLongPress: () {
        setState(() {
          print('LONG PRESS');
          nextLevel = nextLevel2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          print('onLongPressStart');
          nextLevel = nextLevel1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          print('onLongPressDown');
          nextLevel = nextLevel2;
        });
      },


      child: Image.asset(nextLevel, height: (widget.game.camera.viewport.canvasSize?.y)!/15),
    );
  }

}