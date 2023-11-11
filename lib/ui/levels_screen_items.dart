import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../forge2d_game_world.dart';
import '../services/saved_values.dart';

class LevelsScreenItems extends StatefulWidget {
  //final String? imageAsset;
  final BrickBreakGame gameRef;
  final int index;
  final int lastFinishedLevel;



  const LevelsScreenItems({Key? key,  required this.index,required this.gameRef, required this.lastFinishedLevel}) : super(key: key);

  @override
  State<LevelsScreenItems> createState() => _LevelsScreenItemsState();
}
 ///Prehodnotiť funkcie či sú potrebné obidve
class _LevelsScreenItemsState extends State<LevelsScreenItems>{

  SavedValues savedValues = SavedValues();
   int numberOfStars = 0;

  Future<void>levelOverlays()async {
    widget.gameRef.overlays.remove('LevelsMap');
    widget.gameRef.overlays.remove('blackScreen');
    widget.gameRef.overlays.remove('MainMenu');
    if(widget.gameRef.overlays.isActive('WinGame')){widget.gameRef.overlays.remove('WinGame');}
    if(widget.gameRef.overlays.isActive('LostLife')){widget.gameRef.overlays.remove('LostLife');}
    widget.gameRef.overlays.add('PreGame');
  }

  @override
  void initState(){

    savedValues.getNumberOfStars(widget.index).then((value) => setState(() {numberOfStars = value;})).then((value) => print('NUmber of Stars FROM LEVELS INIT STATE: $numberOfStars'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(onTap: () async {
   if (widget.index <= widget.lastFinishedLevel+1)
   {
     if (widget.gameRef.audioSettings == AudioSettings.on) {
       FlameAudio.play('levelSelection.mp3');
     }
     await savedValues.setCurrentPlayedLevelNumber(widget.index);
     await widget.gameRef.pickLevel(widget.index);
     await levelOverlays();}
   else {
     if (widget.gameRef.audioSettings == AudioSettings.on) {
       FlameAudio.play('wrong1.mp3');
     }} },
        child: Container(alignment: AlignmentDirectional.center,
          child: widget.index.toString().length == 2
              ?
          Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(alignment: AlignmentDirectional.center,
                  children: [
                     widget.lastFinishedLevel >= widget.index ?
                    Center(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: ColorFiltered(colorFilter: ColorFilter.mode(Colors.orange.shade200, BlendMode.modulate) ,child: Image.asset('assets/images/levels/${widget.index.toString()[0]}.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/27,))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: ColorFiltered(colorFilter: ColorFilter.mode(Colors.orange.shade200, BlendMode.modulate), child: Image.asset('assets/images/levels/${widget.index.toString()[1]}.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/27,))),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    )
                         :
                    Center(
                       child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               Padding(
                                 padding: const EdgeInsets.only(top: 6),
                                 child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     Center(child: Image.asset('assets/images/levels/${widget.index.toString()[0]}.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/27,)),
                                   ],
                                 ),
                               ),
                               Padding(
                                 padding: const EdgeInsets.only(top: 6),
                                 child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     Center(child: Image.asset('assets/images/levels/${widget.index.toString()[1]}.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/27,)),
                                   ],
                                 ),
                               ),
                             ],
                           ),

                         ],
                       ),
                     ),
                  ]
              ),
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.only(left:10, right: 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(children: [numberOfStars >= 1
                        ? Image.asset('assets/images/bonus/fullStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)
                        : Image.asset('assets/images/bonus/emptyStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)],),
                    Column(children: [numberOfStars >= 2
                        ? Image.asset('assets/images/bonus/fullStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)
                        : Image.asset('assets/images/bonus/emptyStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)],),
                    Column(children: [numberOfStars >= 3
                        ? Image.asset('assets/images/bonus/fullStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)
                        : Image.asset('assets/images/bonus/emptyStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)],),
                    Column(children: [numberOfStars >= 4
                        ? Image.asset('assets/images/bonus/fullStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)
                        : Image.asset('assets/images/bonus/emptyStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)],),
                    Column(children: [numberOfStars == 5
                        ? Image.asset('assets/images/bonus/fullStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)
                        : Image.asset('assets/images/bonus/emptyStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)],)
                  ],),
              ),
              const SizedBox(height: 5,)
            ],
          )

              : widget.index.toString().length == 3
          ?

          Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(alignment: AlignmentDirectional.center,
                  children: [
                    widget.lastFinishedLevel >= widget.index ?
                    Center(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: ColorFiltered(colorFilter: ColorFilter.mode(Colors.orange.shade200, BlendMode.modulate) ,child: Image.asset('assets/images/levels/${widget.index.toString()[0]}.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/27,))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: ColorFiltered(colorFilter: ColorFilter.mode(Colors.orange.shade200, BlendMode.modulate), child: Image.asset('assets/images/levels/${widget.index.toString()[1]}.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/27,))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: ColorFiltered(colorFilter: ColorFilter.mode(Colors.orange.shade200, BlendMode.modulate), child: Image.asset('assets/images/levels/${widget.index.toString()[2]}.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/27,))),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    )
                        :
                    Center(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: Image.asset('assets/images/levels/${widget.index.toString()[0]}.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/27,)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: Image.asset('assets/images/levels/${widget.index.toString()[1]}.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/27,)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: Image.asset('assets/images/levels/${widget.index.toString()[2]}.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/27,)),
                                  ],
                                ),
                              )
                            ],
                          ),

                        ],
                      ),
                    ),
                  ]
              ),
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.only(left:10, right: 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(children: [numberOfStars >= 1
                        ? Image.asset('assets/images/bonus/fullStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)
                        : Image.asset('assets/images/bonus/emptyStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)],),
                    Column(children: [numberOfStars >= 2
                        ? Image.asset('assets/images/bonus/fullStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)
                        : Image.asset('assets/images/bonus/emptyStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)],),
                    Column(children: [numberOfStars >= 3
                        ? Image.asset('assets/images/bonus/fullStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)
                        : Image.asset('assets/images/bonus/emptyStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)],),
                    Column(children: [numberOfStars >= 4
                        ? Image.asset('assets/images/bonus/fullStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)
                        : Image.asset('assets/images/bonus/emptyStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)],),
                    Column(children: [numberOfStars == 5
                        ? Image.asset('assets/images/bonus/fullStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)
                        : Image.asset('assets/images/bonus/emptyStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)],)
                  ],),
              ),
              const SizedBox(height: 5,)
            ],
          )

              :

          Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(alignment: AlignmentDirectional.center,
                  children: [
                    widget.lastFinishedLevel >= widget.index
                        ?
                    Center(
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(child: ColorFiltered(colorFilter: ColorFilter.mode(Colors.orange.shade200, BlendMode.modulate),child: Image.asset('assets/images/levels/${widget.index.toString()[0]}.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/27,))),
                            ],
                          ),
                        ],
                      ),
                    ):
                    Center(
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(child: Image.asset('assets/images/levels/${widget.index.toString()[0]}.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/27,)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ]
              ),
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.only(left:10, right: 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(children: [numberOfStars >= 1
                        ? Image.asset('assets/images/bonus/fullStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)
                        : Image.asset('assets/images/bonus/emptyStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)],),
                    Column(children: [numberOfStars >= 2
                        ? Image.asset('assets/images/bonus/fullStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)
                        : Image.asset('assets/images/bonus/emptyStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)],),
                    Column(children: [numberOfStars >= 3
                        ? Image.asset('assets/images/bonus/fullStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)
                        : Image.asset('assets/images/bonus/emptyStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)],),
                    Column(children: [numberOfStars >= 4
                        ? Image.asset('assets/images/bonus/fullStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)
                        : Image.asset('assets/images/bonus/emptyStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)],),
                    Column(children: [numberOfStars == 5
                        ? Image.asset('assets/images/bonus/fullStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)
                        : Image.asset('assets/images/bonus/emptyStar.png',height: (widget.gameRef.camera.viewport.canvasSize?.y)!/79)],)
                  ],),
              ),
              const SizedBox(height: 5,)
            ],
          ),
        ));
  }
}

















