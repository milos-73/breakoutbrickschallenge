import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'main_game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Flame.device.fullScreen();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      return const MainGame();
  }
}
