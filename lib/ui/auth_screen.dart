import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/hex_color.dart';
import 'auth.dart';

class AuthScreen extends StatefulWidget {


  AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //Use this form key to validate user's input
  final _formKey = GlobalKey<FormState>();

  //Use this to store user inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  int error = 0;

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
              const SizedBox(height: 16.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom( backgroundColor: HexColor('#8bd6f5'),),
                    onPressed: () {
                      Navigator.pop(context);},
                    //Conditionally show the button label
                    child: Text('Cancel',style: TextStyle(color: HexColor('#1c2b31'),fontWeight: FontWeight.w500),),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: HexColor('#8bf5aa'),),
                    onPressed: () async {

                      if (_formKey.currentState!.validate()) {
                        error == 0;
                        await handleSubmit();
                        if (context.mounted){
                          if(error == 0){Navigator.pop(context);}}
                      }



                    },
                    //Conditionally show the button label
                    child: Text('Login',style: TextStyle(color: HexColor('#1c2b31'),fontWeight: FontWeight.w500),),
                  ),

                ],
              ),

              const SizedBox(height: 16.0),
              error == 1 ? const Center(child: Text('The email address is not registered.', maxLines: 2, textAlign: TextAlign.center, style: TextStyle(fontSize: 14,color: Colors.red),))
                  : error == 2 ? const Center(child: Text('The password is invalid.', maxLines: 2, textAlign: TextAlign.center, style: TextStyle(fontSize: 14,color: Colors.red),))
                  : error == 3 ? const Center(child: Text('Something went wrong.', maxLines: 2, textAlign: TextAlign.center, style: TextStyle(fontSize: 14,color: Colors.red),))
                  : const SizedBox(height: 0)
            ],
          ),
        ),
      );
  }

  handleSubmit() async {

    //Validate user inputs using formkey
    if (_formKey.currentState!.validate()) {
      //Get inputs from the controllers
      final email = _emailController.value.text;
      final password = _passwordController.value.text;

      try {
        // This will Log in the existing user in our firebase
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        error = 0;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            error = 1;
          });;
        } else if (e.code == 'wrong-password') {
         setState(() {
           error = 2;
         });
        }
      } catch (e) {
       setState(() {
         error = 3;
       });
      }
    }
      //await Auth().signInWithEmailAndPassword(email, password);
    }
}
