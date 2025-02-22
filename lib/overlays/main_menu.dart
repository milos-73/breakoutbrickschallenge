import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../components/google_play_game_services.dart';
import '../forge2d_game_world.dart';
import '../services/ad_helper.dart';
import '../services/hex_color.dart';


class MainMenu extends StatefulWidget {
  //final String message;
  final BrickBreakGame game;

  const MainMenu({super.key, required this.game,});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with SingleTickerProviderStateMixin {

  BannerAd? _bannerAd;
  Random random = new Random();
  final googlePlayGameServices = GooglePlayGameServices();

  String? playerName = '';
  bool signInStatus = false;

  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isBoxVisible = false;

  late String levels;
  String levels1 = 'assets/images/buttons/levelsButton.png';
  String levels2 = 'assets/images/buttons/levelsButton_hover.png';

  late String challenge;
  String challenge1 = 'assets/images/buttons/challengeButton.png';
  String challenge2 = 'assets/images/buttons/challengeButton_hover.png';

  late String board;
  String board1 = 'assets/images/buttons/boardButtonPlay.png';
  String board2 = 'assets/images/buttons/boardButton_hover_play.png';

  late String logIn;
  String logIn1 = 'assets/images/buttons/myAccountButton.png';
  String logIn2 = 'assets/images/buttons/myAccountButton_hover.png';

  late String about;
  String about1 = 'assets/images/buttons/infoButton.png';
  String about2 = 'assets/images/buttons/infoButton_hover.png';

  late String achievements;
  String achievements1 = 'assets/images/buttons/achievementsButtonPlay.png';
  String achievements2 = 'assets/images/buttons/achievementsButton_hover_play.png';

  @override
  void initState() {

    super.initState();

    getSignInStatus();
    fetchPlayerName();

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
    challenge = challenge1;
    levels = levels1;
    board = board1;
    logIn = logIn1;
    achievements = achievements1;
    about = about1;

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId2,
      request: AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();

  }

  @override
  void dispose() {
    _animationController.dispose();
    _bannerAd?.dispose();
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

  Future<String> getPlayerName() async {
    String? name = await Player.getPlayerName() ?? 'Not signed in';
   return name;
  }

  Future<void> getSignInStatus() async {
    signInStatus = await GameAuth.isSignedIn;
  }

  Future<void> fetchPlayerName() async {
    if (await InternetConnection().hasInternetAccess == true) {
      String name = await getPlayerName();
      setState(() {
        signInStatus = true;
        playerName = name;
       });
    }else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
        body: Container(constraints: const BoxConstraints.expand(),decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg/levels2.jpg"),fit: BoxFit.cover)),
          child: Container(width: 1080,height: 2340,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg/mainScreen.jpg"),fit: BoxFit.contain,)),

     child: Center(
       child: AspectRatio(aspectRatio: 9/19,
         child: Column(mainAxisAlignment: MainAxisAlignment.end,
           children: [
             Padding(
               padding: const EdgeInsets.only(bottom: 40),
               child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center,
                 children: [

                   Padding(
                     padding: const EdgeInsets.only(top: 20,bottom: 20),
                     child: Center(
                       child: Container(width: 1080,height: 50,
                           child: Padding(
                             padding: const EdgeInsets.only(left: 15,right: 15),
                             child: _bannerAd != null ? Align(
                                     alignment: Alignment.center,
                             child: SizedBox(
                               width: (widget.game.camera.viewport.canvasSize?.x)!*0.95,
                               child: AdWidget(ad: _bannerAd!),
                             ),
                             ):
                             SizedBox(),
                           )

                       ),
                     ),
                   ),

                   SlideTransition( position: _animation, child: Stack(alignment: Alignment.bottomCenter,
                     children: [
                       Column( mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
                         children: [

                           _challengeButton(context, widget.game),
                           _levelsButton(context, widget.game),
                           _boardButton(context, widget.game),
                           _achievements(context, widget.game),
                           Padding(
                             padding: const EdgeInsets.only(top: 10),
                             child: _about(context, widget.game),
                           ),
                           Padding(padding: const EdgeInsets.only(bottom: 40),)
                         ], )], ), ),
                   Padding(
                     padding: const EdgeInsets.only(top: 20),
                     child: Center(
                       child: Container(width: 1080,height: 40,decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
                           child: Padding(
                             padding: const EdgeInsets.only(left: 15,right: 15),
                             child: FittedBox(fit: BoxFit.scaleDown,
                               child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [
                                 signInStatus == false ? const Text('Please sign in to save your best score to leader board.',style: TextStyle(color: Colors.white),) :
                                 Text('You are signed in as ${playerName}',style: const TextStyle(color: Colors.white),),
                               ],),
                             ),
                           )

                       ),
                     ),
                   )
                 ],  ),
             ),
           ],),
       ),
    ))));
  }

  Widget _challengeButton(BuildContext context, BrickBreakGame game) {
    return GestureDetector(

      onTapDown: (tap) async {
               setState(() {
        challenge = challenge2;
        });
           if (game.audioSettings == AudioSettings.on) {
           await FlameAudio.play('button3.mp3');
           }

        game.gameMode = GameMode.challenge;
               int level = await widget.game.randomChallengeWallNumber();
               await widget.game.prefs.setInt('challengeLevel', level);
               widget.game.challengeCurrentLevel = level;
               await widget.game.pickLevel(level);

               //print('LEVEL:${level}');
      },

      onTapUp: (tap){setState(() {
        challenge = challenge1;
      });},

      onLongPress: () {
        setState(() {
          challenge = challenge2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          challenge = challenge1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          challenge = challenge2;
        });
      },

      child: Image.asset(challenge, height: (widget.game.camera.viewport.canvasSize?.y)!/14.5,),
    );
  }

  Widget _levelsButton(BuildContext context, BrickBreakGame game) {
    return GestureDetector(

      onTapDown: (tap) async {

        setState(() {
        levels = levels2;
       });

        if (game.audioSettings == AudioSettings.on) {
          await FlameAudio.play('button3.mp3');
        }
      game.gameMode = GameMode.levels;
      game.overlays.add('LevelsMap');},

      onTapUp: (tap){setState(() {
        levels = levels1;
      });},

      onLongPress: () {
        setState(() {
          levels = levels2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          levels = levels1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          levels = levels2;
        });
      },

      child: Image.asset(levels, height: (widget.game.camera.viewport.canvasSize?.y)!/14.5,),
    );
  }

  Widget _about(BuildContext context, BrickBreakGame game) {
    return GestureDetector(

        onTapDown: (tap) async {

      setState(() {
        levels = levels2;
      });

      if (game.audioSettings == AudioSettings.on) {
        await FlameAudio.play('button3.mp3');
      }
      game.gameMode = GameMode.levels;
      game.overlays.add('AboutInfo');},

      onTapUp: (tap){setState(() {
        about = about1;
      });},

      onLongPress: () {
        setState(() {
          about = about2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          about = about1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          about = about2;
        });
      },

      child: Image.asset(about, height: (widget.game.camera.viewport.canvasSize?.y)!/14.5,),
    );
  }

  Widget _boardButton(BuildContext context, BrickBreakGame game) {
    return GestureDetector(

      onTapDown: (tap) async {
        setState(() {
          board = board2;
        });
        if (game.audioSettings == AudioSettings.on) {
          await FlameAudio.play('button3.mp3');
        }
        if (await InternetConnection().hasInternetAccess == true) {
          if (signInStatus == false){
            _pleaseLogInMessageLeaderBoard();
            }
          else {
            await Leaderboards.showLeaderboards();
          }
        }else{
          _offlineMessageLeaderBoard();
        }
      },

      onTapUp: (tap){setState(() {
        board = board1;
      });},

      onLongPress: () {
        setState(() {
          board = board2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          board = board1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          board = board2;
        });
      },

      child: Image.asset(board, height: (widget.game.camera.viewport.canvasSize?.y)!/14.5,),
    );
  }

  Widget _achievements(BuildContext context, BrickBreakGame game) {
    return GestureDetector(

      onTapDown: (tap) async {
        setState(() {
          achievements = achievements2;
        });
        if (game.audioSettings == AudioSettings.on) {
          await FlameAudio.play('button3.mp3');
        }
        if (await InternetConnection().hasInternetAccess == true) {
          if (signInStatus == false){
            _pleaseLogInMessageAchievements();
          }
          else {
            await Achievements.showAchievements();
          }
        }else{
          _offlineMessageAchievements();
        }
      },

      onTapUp: (tap){setState(() {
        achievements = achievements1;
      });},

      onLongPress: () {
        setState(() {
          achievements = achievements2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          achievements = achievements1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          achievements = achievements2;
        });
      },

      child: Image.asset(achievements, height: (widget.game.camera.viewport.canvasSize?.y)!/14.5,),
    );
  }

   Future<void> _pleaseLogInMessageLeaderBoard() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: HexColor('#ffdfab').withOpacity(0.7),
          title: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/buttons/google play_button.png', height: (widget.game.camera.viewport.canvasSize?.y)!/14.5,),
              const Text('Leader Board', style: TextStyle(fontWeight: FontWeight.w700),),
            ],
          ),
          content: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Please log in to Google play game services to use this feature',textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
            ],
          ),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: HexColor('#8bf5aa')),
                  child: Text('LogIn',style: TextStyle(color: HexColor('#1c2b31'),fontWeight: FontWeight.w800),),
                  onPressed: () async {
                    setState(() {
                      board = board1;
                    });
                    Navigator.of(context).pop();
                    googlePlayGameServices.signIn();
                    await fetchPlayerName();
                    await Leaderboards.showLeaderboards();

                  },
                ),
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: HexColor('#f60c0d')),
                  child: Text('Cancel',style: TextStyle(color: HexColor('#1c2b31'),fontWeight: FontWeight.w800),),
                  onPressed: () {
                    setState(() {
                      board = board1;
                    });
                  Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _offlineMessageLeaderBoard() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: HexColor('#ffdfab').withOpacity(0.7),
          title: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/buttons/google play_button.png', height: (widget.game.camera.viewport.canvasSize?.y)!/14.5,),
              const Text('Leader Board', style: TextStyle(fontWeight: FontWeight.w700),),
            ],
          ),
          content: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Your phone appears to be offline. Please check your internet connection and try again to log in to Google play game services to use this feature',textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
            ],
          ),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: HexColor('#8bf5aa')),
                  child: Text('OK',style: TextStyle(color: HexColor('#1c2b31'),fontWeight: FontWeight.w800),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _pleaseLogInMessageAchievements() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: HexColor('#ffdfab').withOpacity(0.7),
          title: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/buttons/google play_button.png', height: (widget.game.camera.viewport.canvasSize?.y)!/14.5,),
              const Text('Leader Board', style: TextStyle(fontWeight: FontWeight.w700),),
            ],
          ),
          content: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Please log in to Google play game services to use this feature',textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
            ],
          ),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: HexColor('#8bf5aa')),
                  child: Text('LogIn',style: TextStyle(color: HexColor('#1c2b31'),fontWeight: FontWeight.w800),),
                  onPressed: () async {
                    setState(() {
                      board = board1;
                    });
                    Navigator.of(context).pop();
                    googlePlayGameServices.signIn();
                    await fetchPlayerName();
                    await Leaderboards.showLeaderboards();
                  },
                ),
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: HexColor('#f60c0d')),
                  child: Text('Cancel',style: TextStyle(color: HexColor('#1c2b31'),fontWeight: FontWeight.w800),),
                  onPressed: () {
                    setState(() {
                      board = board1;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _offlineMessageAchievements() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: HexColor('#ffdfab').withOpacity(0.7),
          title: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/buttons/google play_button.png', height: (widget.game.camera.viewport.canvasSize?.y)!/14.5,),
              const Text('Leader Board', style: TextStyle(fontWeight: FontWeight.w700),),
            ],
          ),
          content: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Your phone appears to be offline. Please check your internet connection and try again to log in to Google play game services to use this feature',textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
            ],
          ),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: HexColor('#8bf5aa')),
                  child: Text('OK',style: TextStyle(color: HexColor('#1c2b31'),fontWeight: FontWeight.w800),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}






