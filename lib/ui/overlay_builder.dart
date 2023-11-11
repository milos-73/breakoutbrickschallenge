import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:initial_project/overlays/main_menu.dart';
import 'package:initial_project/ui/sign_with_google.dart';
import 'package:initial_project/ui/welcome_user.dart';
import '../forge2d_game_world.dart';
import '../overlays/banner_ad_overlay.dart';
import '../overlays/black_screen.dart';
import '../overlays/friendsList.dart';
import '../overlays/google_signin.dart';
import '../overlays/leaderBoard.dart';
import '../overlays/searching_friend_text_field.dart';
import 'challeneg_game_over.dart';
import 'game_paused_menu.dart';
import 'my_account_overlay.dart';
import 'levels.dart';
import 'next_level_challenge_mode.dart';

// 1
class OverlayBuilder {

  OverlayBuilder._();

  // 2

  static Widget bannerAdOverlayBuild(BuildContext context, BrickBreakGame game) {
    return BannerAdOverlay(game: game);
  }

  static Widget friendsList(BuildContext context, BrickBreakGame game) {
    return FriendsList(game: game);
  }

  static Widget searchFriend(BuildContext context, BrickBreakGame game) {
    return SearchingFriend (game: game);
  }

  static Widget signWithGoogle(BuildContext context, BrickBreakGame game) {
    return SignWithGoogle (game: game);
  }

  static Widget loginPageWidget(BuildContext context, BrickBreakGame game) {
        return LoginPageWidget(game: game);
  }

  // static Widget logInScreen(BuildContext context, BrickBreakGame game) {
  //   return LoginPage(game: game);
  // }

  static Widget myAccount(BuildContext context, BrickBreakGame game) {
    return MyAccount(game: game);
  }

  static Widget leaderBoard(BuildContext context, BrickBreakGame game) {
    return LeaderBoard(game: game);
  }

  static Widget preGame(BuildContext context, BrickBreakGame game) {
    return PreGameOverlay(game: game);
  }

  static Widget gamePausedMenuOverlay(BuildContext context, BrickBreakGame game) {
    return GamePausedMenuOverlay(game: game);
  }

  static Widget nextLevelChallengeModeOverlay(BuildContext context, BrickBreakGame game) {
    return NextLevelChallengeModeOverlay(game: game);
  }

  static Widget mainMenu(BuildContext context, BrickBreakGame game) {
    return MainMenu(game: game);
  }

  static Widget blackScreen(BuildContext context, BrickBreakGame game) {
    return BlackScreen(gameRef: game);
  }

  static Widget levelsMap(BuildContext context, BrickBreakGame game) {
    return Levels(gameRef: game);
    //return LevelsMap(gameRef: game);
  }

  static Widget lostLife(BuildContext context, BrickBreakGame game) {
    return LostLife(game: game);
  }

  static Widget postGame(BuildContext context, BrickBreakGame game) {
    //assert(game.gameState == GameState.lost);
    // final message = game.gameState == GameState.won ? 'Winner!' : 'Game Over';
     return PostGameOverlay(game: game, );
  }

  static Widget winGame(BuildContext context, BrickBreakGame game) {
    //assert(game.gameState == GameState.won);
    print('IN WIN GAME OVERLAY');
    // final message = game.gameState == GameState.won ? 'Winner!' : 'Game Over';
    return WinGameOverlay(game: game, );
  }
  static Widget challengeGameOverOverlay(BuildContext context, BrickBreakGame game) {
    return ChallengeGameOverOverlay(game: game);
  }
  }

class PreGameOverlay extends StatefulWidget {
  final BrickBreakGame game;

  const PreGameOverlay({
    required this.game,
    super.key,

  });

  @override
  State<PreGameOverlay> createState() => _PreGameOverlayState();
}

class _PreGameOverlayState extends State<PreGameOverlay> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
print('PRE GAME OVERLAY${widget.game.gameState}');
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();

    // print('SIZE WIDTH: ${MediaQuery.of(context).size.width}');
    // print('GAME SIZE WIDTH: ${widget.game.size.x}');

    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SizedBox(width: widget.game.size.x * 30,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: Stack(alignment: Alignment.center,
                children: [Container(width: widget.game.camera.viewport.effectiveSize.x, height: 200, color: Colors.black.withOpacity(0.4),),
                  Image.asset('assets/images/bg/beginningNote2.png',height: (widget.game.camera.viewport.canvasSize?.y)!/8)
                  //Container(width: 280, height: 150, decoration: const BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/bg/beginningNote2.png'),fit: BoxFit.contain) ),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class LostLife extends StatefulWidget {
  final BrickBreakGame game;

  const LostLife({
    required this.game,
    super.key,
  });

  @override
  State<LostLife> createState() => _LostLifeState();
}

class _LostLifeState extends State<LostLife> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();

    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SizedBox(width: widget.game.size.x * 30,
        child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: Stack(alignment: Alignment.center,
                children: [
                  Container(width: widget.game.camera.viewport.effectiveSize.x, height: 300, color: Colors.black.withOpacity(0.4),),
                     Image.asset('assets/images/bg/lostBall2.png',height: (widget.game.camera.viewport.canvasSize?.y)!/4.5)
                  //Container(width: widget.game.size.x*15, height: 250, decoration: const BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/bg/lostBall2.png'),fit: BoxFit.cover) ),),
                  ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class PostGameOverlay extends StatefulWidget {
  //final String message;
  final BrickBreakGame game;

  const PostGameOverlay({
    super.key,
    //required this.message,
    required this.game,
  });

  @override
  State<PostGameOverlay> createState() => _PostGameOverlayState();
}

class _PostGameOverlayState extends State<PostGameOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isBoxVisible = false;

  late String reply;
  String reply1 = 'assets/images/buttons/replyButton.png';
  String reply2 = 'assets/images/buttons/replyButton_hover.png';

  late String imgMainMenu;
  String imgMainMenu1 = 'assets/images/buttons/mainMenuButton.png';
  String imgMainMenu2 = 'assets/images/buttons/mainMenuButton_hover.png';

  late String pickLevel;
  String pickLevel1 = 'assets/images/buttons/pickLevelButton.png';
  String pickLevel2 = 'assets/images/buttons/pickLevelButton_hover.png';


  @override
  void initState() {
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
    pickLevel = pickLevel1;
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
                Container(width: widget.game.camera.viewport.effectiveSize.x, height: (widget.game.camera.viewport.canvasSize?.y)!/2.3, color: Colors.black.withOpacity(0.4),),
                //const SizedBox(width: 250, height: 150,
                //),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/bg/lostHeading.png',height: (widget.game.camera.viewport.canvasSize?.y)!/10),
                      //Container(width: 300, height: 140, decoration: const BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/bg/lostHeading.png'),fit: BoxFit.contain) ),),
                                             _mainMenuButton(context, widget.game),
                                             _resetButton(context, widget.game),
                                             _pickLevelButton(context, widget.game),

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
    return GestureDetector(onTapDown: (tap) async {
      setState(() {
        imgMainMenu = imgMainMenu2;
      });
      if (game.audioSettings == AudioSettings.on) {
        await FlameAudio.play('button3.mp3');
      }
      widget.game.pauseEngine();
      widget.game.gameState = GameState.paused;
      if(widget.game.overlays.isActive('PostGame')){widget.game.overlays.remove('PostGame');}
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
      if(widget.game.overlays.isActive('PostGame')){widget.game.overlays.remove('PostGame');}
      game.resetGame();
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
      });
      if (game.audioSettings == AudioSettings.on) {
        await FlameAudio.play('button3.mp3');
      }
      widget.game.pauseEngine();
      widget.game.gameState = GameState.paused;
      if(widget.game.overlays.isActive('WinGame')){widget.game.overlays.remove('WinGame');}
      if(widget.game.overlays.isActive('LostLife')){widget.game.overlays.remove('LostLife');}
      print('--- PICK LEVEL BUTTON ---');
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


class WinGameOverlay extends StatefulWidget {
  //final String message;
  final BrickBreakGame game;

  const WinGameOverlay({
    super.key,
    //required this.message,
    required this.game,
  });

  @override
  State<WinGameOverlay> createState() => _WinGameOverlayState();
}

class _WinGameOverlayState extends State<WinGameOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isBoxVisible = false;

  late String reply;
  String reply1 = 'assets/images/buttons/replyButton.png';
  String reply2 = 'assets/images/buttons/replyButton_hover.png';

  late String imgMainMenu;
  String imgMainMenu1 = 'assets/images/buttons/mainMenuButton.png';
  String imgMainMenu2 = 'assets/images/buttons/mainMenuButton_hover.png';

  late String pickLevel;
  String pickLevel1 = 'assets/images/buttons/pickLevelButton.png';
  String pickLevel2 = 'assets/images/buttons/pickLevelButton_hover.png';

  late String nextLevel;
  String nextLevel1 = 'assets/images/buttons/nextLevelButton.png';
  String nextLevel2 = 'assets/images/buttons/nextLevelButton_hover.png';


  @override
  void initState() {
    print('WIN GAME OVERLAY: ${widget.game.gameState}');

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
    pickLevel = pickLevel1;
    nextLevel = nextLevel1;
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
                 //SizedBox(width: 250, height: 150,

                Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/bg/winHeading.png',height: (widget.game.camera.viewport.canvasSize?.y)!/11),
                    //Container(width: 300, height: 110, decoration: const BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/bg/winHeading.png'),fit: BoxFit.contain)),),
                    _mainMenuButton(context, widget.game),
                    _resetButton(context, widget.game),
                    _pickLevelButton(context, widget.game),
                    _nextLevelButton(context, widget.game),
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
      widget.game.pauseEngine();
      widget.game.gameState = GameState.paused;
      if(widget.game.overlays.isActive('WinGame')){widget.game.overlays.remove('WinGame');}
      widget.game.overlays.add('MainMenu');


        },
      onTapUp: (tap){setState(() {
        imgMainMenu = imgMainMenu1;
      });},

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
    return GestureDetector(

      onTapDown: (tap) async {setState(() {
      reply = reply2;
      if(widget.game.overlays.isActive('WinGame')){widget.game.overlays.remove('WinGame');}
    });
      if (game.audioSettings == AudioSettings.on) {
        await FlameAudio.play('button3.mp3');
      }
      game.currentGameLevelStars = 0;
      game.resetGame();
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


      child: Image.asset(reply, height: (widget.game.camera.viewport.canvasSize?.y)!/17),
    );
  }

  Widget _nextLevelButton(BuildContext context, BrickBreakGame game) {
    return GestureDetector(

      onTapDown: (tap) async {setState(() {
      nextLevel = nextLevel2;

            //game.overlays.add('LevelsMap');
    });
      if (game.audioSettings == AudioSettings.on) {
        await FlameAudio.play('button3.mp3');
      }
        game.currentGameLevelStars = 0;
      game.nextLevel(level: game.currentPlayedLevelNumber+1);
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

      child: Image.asset(nextLevel, height: (widget.game.camera.viewport.canvasSize?.y)!/17),
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

