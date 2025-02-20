import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:brickbreaker/forge2d_game_world.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import '../services/saved_values.dart';
import '../ui/levels_screen_items.dart';

class AboutInfo extends StatefulWidget {

  final BrickBreakGame gameRef;

  const AboutInfo({Key? key, required this.gameRef}) : super(key: key);

  @override
  State<AboutInfo> createState() => _AboutInfoState();
}

class _AboutInfoState extends State<AboutInfo> {

  SavedValues savedValues = SavedValues();

  int? totalGamePoint = 0;
  int? challengeLevels = 0;
  int? lastFinishedLevel = 0;
  int? totalStars = 0;
  int? fiveStarsLevels = 0;

  Future<void>? _launched;

  final Uri _url3 = Uri.parse('mailto:support@salus-apps.eu');

    Future<void> asignValues() async {
    await savedValues.getTotalGamePoints().then((value) => setState(() {totalGamePoint = value;}));
    await savedValues.getFinishedChallengeLevels().then((value) => setState(() {challengeLevels = value;}));
    await savedValues.getLastFinishedLevel().then((value) => setState(() {lastFinishedLevel = value;}));
    await savedValues.getTotalStars().then((value) => setState(() {totalStars = value;}));
    await savedValues.getFiveStarsLevels().then((value) => setState(() {fiveStarsLevels = value;}));

  }

  Future<void> resetGame() async {
      //await widget.gameRef.prefs.clear();

      for (String key in widget.gameRef.prefs.getKeys()) {
        if (key.startsWith('numberOfStars')) {await widget.gameRef.prefs.remove(key);}
      }

      // await widget.gameRef.prefs.setInt('lastFinishedLevel', 0);
      // await widget.gameRef.prefs.setInt('currentPlayedLevelNumber', 0);
      // await widget.gameRef.prefs.setInt('fiveStarsLevels', 0);
      // await widget.gameRef.prefs.setInt('fiveStarsLevels', 0);
      // await widget.gameRef.prefs.setInt('fiveStarsLevels', 0);
      // await widget.gameRef.prefs.setInt('fiveStarsLevels', 0);
      setState(() {
        lastFinishedLevel = 0;
        challengeLevels = 0;
        fiveStarsLevels = 0;
        totalStars = 0;
        totalGamePoint = 0;
      });


      showToastWidget(Text('Game RESET done!',style: TextStyle(fontSize: 30.0, color: Colors.white70),),duration: Duration(seconds: 4),position: ToastPosition.bottom,);

  print('GAME RESET');
  }

  Future<void> resetLevels() async {
    //await widget.gameRef.prefs.clear();

    for (String key in widget.gameRef.prefs.getKeys()) {
      if (key.startsWith('numberOfStars')) {await widget.gameRef.prefs.remove(key);}
      if (key.startsWith('lastFinishedLevel')) {await widget.gameRef.prefs.remove(key);}
      if (key.startsWith('totalStars')) {await widget.gameRef.prefs.remove(key);}
      if (key.startsWith('currentPlayedLevelNumber')) {await widget.gameRef.prefs.remove(key);}
      if (key.startsWith('fiveStarsLevels')) {await widget.gameRef.prefs.remove(key);}
      if (key.startsWith('levelInProgress')) {await widget.gameRef.prefs.remove(key);}
    }
    setState(() {
      lastFinishedLevel = 0;
      fiveStarsLevels = 0;
      totalStars = 0;
    });

    showToastWidget(Text('Levels RESET done!',style: TextStyle(fontSize: 30.0, color: Colors.white70),),duration: Duration(seconds: 4),position: ToastPosition.bottom,);
  }


  Future<void> resetChallenge() async {

    for (String key in widget.gameRef.prefs.getKeys()) {
      if (key.startsWith('challengeLevel')) {await widget.gameRef.prefs.remove(key);}
      if (key.startsWith('totalPointsInCurrentGame')) {await widget.gameRef.prefs.remove(key);}
      if (key.startsWith('challengeLevelPoints')) {await widget.gameRef.prefs.remove(key);}
      if (key.startsWith('currentPlayedLevelNumber')) {await widget.gameRef.prefs.remove(key);}
      if (key.startsWith('totalGamePoints')) {await widget.gameRef.prefs.remove(key);}
      if (key.startsWith('challengeLevel')) {await widget.gameRef.prefs.remove(key);}
    }

    setState(() {

      challengeLevels = 0;
      totalGamePoint = 0;
    });

    showToastWidget(Text('Challenge RESET done!',style: TextStyle(fontSize: 30.0, color: Colors.white70),),duration: Duration(seconds: 4),position: ToastPosition.bottom,);
  }


  num countStarPercentage() {

      double percentage = (totalStars! / (lastFinishedLevel!*5))*100;
      if(percentage > 0){
        return percentage;
      }else{
        return 0;
      }
         }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _showLevelsResetAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to reset your LEVELS game?',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18),),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                //Text('Are you sure you want to reset the Game?'),
                Text('The changes are irreversible, and your game will start from beginning'),
              ],
            ),
          ),
          actions: <Widget>[TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel',style: TextStyle(color: Colors.red),),
          ),
            TextButton(
              child: const Text('Approve',style: TextStyle(color: Colors.green),),
              onPressed: () {
                Navigator.of(context).pop();
                resetLevels();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showChallengeResetAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to reset CHALLENGE game?',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18),),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                //Text('Are you sure you want to reset the Game?'),
                Text('The changes are irreversible, and your game will start from beginning'),
              ],
            ),
          ),
          actions: <Widget>[TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel',style: TextStyle(color: Colors.red),),
          ),
            TextButton(
              child: const Text('Approve',style: TextStyle(color: Colors.green),),
              onPressed: () {
                Navigator.of(context).pop();
                resetChallenge();
              },
            ),
          ],
        );
      },
    );
  }


 @override
  void initState() {
   super.initState();
   asignValues();
  }

  @override
  Widget build(BuildContext context) {

    print('fiveStarsLevels: ${fiveStarsLevels}');

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(onPressed: () async {

          if (widget.gameRef.audioSettings == AudioSettings.on) {
            await FlameAudio.play('button3.mp3');
          }

          widget.gameRef.overlays.remove('AboutInfo');
          if (!widget.gameRef.overlays.isActive('MainMenu')){widget.gameRef.overlays.add('MainMenu');}
        }, backgroundColor: Colors.orange.shade200, elevation: 12,child: const FaIcon(FontAwesomeIcons.house,color: Colors.black),),
      ),
      body: CustomScrollView(slivers: [SliverFillRemaining(
          hasScrollBody: false,
        child: Container(constraints: const BoxConstraints.expand(),decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg/levels2.jpg"),fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.only(top:20),
            child: Container(width: widget.gameRef.size.x *30,height: widget.gameRef.size.y * 10,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg/levels2.jpg"),fit: BoxFit.contain)),
                child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Expanded(child: Container(child: AspectRatio(aspectRatio: 9/19,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: LayoutBuilder(builder:(context, constraints ) {
                        return
                          Center(child: Column(
                            children: [Center(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Game Statistics'.toUpperCase(), style: TextStyle(fontSize: 18,color: Colors.green),),
                            ),),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text('Challenge Points:',style: TextStyle(fontSize: 15,color: Colors.amber),),
                                        Text('Challenge Levels:',style: TextStyle(fontSize: 15,color: Colors.amber),),
                                        Text('Levels finished:',style: TextStyle(fontSize: 15,color: Colors.amber),),
                                        Text('Collected stars %:',style: TextStyle(fontSize: 15,color: Colors.amber),),
                                        Text('Collected stars:',style: TextStyle(fontSize: 15,color: Colors.amber),),
                                        Text('5* Levels:',style: TextStyle(fontSize: 15,color: Colors.amber),),
                                        //Text('${widget.gameRef.totalGamePoints}',style: TextStyle(fontSize: 20,color: Colors.amber),),

                                      ],),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.end ,children: [
                                        Text('$totalGamePoint',style: TextStyle(fontSize: 15,color: Colors.amber),),
                                        Text('$challengeLevels',style: TextStyle(fontSize: 15,color: Colors.amber),),
                                        Text('$lastFinishedLevel',style: TextStyle(fontSize: 15,color: Colors.amber),),
                                        Text('${countStarPercentage().toStringAsFixed(2)}%',style: TextStyle(fontSize: 15,color: Colors.amber),),
                                        Text('${totalStars} / ${lastFinishedLevel!*5}',style: TextStyle(fontSize: 15,color: Colors.amber),),
                                        Text('$fiveStarsLevels',style: TextStyle(fontSize: 15,color: Colors.amber),),
                                        //Text('${widget.gameRef.totalGamePoints}',style: TextStyle(fontSize: 20,color: Colors.amber),),

                                      ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              //Divider(thickness: 1,indent: 10,color: Colors.green,),
                              SizedBox(height: 10),
                              Text('RESET GAME'.toUpperCase(), style: TextStyle(fontSize: 18,color: Colors.red),),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 130,child: ElevatedButton(onPressed: _showLevelsResetAlertDialog, child: Text('LEVELS'),)),
                                    SizedBox(width: 130,child: ElevatedButton(onPressed: _showChallengeResetAlertDialog, child: Text('CHALLENGE')))
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Divider(thickness: 1,indent: 10,color: Colors.green,), Divider(thickness: 1,indent: 10,color: Colors.amber,),

                              SizedBox(height: 20),
                              Column(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('About The Game'.toUpperCase(), style: TextStyle(fontSize: 18,color: Colors.green),),
                                  ),),

                                  //Icon(FontAwesomeIcons.locationDot, size: 50, color: HexColor('#3B592D'),),
                                  SizedBox(height: 20,),
                                  Text('Brick Breaker'.toUpperCase(), style: TextStyle(fontSize: 27,fontWeight: FontWeight.w600,color: Colors.amber),textAlign: TextAlign.center),
                                  Text('Fun Challenge'.toUpperCase(), style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400, color: Colors.limeAccent),),
                                  //Text('my current location', style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),),
                                  SizedBox(height: 5,),
                                  Text('version 1.1.5', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300, color: Colors.white),),
                                  SizedBox(height: 20,),
                                  //TextButton(onPressed: () => setState(() {_launched = _launchInBrowser(_url);}), child: const Text('mylocationnow.app'),style: TextButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero,tapTargetSize: MaterialTapTargetSize.shrinkWrap ),),
                                  Text('support@mylocationnow.app', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                                  //TextButton(onPressed: () => setState(() {_launched = _launchInBrowser(_url2);}), child: const Text('Privacy Policy'),style: TextButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero,tapTargetSize: MaterialTapTargetSize.shrinkWrap ),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 2),
                                    child: Text('Development', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500, color: Colors.amberAccent),),
                                  ),
                                  Text('Miloš Sálus', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500, color: Colors.amberAccent),),
                                  Text('Pivo SALUS s.r.o.', style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400, color: Colors.white),),
                                  SizedBox(height: 15,),
                                  Center(
                                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [FaIcon(FontAwesomeIcons.envelope, size: 20, color: Colors.white54,),
                                        SizedBox(width: 8,),
                                        TextButton(onPressed: () => setState(() {_launched = _launchInBrowser(_url3);}), child: const Text('Report an issue', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),style: TextButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero,tapTargetSize: MaterialTapTargetSize.shrinkWrap ),),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ));

                      }),
                    ),
                  ))),
                ],)),
          ),
        ),

      )],

      ),

    );
  }
}
