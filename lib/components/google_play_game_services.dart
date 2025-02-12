import 'package:games_services/games_services.dart';

import '../forge2d_game_world.dart';

class GooglePlayGameServices{

  BrickBreakGame? game;

  Future<String> getPlayerName() async {
    String playerName = await Player.getPlayerName() ?? 'Not signed in';
    return playerName;
  }

  Future<bool> getSignInStatus() async {
   bool isSignIn = await GameAuth.isSignedIn;
   return isSignIn;
  }

  void signIn() async {
    try {
      await GameAuth.signIn();
      print('SIGNED IN');
    } catch (e) {
      print("Sign-in failed: $e");
    }
  }






}