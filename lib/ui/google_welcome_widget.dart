import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../forge2d_game_world.dart';
import 'my_account_overlay.dart';

class WelcomeUserWidget extends StatefulWidget {

  final GoogleSignIn? googleSignIn;
  final User? user;
  final BrickBreakGame game;
  final bool? googleSignInStatus;
  final bool? emailSignInStatus;

  const WelcomeUserWidget({super.key, this.googleSignIn, this.user, required this.game, this.googleSignInStatus, this.emailSignInStatus});

  @override
  State<WelcomeUserWidget> createState() => _WelcomeUserWidgetState();
}

class _WelcomeUserWidgetState extends State<WelcomeUserWidget> {
  @override
  Widget build(BuildContext context) {

    print('***widget.game.publicUserProfileName***:${widget.game.publicUserProfileName}');
    print('***widget.game.loggedInName***:${widget.game.loggedInName}');

    return Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(10),
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // ClipOval(
                    //     child: Image.network(
                    //         widget.user?.photoURL ?? '',
                    //         width: 100,
                    //         height: 100,
                    //         fit: BoxFit.cover
                    //     )
                    // ),
                    SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/80,),
                    const Text('Welcome', textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 16),),
                    SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/70,),
                    widget.googleSignInStatus == true ?
                    Text(widget.user?.displayName ?? '', textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white))
                    : Text(widget.game.publicUserProfileName ?? '', textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white))

                    ,
                    SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/90,),
                    Text(widget.user?.email ?? '', textAlign: TextAlign.center,style: const TextStyle(color: Colors.white),),
                    SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/40,),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       widget.googleSignIn?.signOut();
                    //       setState(() {
                    //         widget.game.loggedIn = false;
                    //         widget.game.loggedInName = null;
                    //         widget.game.loggedInEmail = '';
                    //       });
                    //       //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LeaderBoard(game: widget.game,)),);
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.redAccent,),
                    //     child: Padding(
                    //         padding: const EdgeInsets.all(10),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: const <Widget>[
                    //             Icon(Icons.exit_to_app, color: Colors.white),
                    //             SizedBox(width: 10),
                    //             Text('Log out of Google', style: TextStyle(
                    //                 color: Colors.white))
                    //           ],
                    //         )
                    //     )
                    // )
                  ],
                )
            )

    );
  }
}