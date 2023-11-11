import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:initial_project/forge2d_game_world.dart';
import 'package:username_gen/username_gen.dart';

import '../services/hex_color.dart';
import 'auth.dart';
import 'dbTools.dart';

class RegistrationScreen extends StatefulWidget {
  final BrickBreakGame game;

  const RegistrationScreen({super.key, required this.game});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //Use this form key to validate user's input
  final _formKey = GlobalKey<FormState>();
  final DbTools dbTools = DbTools();
  bool? userNameAvailabilityStatus = false;
  bool? emailAvailabilityStatus = false;

  //Use this to store user inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  int? error = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        //Add form to key to the Form Widget
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              //Assign controller
              controller:_emailController,
              //Use this function to validate user input
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Email', filled: true,fillColor: HexColor('#fef8d0')
              ),
            ),
            const SizedBox(height: 3,),
            TextFormField(
              //Assign controller
              controller:_passwordController,
              obscureText: true,
              //Use this function to validate user
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Password', filled: true,fillColor: HexColor('#fef8d0')
              ),
            ),
 const SizedBox(height: 3,),
            TextFormField(
              //Assign controller
              controller:_userNameController,
              obscureText: false,
              //Use this function to validate user
              validator: (value) {

                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;

              },
              decoration: InputDecoration(
                hintText: 'User Name', filled: true,fillColor: HexColor('#fef8d0')
              ),
            ),
            const SizedBox(height: 5.0),
            Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
              TextButton(onPressed: () async {

                setState(() {
                  _userNameController.text = UsernameGen().generate();
                });
              }, child: Text('Generate custom name', style: TextStyle(color: HexColor('#9b56bb')),))
            ],),
            const SizedBox(height: 16.0),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom( backgroundColor: HexColor('#8bd6f5'),),
                  onPressed: () {
                    Navigator.pop(context);},
                  //Conditionally show the button label
                  child: Text('Cancel',  style: TextStyle(color: HexColor('#1c2b31'),fontWeight: FontWeight.w500),),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: HexColor('#8bf5aa'),),
                  onPressed: () async {

                    userNameAvailabilityStatus = false;
                    emailAvailabilityStatus = false;

                    await checkAccountAvailability();

                    // emailAvailabilityStatus = await dbTools.checkUserEmail(_emailController.text);
                    // userNameAvailabilityStatus = await dbTools.checkUserName(_userNameController.text);

                    print('emailAvailabilityStatus: ${emailAvailabilityStatus}');
                    print('userNameAvailabilityStatus: ${userNameAvailabilityStatus}');

                    if (_formKey.currentState!.validate()) {
                      if (userNameAvailabilityStatus == false && emailAvailabilityStatus == false){
                        userNameAvailabilityStatus = false;
                        emailAvailabilityStatus = false;
                        await handleRegistration();
                        widget.game.loggedInName = _userNameController.text;
                        widget.game.localUserProfileName = _userNameController.text;
                        widget.game.publicUserProfileName = _userNameController.text;
                        if (error == 0) {
                          if (context.mounted){
                            Navigator.pop(context);}
                        }
                      }
                      else{print('ERROR REGISTRATION');
                      }
                    }
                  },
                  //Conditionally show the button label
                  child: Text('Register',style: TextStyle(color: HexColor('#1c2b31'),fontWeight: FontWeight.w500),),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            userNameAvailabilityStatus == false ? const SizedBox(height: 0,) : const Text('The user name\'s already taken',textAlign: TextAlign.center,maxLines: 2,style: TextStyle(fontSize: 16, color: Colors.red),),
            emailAvailabilityStatus == false ? const SizedBox(height: 0,) : const Text('Email\'s already taken',textAlign: TextAlign.center,maxLines: 2,style: TextStyle(fontSize: 16, color: Colors.red),),
            error == 1 ? const Text('Week password. It should be at least 6 characters.',textAlign: TextAlign.center,maxLines: 2,style: TextStyle(fontSize: 16, color: Colors.red),) : const SizedBox(height: 0,)
          ],
        ),
      ),
    );
  }

  Future<void> handleRegistration() async {

      final email = _emailController.value.text;
      final password = _passwordController.value.text;

      try {
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
        setState(() {
          error = 0;
        });
      } on FirebaseAuthException catch (e) {print('***e***:${e.code}');
        if (e.code == 'weak-password'){
          setState(() {
            error = 1;
          });
          print('Password too week');
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            error = 2;
          });
          print('The account already exists for that email');
        }
      }catch (e){error = 3; print('***e***:${e}');}


      //await Auth().registerWithEmailAndPassword(email, password);

      widget.game.prefs.setString('customUserProfileName', _userNameController.text);
  }



  Future<void> checkAccountAvailability () async {

    var emailStatus = await dbTools.checkUserEmail(_emailController.value.text);
    var userStatus = await dbTools.checkUserName(_userNameController.text);

    setState(() {
      emailAvailabilityStatus = emailStatus;
      userNameAvailabilityStatus = userStatus;
    });


  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //   emailAvailabilityStatus = false;
  //
  //   try {
  //     await auth.createUserWithEmailAndPassword(email: email, password: password);
  //
  //     print('***_auth.currentUser?.email***: ${auth.currentUser?.email}');
  //           } on FirebaseAuthException catch (e) {
  //     if (e.code == 'week-password'){
  //
  //       print('Password too week');
  //     } else if (e.code == 'email-already-in-use') {
  //       setState(() {
  //         emailAvailabilityStatus = true;
  //       });
  //
  //       print('The account already exists for that email');
  //     }
  //   } catch (e){print(e);}
  //
  //   if(userNameAvailabilityStatus == false && emailAvailabilityStatus == false)
  //   {
  //     if (context.mounted){
  //       Navigator.pop(context);}
  //   }
  //
 }


}

