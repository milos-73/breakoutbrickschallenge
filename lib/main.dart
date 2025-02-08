import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


import 'package:brickbreaker/ui/overlay_builder.dart';

import 'forge2d_game_world.dart';
import 'main_game.dart';

Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Flame.device.fullScreen();
  //await Firebase.initializeApp(options: FirebaseOptions(apiKey: 'AIzaSyDu0N2T4yb1DOkn4Lr7SRxzDcsnaLTKDK8', appId: '1:168883929200:android:e593ed2ca67e09371f34b5', messagingSenderId: '168883929200', projectId: 'breakout-bricks-challenge'));


  runApp(const MyApp());
}

//final _brickBreakGame = BrickBreakGame();

class MyApp extends StatelessWidget {
  const MyApp({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      return const MainGame();
  }
}
