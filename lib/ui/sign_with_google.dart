import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:initial_project/ui/welcome_user.dart';

import '../forge2d_game_world.dart';
import '../overlays/google_signin.dart';
import 'auth_screen.dart';

class SignWithGoogle extends StatefulWidget {
  //final String message;
  final BrickBreakGame game;

  const SignWithGoogle({super.key, required this.game,});

  @override
  State<SignWithGoogle> createState() => _SignWithGoogleState();
}

class _SignWithGoogleState extends State<SignWithGoogle> with SingleTickerProviderStateMixin {

  String? profileName;
  String? profileEmail;
  String? loggedInName;
  bool? signInStatus;
  int? totalGamePoints;

  late FirebaseAuth auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool>getGoggleSignStatus() async {
    var userSignedIn = await _googleSignIn.isSignedIn();
    return userSignedIn;
  }

  Future<FirebaseAuth>getAuthenticationData() async {

    FirebaseApp defaultApp = await Firebase.initializeApp();
    auth = FirebaseAuth.instanceFor(app: defaultApp);
    return auth;
  }

  //ToDo get username from server and compare it to the local public username and update if needed

  @override
  void initState() {
    getAuthenticationData().then((value) => setState((){loggedInName = value.currentUser?.displayName;profileEmail = value.currentUser?.email;}));
    getGoggleSignStatus().then((value) => setState((){signInStatus = value;}));
    super.initState();

    // profileName = widget.game.publicUserProfileName;
    // totalGamePoints = widget.game.publicTopTotalPoints;
    // profileEmail = widget.game.loggedInName;
    // loggedInName = widget.game.loggedInName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(constraints: const BoxConstraints.expand(),decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg/levels2.jpg"),fit: BoxFit.cover)),
            child: Center(
              child: AspectRatio(aspectRatio: 9/19,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: LoginPageWidget(game: widget.game,),
                    //child: LoginPage(game: widget.game,),
                  ),
                ),
              ),
            )));
  }
}




