import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:initial_project/forge2d_game_world.dart';
import 'package:initial_project/ui/log_In.dart';
import 'package:initial_project/ui/registration_screen.dart';
import 'package:initial_project/ui/sign_with_google.dart';
import 'package:initial_project/ui/square_tile.dart';
import '../services/hex_color.dart';
import 'auth_screen.dart';
import 'dbTools.dart';
import 'google_welcome_widget.dart';

class LoginPage extends StatefulWidget {
  final BrickBreakGame game;

  const LoginPage({super.key, required this.game, });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isUserSignedIn = false;
  bool isUserSignInWithEmail = false;

  String? customProfileName;
  int? totalGamePoints;
  int? totalStars;
  int? finishedLevels;

  bool emailPassword = false;

  late FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DbTools dbTools = DbTools();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late final String? userName;


  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {

    FirebaseApp defaultApp = await Firebase.initializeApp();
    _auth = FirebaseAuth.instanceFor(app: defaultApp);

         //await widget.game.logInStatus();

    widget.game.loggedIn = FirebaseAuth.instance.currentUser?.email;
    widget.game.userSignedInProvider = FirebaseAuth.instance.currentUser?.displayName;

    if(widget.game.userSignedInProvider != null && widget.game.loggedIn != null){
      isUserSignedIn = true;
    }

    if(widget.game.userSignedInProvider == null && widget.game.loggedIn != null){
      isUserSignInWithEmail = true;
    }

    print('**++**_auth.currentUser:${_auth.currentUser}');
    print('**++**isUserSignedIn:${isUserSignedIn}');
    print('**++**isUserSignInWithEmail:${isUserSignInWithEmail}');
    print('**++**widget.game.userSignedInProvider:${widget.game.userSignedInProvider}');
    print('**++**widget.game.loggedIn: ${widget.game.loggedIn}');


    //await widget.game.getUserData();
  }

  Future<void> checkIfUserIsRegistered() async {

    var userSignedInEmail = FirebaseAuth.instance.currentUser;
    var userName = widget.game.prefs.getString('customUserProfileName');

    if(userSignedInEmail == null) {
      setState(() {
        isUserSignInWithEmail = false;
      });
      print('ERROR with REGISTRATION');
    }
    if(userSignedInEmail != null) {
      setState(() {
        isUserSignInWithEmail = true;
        customProfileName = userName;
      });

      DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('leaderboard/${userSignedInEmail.uid}');

      await dbRef.update({
        'name': userName,
        'userName' : userName,
        'email' : userSignedInEmail.email,
        'keyId' : userSignedInEmail.uid
      });
  }
}

  @override
  Widget build(BuildContext context) {

        return (isUserSignedIn || isUserSignInWithEmail) ?

        SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: (){widget.game.overlays.remove('MyAccount');}, icon: const FaIcon(FontAwesomeIcons.x, color: Colors.white,size: 16,)),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          onPressed: () async {
                            //onGoogleSignIn(context);

                            await FirebaseAuth.instance.signOut();
                            await _googleSignIn.signOut();

                            setState(() {
                            if (isUserSignedIn == true) { isUserSignedIn = !isUserSignedIn;
                            }
                            if (isUserSignInWithEmail == true){isUserSignInWithEmail = !isUserSignInWithEmail;}
                           });


                            print('_auth.currentUser: ${_auth.currentUser}');
                            widget.game.userSignedInProvider = null;
                            widget.game.loggedIn = null;
                            widget.game.loggedInName = '';


                          },
                          style: ElevatedButton.styleFrom(backgroundColor: isUserSignedIn ? Colors.transparent : Colors.blueAccent,),
                          child: Padding(padding: const EdgeInsets.all(4),
                              child: SizedBox(width: (widget.game.camera.viewport.canvasSize?.y)!/2.2,
                                child: Row( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    //Icon(Icons.account_circle, color: Colors.white),
                                    isUserSignedIn ? Image(width: (widget.game.camera.viewport.canvasSize?.y)!/30,image: const AssetImage('assets/images/google.png'))
                                    : Image(width: (widget.game.camera.viewport.canvasSize?.y)!/30,image: const AssetImage('assets/images/email.png')),
                                    SizedBox(width: (widget.game.camera.viewport.canvasSize?.y)!/30,),
                                    Text('Log out',style: TextStyle(fontSize: 17,color: HexColor('#8bf5aa')),),
                                    //FittedBox(fit: BoxFit.scaleDown, child: Text('You\'re logged in with Google',style: TextStyle(color: Colors.white)))
                                    //Text(isUserSignedIn ? 'You\'re logged in with Google' : 'Login with Google',style: const TextStyle(color: Colors.white))
                                  ],
                                ),
                              )
                          )
                      )
                  )
              ),
              WelcomeUserWidget(game: widget.game ,user: _auth.currentUser, googleSignIn: _googleSignIn, googleSignInStatus: isUserSignedIn, emailSignInStatus: isUserSignInWithEmail),

              Center( child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text('Public User Name',style: TextStyle(color: Colors.white,fontSize: 15)),
                      SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/110,),
                      Text('${widget.game.publicUserProfileName}',style: TextStyle(color: HexColor('#ffca72'),fontSize: 18)),
                      IconButton(onPressed: (){
                        editUserNameDialog(context: context);}, icon: FaIcon(FontAwesomeIcons.pencil,color: HexColor('#8bd6f5'),size: 15,))
                    ],
                  ),
                ],
              )),
              //Center( child: Text('Logged in name: $loggedInName',style: const TextStyle(color: Colors.white),)),
              //Center( child: Text('Logged in email: $profileEmail',style: const TextStyle(color: Colors.white),),),
              SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/30,),
              Center( child: Text('Best Score: ${widget.game.publicTopTotalPoints}',style: const TextStyle(color: Colors.white, fontSize: 16),),),
              const SizedBox(height: 3),
              Center( child: Text('Collected stars: ${widget.game.totalStars}',style: const TextStyle(color: Colors.white, fontSize: 16),),),
              const SizedBox(height: 3),
              Center( child: Text('Finished levels: ${widget.game.localLastFinishedLevel}',style: const TextStyle(color: Colors.white, fontSize: 16),),),
              SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/20,),
              SizedBox(width: (widget.game.camera.viewport.canvasSize?.y)!/2.2,
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Reset Game',
                        style: TextStyle(color: HexColor('#72edff'),fontSize: 18,),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              //Center( child: Text('Synchronize your levels',style: TextStyle(fontSize: 18,color: HexColor('#72edff')),),),
              SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/30,),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                  // Center(
                  //
                  //     child: ElevatedButton(
                  //       onPressed: () async {
                  //
                  //       },
                  //       style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,side: BorderSide(width: 1, color: HexColor('#ffca72').withOpacity(0.7))),
                  //       child: const Text(
                  //         'Reset Local',
                  //         style: TextStyle(fontSize: 16),
                  //       ),
                  //     )),

                  Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await widget.game.resetGameData();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,side: BorderSide(width: 1, color: HexColor('#ffca72').withOpacity(0.7))),
                        child: const Text(
                          'Reset All',
                          style: TextStyle(fontSize: 16),
                        ),
                      )),

                ],),
              )
            ],
          ),
        )

    : SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: (){widget.game.overlays.remove('MyAccount');}, icon: const FaIcon(FontAwesomeIcons.x, color: Colors.white,size: 16,)),
          SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/40,),

          //logo
          Icon(
            Icons.lock,
            size: (widget.game.camera.viewport.canvasSize?.y)!/17,
            color: Colors.white60,

          ),

         SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/50,),

          SizedBox(width: (widget.game.camera.viewport.canvasSize?.y)!/2.2,
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Login with',
                      style: TextStyle(color: Colors.grey[700]),
                      softWrap: false, overflow: TextOverflow.fade, maxLines: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/30,),
          // google + apple sign in buttons


          SizedBox(width: (widget.game.camera.viewport.canvasSize?.y)!/2.2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child:
                    SquareTile(imagePath: 'assets/images/email.png', onTap: () async {
                     // widget.game.overlays.add('blackScreen');
                      await showDialog(barrierDismissible: false, barrierColor: Colors.black, context: context, builder: (ctx) => WillPopScope(onWillPop: () => Future.value(false),
                          child: _loginWithEmailAndPassword(context: context)));
                      // widget.game.loggedIn = FirebaseAuth.instance.currentUser?.email;
                      // widget.game.userSignedInProvider = FirebaseAuth.instance.currentUser?.displayName;
                      await widget.game.logInStatus();
                      print('widget.game.userSignedInProvider: ${widget.game.userSignedInProvider}');
                      print('widget.game.loggedIn: ${widget.game.loggedIn}');
                      if(widget.game.userSignedInProvider == null && widget.game.loggedIn !=null){
                        //await widget.game.getUserData();

                        setState(() { isUserSignInWithEmail = !isUserSignInWithEmail;});
                      }else{print('SOMETHING WENT WRONG WITH EMAIL LOGIN');}
                                            },
                      game: widget.game, buttonText: 'Email/Password',),
                  ),
                  ],
              ),
            ),
          ),

          SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/30,),
          // not a member? register now
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'Not a member?',
                  style: TextStyle(color: Colors.grey[700]), softWrap: false, overflow: TextOverflow.fade, maxLines: 1,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: TextButton(onPressed: () async {
                  await showDialog(barrierDismissible: false, barrierColor: Colors.black, context: context, builder: (ctx) => WillPopScope(onWillPop: () => Future.value(false),
                      child: _registerWithEmailAndPassword(context: context)));
                  await checkIfUserIsRegistered();

                }, child: const Text('Register now',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,), softWrap: false, overflow: TextOverflow.fade, maxLines: 1,)

                ),
              ),
            ],
          ),

          SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/50,),


          SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/50,),


          SizedBox(width: (widget.game.camera.viewport.canvasSize?.y)!/2.2,
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(color: Colors.grey[700]),
                      softWrap: false, overflow: TextOverflow.fade, maxLines: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/30,),

          SizedBox(width: (widget.game.camera.viewport.canvasSize?.y)!/2.2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                   Expanded(
                    child:
                    SquareTile(game: widget.game,

                      onTap: () async {
                        await _handleSignIn();
                        await widget.game.logInStatus();

                        setState(() {isUserSignedIn = true;});
                        print('_auth.currentUser: ${_auth.currentUser}');
                        SignWithGoogle(game: widget.game,);},
                      imagePath: 'assets/images/google.png', buttonText: 'Google',),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/50,),
          SizedBox(width: (widget.game.camera.viewport.canvasSize?.y)!/2.2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                      child:
                      SquareTile(imagePath: 'assets/images/apple.png', onTap: () {}, game: widget.game, buttonText: 'Apple',)
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/50,),
          SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/50,),
          SizedBox(width: (widget.game.camera.viewport.canvasSize?.y)!/2.5,
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Reset Game',
                    style: TextStyle(color: HexColor('#72edff'),fontSize: 18,),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/50,),
          SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/50,),
          Center(

              child: ElevatedButton(
                onPressed: () async {
                  await widget.game.resetLocalGameData();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,side: BorderSide(width: 1, color: HexColor('#ffca72').withOpacity(0.7))),
                child: const Text(
                  'Reset Local',
                  style: TextStyle(fontSize: 16),
                ),
              )),
          SizedBox(height: (widget.game.camera.viewport.canvasSize?.y)!/50,),
        Center(child: widget.game.prefs.getString('customUserProfileName') != null ? Text('Last login as: ${widget.game.prefs.getString('customUserProfileName')}',style: TextStyle(fontSize: 14,color: Colors.white),)
            : Text('Last login as: No logged in yet',style: TextStyle(fontSize: 14,color: Colors.white),),)
      ],
      ),
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
      // setState(() {
      //   isUserSignedIn = userSignedIn;
      // });
        }
    return user;
  }

  Future<void> editUserNameDialog({required BuildContext context}) async {

    final TextEditingController textFieldController = TextEditingController();

    String? codeDialog;
    String? valueText;
    //String? customProfileName = ;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: HexColor('#ffdfab').withOpacity(0.9),
            title: const Row(
              children: [
                FaIcon(FontAwesomeIcons.user,size: 15),
                SizedBox(width: 5,),
                Text('User name'),
              ],
            ),
            content: Column(mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8,top: 5,left: 5,right: 5),
                  child: Text('Please type your new desired user name'),
                ),
                const SizedBox(height: 10,),
                TextField(                  
                  onChanged: (value) => customProfileName = value,
                  onSubmitted: (value) async {
                    if (await dbTools.checkUserName(customProfileName!) == false){
                      setState(() {
                       customProfileName = value;
                       valueText = value;
                      });
                      widget.game.localUserProfileName = value;
                      widget.game.publicUserProfileName = value;
                      await widget.game.prefs.setString('customUserProfileName', customProfileName ?? '');
                      if(isUserSignedIn == true || isUserSignInWithEmail == true) {
                       DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('leaderboard/${widget.game.keyID}');
                        await dbRef.update({
                          'userName' : value,
                          'name' : customProfileName,
                        });
                        if (!mounted) return;
                        Navigator.pop(context);
                      } else {print('PLEASE SIGN IN');}
                    }else{print('THE USER NAME ALREADY TAKEN');}},
                  controller: textFieldController,
                  decoration:
                  InputDecoration(hintText: '${widget.game.publicUserProfileName}', filled: true,fillColor: HexColor('#fef8d0')),
                ),
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                color: HexColor('#8bd6f5'),
                textColor: Colors.white,
                child: Text('CANCEL',style: TextStyle(color: HexColor('#1c2b31'),fontWeight: FontWeight.w500),),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                  color: HexColor('#8bf5aa'),
                  textColor: Colors.white,
                  child: Text('OK',style: TextStyle(color: HexColor('#1c2b31'),fontWeight: FontWeight.w500),),
                  onPressed: () async {
                    if (await dbTools.checkUserName(customProfileName!) == false){
                      setState(() {
                        widget.game.localUserProfileName = customProfileName;
                        widget.game.publicUserProfileName = customProfileName;});
                      await widget.game.prefs.setString('customUserProfileName', customProfileName ?? '');
                      if(isUserSignedIn == true  || isUserSignInWithEmail == true) {
                        DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('leaderboard/${widget.game.keyID}');
                        await dbRef.update({
                          'keyId': widget.game.keyID,
                          'userName': customProfileName,
                          'name' : customProfileName,
                        });
                        if (!mounted) return;
                        Navigator.pop(context);
                      }}})
            ],
          );
        });
  }

  // Future<void> _showSyncErrorAlertDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     barrierColor: Colors.black,// user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog( // <-- SEE HERE
  //         title: const Text('Something went Wrong. '),
  //         content: const SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('The requested data does not exists'),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  AlertDialog _loginWithEmailAndPassword({required BuildContext context}) {

    return AlertDialog(backgroundColor: HexColor('#ffdfab').withOpacity(0.9),
      title: const Row(
        children: [
          //FaIcon(FontAwesomeIcons.pencil,size: 15),
          SizedBox(width: 5,),
          Expanded(
            child: Text('Please enter your email and password',style: TextStyle(fontSize: 15,), textAlign: TextAlign.center,


            ),
          ),
        ],
      ),
        content: SingleChildScrollView(
        child: Column(children: [
          AuthScreen()
        ],),
      ),

    );
  }

  AlertDialog _registerWithEmailAndPassword({required BuildContext context}) {

    return AlertDialog(backgroundColor: HexColor('#ffdfab').withOpacity(0.9),
      title: const Row(
        children: [
          //FaIcon(FontAwesomeIcons.pencil,size: 15),
          SizedBox(width: 5,),
          Expanded(
            child: Text('Please enter your registration details',style: TextStyle(fontSize: 15,), textAlign: TextAlign.center,
              
            
            ),
          ),
        ],
      ),
      // title: const Text('Please enter your registration details'),
      content: Column(mainAxisSize: MainAxisSize.min,
        children: [
        RegistrationScreen(game: widget.game)
      ],),

    );
  }


}