import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:initial_project/services/hex_color.dart';

import '../forge2d_game_world.dart';
import '../ui/dbTools.dart';
import '../ui/google_welcome_widget.dart';
import '../ui/my_account_overlay.dart';

class LoginPageWidget extends StatefulWidget {
  final BrickBreakGame game;

  const LoginPageWidget({super.key, required this.game,});

  @override
  LoginPageWidgetState createState() => LoginPageWidgetState();
}

class LoginPageWidgetState extends State<LoginPageWidget> {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DbTools dbTools = DbTools();
  late FirebaseAuth _auth;

  bool isUserSignedIn = false;
  String? customProfileName;
  int? totalGamePoints;
  int? totalStars;
  int? finishedLevels;


  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    FirebaseApp defaultApp = await Firebase.initializeApp();
    _auth = FirebaseAuth.instanceFor(app: defaultApp);
    checkIfUserIsSignedIn();
    await widget.game.logInStatus();
    setState(() {
      customProfileName = widget.game.publicUserProfileName;
      totalGamePoints = widget.game.totalGamePoints;
      totalStars = widget.game.totalStars;
      finishedLevels = widget.game.localLastFinishedLevel;
    });
    }

  void checkIfUserIsSignedIn() async {

    var userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
      //widget.game.loggedIn = userSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {

    return  Column(
      children: [ (isUserSignedIn) ?
      Column(
        children: [
          Container(
                    padding: const EdgeInsets.all(50),
                    child: Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                             onPressed: () {
                               //onGoogleSignIn(context);
                               setState(() {isUserSignedIn = !isUserSignedIn;});
                               _googleSignIn.signOut();
                               //isUserSignedIn == false ?
                               widget.game.loggedInName = '';
                               },
                            style: ElevatedButton.styleFrom(backgroundColor: isUserSignedIn ? Colors.green : Colors.blueAccent,),
                                child: const Padding(padding: EdgeInsets.all(4),
                                child: Row( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.account_circle, color: Colors.white),
                                    SizedBox(width: 10),
                                    //FittedBox(fit: BoxFit.scaleDown, child: Text('You\'re logged in with Google',style: TextStyle(color: Colors.white)))
                                    //Text(isUserSignedIn ? 'You\'re logged in with Google' : 'Login with Google',style: const TextStyle(color: Colors.white))
                                  ],
                                )
                            )
                        )
                    )
            ),
          WelcomeUserWidget(game: widget.game ,user: _auth.currentUser, googleSignIn: _googleSignIn),

          Center( child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text('Public User Name',style: TextStyle(color: Colors.white,fontSize: 15)),
                  const SizedBox(height: 4,),
                  Text('$customProfileName',style: TextStyle(color: HexColor('#ffca72'),fontSize: 18)),
                  IconButton(onPressed: (){ displayTextInputDialog(context: context);}, icon: const FaIcon(FontAwesomeIcons.pencil,color: Colors.white,size: 15,))
                ],
              ),
               ],
          )),
          //Center( child: Text('Logged in name: $loggedInName',style: const TextStyle(color: Colors.white),)),
          //Center( child: Text('Logged in email: $profileEmail',style: const TextStyle(color: Colors.white),),),
          const SizedBox(height: 4,),
          Center( child: Text('Best Score: $totalGamePoints',style: const TextStyle(color: Colors.white),),),
          const SizedBox(height: 3),
          Center( child: Text('Collected stars: $totalStars',style: const TextStyle(color: Colors.white),),),
          const SizedBox(height: 3),
          Center( child: Text('Finished levels: $finishedLevels',style: const TextStyle(color: Colors.white),),),
          const SizedBox(height: 15),
          Center( child: Text('Synchronize your Level mode status',style: TextStyle(fontSize: 18,color: HexColor('#72edff')),),),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
              Center(

                  child: ElevatedButton(
                    onPressed: () async {
                      await widget.game.logInStatus();
                      await widget.game.getUserData();
                      var syncStatus = widget.game.syncStatus;
                      print('syncStatus: ${syncStatus}');
                      if (syncStatus == SyncStatus.ok) {
                        setState(() {
                          customProfileName = widget.game.publicUserProfileName;
                          totalGamePoints = widget.game.totalGamePoints;
                          totalStars = widget.game.totalStars;
                          finishedLevels = widget.game.localLastFinishedLevel;
                        });
                      }
                      if (widget.game.syncStatus == SyncStatus.error){
                        print('*****ERROR****');
                        _showSyncErrorAlertDialog();
                      }
                      },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,side: BorderSide(width: 1, color: HexColor('#ffca72').withOpacity(0.7))),
                    child: const Text(
                      'Download',
                      style: TextStyle(fontSize: 16),
                    ),
                  )),

              Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await widget.game.logInStatus();
                      await widget.game.uploadLevelData();
                      },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,side: BorderSide(width: 1, color: HexColor('#ffca72').withOpacity(0.7))),
                    child: const Text(
                      'Upload',
                      style: TextStyle(fontSize: 16),
                    ),
                  )),

            ],),
          )
        ],
      ) :
      Column(
        children: [
          Container(
              padding: const EdgeInsets.all(50),
              child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () async {
                        //onGoogleSignIn(context);
                        setState(() {isUserSignedIn = !isUserSignedIn;});
                        //_handleSignIn();
                        await _handleSignIn();
                        await widget.game.logInStatus();
                        setState(() {customProfileName = widget.game.publicUserProfileName; totalGamePoints = widget.game.publicTopTotalPoints;});
                        //isUserSignedIn == true ?
                        widget.game.loggedInName = _auth.currentUser?.displayName;
                        },
                      style: ElevatedButton.styleFrom(backgroundColor: isUserSignedIn ? Colors.green : Colors.blueAccent,),
                      child: const Padding(padding: EdgeInsets.all(4),
                          child: Row( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.account_circle, color: Colors.white),
                              SizedBox(width: 10),
                              //FittedBox(fit: BoxFit.scaleDown, child: Text('Login with Google',style: TextStyle(color: Colors.white)))
                              //Text(isUserSignedIn ? 'You\'re logged in with Google' : 'Login with Google',style: const TextStyle(color: Colors.white))
                            ],
                          )
                      )
                  )
           )
          ),
          const Center(child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  //Text('Public User Name',style: TextStyle(color: Colors.white,fontSize: 15)),
                  SizedBox(height: 4,),
                  Text('Not Signed in',style: TextStyle(color: Colors.white,fontSize: 18)),
                  //Text('$customProfileName',style: const TextStyle(color: Colors.white,fontSize: 18)),
                  //IconButton(onPressed: (){ displayTextInputDialog(context: context);}, icon: const FaIcon(FontAwesomeIcons.pencil,color: Colors.white,size: 15,)),
                  ],
              ),
            ],
          )),

          const Center( child: Padding(
            padding: EdgeInsets.only(left: 30,right: 30),
            child: Text('Please Log In to create or edit you public user name and share your best score on Leader Board',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
          ),),
          const SizedBox(height: 8,),
          Center( child: Text('Best Score: ${widget.game.totalGamePoints}',style: const TextStyle(color: Colors.white),),),
          ],
      ),
      ],
    );
  }

  Future<User?> _handleSignIn() async {
    User? user;
    bool userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });

    if (isUserSignedIn) {
      user = _auth.currentUser;
    }
    else {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      user = (await _auth.signInWithCredential(credential)).user;
      userSignedIn = await _googleSignIn.isSignedIn();
      setState(() {
        isUserSignedIn = userSignedIn;
      });
    }
    return user;
  }

  Future<void> displayTextInputDialog({required BuildContext context}) async {
    final TextEditingController textFieldController = TextEditingController();

    String? codeDialog;
    String? valueText;
    //String? customProfileName = ;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: HexColor('#fbf2d1').withOpacity(0.7),
            title: const Text('New User name'),
            content: TextField(
              onChanged: (value) => customProfileName = value,
              onSubmitted: (value) async {
                if (await dbTools.checkUserName(customProfileName!) == false){
             setState(() {customProfileName = value; valueText = value;});
             widget.game.localUserProfileName = value;
             await widget.game.prefs.setString('customUserProfileName', customProfileName ?? '');
             if(isUserSignedIn == true) {
               DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('leaderboard/${widget.game.keyID}');
               await dbRef.update({
                 'userName' : value,
                });
               if (!mounted) return;
               Navigator.pop(context);
              } else {print('PLEASE SIGN IN');}
          }else{print('THE USER NAME ALREADY TAKEN');}},
              controller: textFieldController,
              decoration:
              InputDecoration(hintText: '$customProfileName'),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () async {
                if (await dbTools.checkUserName(customProfileName!) == false){
                  setState(() {widget.game.localUserProfileName = customProfileName; });
                  await widget.game.prefs.setString('customUserProfileName', customProfileName ?? '');
     if(isUserSignedIn == true) {
      DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('leaderboard/${widget.game.keyID}');
      await dbRef.update({
        'keyId': widget.game.keyID,
        'userName': customProfileName,
      });
      if (!mounted) return;
      Navigator.pop(context);
    }}})
            ],
          );
        });
  }

  Future<void> _showSyncErrorAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog( // <-- SEE HERE
          title: const Text('Something went Wrong. '),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('The requested data does not exists'),
              ],
            ),
          ),
          actions: <Widget>[
           TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}



