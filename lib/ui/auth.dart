import 'package:firebase_auth/firebase_auth.dart';

class Auth{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerWithEmailAndPassword (String email, String password) async {

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
     if (e.code == 'week-password'){
       print('Password too week');
     } else if (e.code == 'email-already-in-use') {
       print('The account already exists for that email');
     }
    }catch (e){print(e);}

  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      // This will Log in the existing user in our firebase
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }

}