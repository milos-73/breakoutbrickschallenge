import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../forge2d_game_world.dart';
import '../services/ad_helper.dart';
import '../services/hex_color.dart';
import '../ui/dbTools.dart';

class MainMenu extends StatefulWidget {
  //final String message;
  final BrickBreakGame game;

  const MainMenu({super.key, required this.game,});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with SingleTickerProviderStateMixin {

  BannerAd? _bannerAd;

DbTools dbTools = DbTools();

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
  String board1 = 'assets/images/buttons/boardButton.png';
  String board2 = 'assets/images/buttons/boardButton_hover.png';

  late String logIn;
  String logIn1 = 'assets/images/buttons/myAccountButton.png';
  String logIn2 = 'assets/images/buttons/myAccountButton_hover.png';

  late String settings;
  String settings1 = 'assets/images/buttons/settingsButton.png';
  String settings2 = 'assets/images/buttons/settingsButton_hover.png';

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
    challenge = challenge1;
    levels = levels1;
    board = board1;
    logIn = logIn1;
    settings = settings1;

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId2,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
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
             //IconButton(onPressed: (){}, icon: const FaIcon(FontAwesomeIcons.gear,size: 30,color: Colors.black,)),
             //const SizedBox(height: 30,),
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
                             child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [
                               _bannerAd != null ? Align(
                             alignment: Alignment.center,
                               child: Container(
                                 //width: widget.game!.size.x * 40,
                                 width: _bannerAd!.size.width.toDouble(),
                                 height: _bannerAd!.size.height.toDouble(),
                                 child: AdWidget(ad: _bannerAd!),
                               ),
                             ):
                               SizedBox()



                             ],),
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
                           _myAccount(context, widget.game),
                           // Padding(
                           //   padding: const EdgeInsets.only(top: 10),
                           //   child: _settings(context, widget.game),
                           // ),
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
                                 widget.game.loggedInName == '' ? const Text('Please sign in to save your best score to leader board.',style: TextStyle(color: Colors.white),) :
                                 Text('You are signed in as ${widget.game.publicUserProfileName}',style: const TextStyle(color: Colors.white),),
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
        print('1 ---- GAME MODE FROM CHALLENGE BUTTON: ${game.gameMode}');
        await widget.game.pickLevel(1);},

      onTapUp: (tap){setState(() {
        challenge = challenge1;
      });},

      onLongPress: () {
        setState(() {
          print('LONG PRESS');
          challenge = challenge2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          print('onLongPressStart');
          challenge = challenge1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          print('onLongPressDown');
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
          print('LONG PRESS');
          levels = levels2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          print('onLongPressStart');
          levels = levels1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          print('onLongPressDown');
          levels = levels2;
        });
      },

      child: Image.asset(levels, height: (widget.game.camera.viewport.canvasSize?.y)!/14.5,),
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
        await game.logInStatus();
        if (game.loggedIn != null){

          game.overlays.add('LeaderBoard');
          game.overlays.remove('MainMenu');
        }else{

          await _pleaseLogInMessage();

        }
        //game.overlays.add('FriendsList');

      },

      onTapUp: (tap) async {

        if (game.loggedIn != null) {
          setState(() {
            board = board1;
          });
        }


        // DatabaseReference dbRef = FirebaseDatabase.instance.ref("leaderboard/9ROOfcPvEGRwVP87b9mBi2KhbMe2");
        //
        //
        // await dbRef.update({
        //   'name': 'milossalus',
        //   'points': '300',
        //   'userName' : 'Milos.2023'
        // });


        // DatabaseReference dbRef = FirebaseDatabase.instance.ref("leaderboard");
        //
        //
        // await dbRef.update({
        //   'keyId': '7ROOfcPvEGRwVP87b9mBi5KhbMe4',
        //   'name': 'Miloš Sálus',
        //   'points': '300',
        //   'userName' : 'Milos.1973'
        // });


       // if(await dbTools.checkUserName('Milos.74') == true){
       // print('USER ALREADY EXISTS');
       // } else {print('USER OK');}

       // DatabaseReference dbRef = FirebaseDatabase.instance.ref();
       // var existingUser = dbRef..child('leaderboard').orderByChild('userName').equalTo('Milos.74').limitToFirst(1).once().then((value) => print('EXISTING USER: ${value.snapshot.exists}'));

     //DatabaseReference child = dbRef.child("userName");

        //print('EXISTING USER: ${existingUser.key}');
      },

      onLongPress: () {

        setState(() {
          print('LONG PRESS');
          board = board2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          print('onLongPressStart');
          board = board1;
        });
      },
      onLongPressDown: (tap) {
        if (game.loggedIn != null) {
          setState(() {
            print('onLongPressDown');
            board = board2;
          });
        }
      },


      child: Image.asset(board, height: (widget.game.camera.viewport.canvasSize?.y)!/14.5,),
    );
  }

  Widget _myAccount(BuildContext context, BrickBreakGame game) {
    return GestureDetector(

      onTapDown: (tap) async {
         setState(() {
        logIn = logIn2;
      });
         if (game.audioSettings == AudioSettings.on) {
           await FlameAudio.play('button3.mp3');
         }
      game.overlays.add('MyAccount');
      },

      onTapUp: (tap){setState(() {
        logIn = logIn1;
      });},

      onLongPress: () {
        setState(() {
          print('LONG PRESS');
          logIn = logIn2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          print('onLongPressStart');
          logIn = logIn1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          print('onLongPressDown');
          logIn = logIn2;
        });
      },

      child: Image.asset(logIn, height: (widget.game.camera.viewport.canvasSize?.y)!/14.5,),
    );
  }


  Widget _settings(BuildContext context, BrickBreakGame game) {
    return GestureDetector(

      onTapDown: (tap) async {
        setState(() {
          settings = settings2;
        });

      },

      onTapUp: (tap){setState(() {
        settings = settings1;
      });},

      onLongPress: () {
        setState(() {
          print('LONG PRESS');
          settings = settings2;
        });
      },
      onLongPressEnd: (tap) {
        setState(() {
          print('onLongPressStart');
          settings = settings1;
        });
      },
      onLongPressDown: (tap) {
        setState(() {
          print('onLongPressDown');
          settings = settings2;
        });
      },

      child: Image.asset(settings, height: (widget.game.camera.viewport.canvasSize?.y)!/14.5,),
    );
  }

   Future<void> _pleaseLogInMessage() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: HexColor('#ffdfab').withOpacity(0.7),
          title: const Text('Leader Board', style: TextStyle(fontWeight: FontWeight.w700),),
          content: const Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Please log in to use this feature',textAlign: TextAlign.center, style: TextStyle(fontSize: 17),),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: HexColor('#8bf5aa')),
              child: Text('OK',style: TextStyle(color: HexColor('#1c2b31'),fontWeight: FontWeight.w800),),
              onPressed: () {
                setState(() {
                  board = board1;
                });
              Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}






