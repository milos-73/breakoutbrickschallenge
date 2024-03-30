import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


import 'package:initial_project/ui/overlay_builder.dart';

import 'forge2d_game_world.dart';
import 'main_game.dart';

Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Flame.device.fullScreen();
  await Firebase.initializeApp();


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
