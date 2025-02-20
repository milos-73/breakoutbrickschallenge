import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:games_services/games_services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../forge2d_game_world.dart';

class GooglePlayGameServices {

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
    print('IN SIGN IN FUNCTION');
    bool hasConnection = await InternetConnection().hasInternetAccess;
    if (hasConnection == false) {
      print('NO INTERNET CONNECTION');
      game?.connectionStatus = ConnectionStatus.offline;
      return;
    } else
      try {
        await GameAuth.signIn();
        game?.connectionStatus = ConnectionStatus.online;
        print('SIGNED IN');
      } catch (e) {
        game?.connectionStatus = ConnectionStatus.singInError;
        print("Sign-in failed: $e");
      }
  }

  void checkInternetConnection() async {
    print('IN Internet CONNECTION CHECK FUNCTION');
    bool hasConnection = await InternetConnection().hasInternetAccess;
    if (hasConnection == false) {
      print('NO INTERNET CONNECTION');
      game?.connectionStatus = ConnectionStatus.offline;
      } else {
        game?.connectionStatus = ConnectionStatus.online;
        print('PHONE IS ONLINE');
      }
  }

// Future<void> signInMain() async {
//   //var connectivityResult = await Connectivity().checkConnectivity();
//
//   if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
//    print('NO INTERNET CONNECTION');
//    //print('connectivityResultOffline:${connectivityResult}');
//    game?.connectionStatus = ConnectionStatus.offline;
//
//   } else
//   {
//     print('CONNECTION ONLINE');
//     //print('connectivityResultOnline:${connectivityResult}');
//     game?.connectionStatus = ConnectionStatus.online;
//     await GameAuth.signIn();
//     print('SIGNED IN');
//   }
//}
}