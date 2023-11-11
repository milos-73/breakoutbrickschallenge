import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:initial_project/forge2d_game_world.dart';
import 'dart:math';
import '../services/saved_values.dart';
import 'levels_screen_items.dart';

class Levels extends StatefulWidget {

  final BrickBreakGame gameRef;

  const Levels({Key? key, required this.gameRef}) : super(key: key);

  @override
  State<Levels> createState() => _LevelsState();
}

class _LevelsState extends State<Levels> {

  late int lastFinishedLevel = 0;
  SavedValues savedValues = SavedValues();

  @override
  void initState() {
    savedValues.getLastFinishedLevel()
        .then((value) => setState(() {lastFinishedLevel = value;}));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(onPressed: () async {

          if (widget.gameRef.audioSettings == AudioSettings.on) {
            await FlameAudio.play('button3.mp3');
          }

          widget.gameRef.overlays.remove('LevelsMap');
          if (!widget.gameRef.overlays.isActive('MainMenu')){widget.gameRef.overlays.add('MainMenu');}
          }, backgroundColor: Colors.orange.shade200, elevation: 12,child: const FaIcon(FontAwesomeIcons.house,color: Colors.black),),
      ),
      body: Container(constraints: const BoxConstraints.expand(),decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg/levels2.jpg"),fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.only(top:20),
          child: Container(width: widget.gameRef.size.x *30,height: widget.gameRef.size.y * 30,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg/levels2.jpg"),fit: BoxFit.contain)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                  Expanded(child: Center(child: AspectRatio(aspectRatio: 9/19,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: LayoutBuilder(builder:(context, constraints ) {
                        return
                        GridView.builder(
                            shrinkWrap: true,
                            itemCount: 450,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 1.2,

                            ),
                            itemBuilder: (context, index) =>
                                LevelsScreenItems(
                                  lastFinishedLevel: lastFinishedLevel,
                                  gameRef: widget.gameRef,
                                  index: index + 1,));

                      }),
                    ),
                  ))),
                ],)),
        ),
      ),

      );
  }
}
