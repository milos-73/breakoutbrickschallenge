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
    bool hasConnection = await InternetConnection().hasInternetAccess;
    if (hasConnection == false) {
      game?.connectionStatus = ConnectionStatus.offline;
      return;
    } else
      try {
        await GameAuth.signIn();
        game?.connectionStatus = ConnectionStatus.online;
      } catch (e) {
        game?.connectionStatus = ConnectionStatus.singInError;
      }
  }

  void checkInternetConnection() async {
    bool hasConnection = await InternetConnection().hasInternetAccess;
    if (hasConnection == false) {
      game?.connectionStatus = ConnectionStatus.offline;
      } else {
        game?.connectionStatus = ConnectionStatus.online;
      }
  }
}