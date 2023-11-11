// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:initial_project/services/saved_values.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../forge2d_game_world.dart';
//
// class LevelsMap extends StatefulWidget with SavedValues {
//
//   final BrickBreakGame gameRef;
//
//   const LevelsMap({Key? key, required this.gameRef}) : super(key: key);
//
//   @override
//   State<LevelsMap> createState() => _LevelsMapState();
// }
//
// class _LevelsMapState extends State<LevelsMap> {
//   late int lastFinishedLevel = 0;
//   SavedValues savedValues = SavedValues();
//
//   Future<void>levelOverlays()async {
//     widget.gameRef.overlays.remove('LevelsMap');
//     widget.gameRef.overlays.remove('blackScreen');
//     widget.gameRef.overlays.add('PreGame');
//   }
//
//
//
//
//
// @override
//   void initState() {
//   savedValues.getLastFinishedLevel()
//       //.then((value) => print('getLastFinishedLevel: ${value}'))
//       .then((value) => setState(() {lastFinishedLevel = value;}));
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var x =  MediaQuery.of(context).size.width *2;
//     var y =  MediaQuery.of(context).size.height *2;
//
//     return InteractiveViewer(
//         constrained: false,
//         child: Stack(
//             children: [Image.asset(
//               'assets/images/menuscreen.jpg',
//               width: x,
//               height: y,
//               fit: BoxFit.cover,
//               repeat: ImageRepeat.noRepeat,
//             ),
//               Positioned(left: 0, top:20, child:GestureDetector(onTap: () async {await savedValues.setCurrentPlayedLevelNumber(1);print('LEVEL BUTTON 1'); await widget.gameRef.pickLevel(1); await levelOverlays(); },child: SizedBox(height: x*0.1,width: y*0.1,child: lastFinishedLevel < 1 ? Image.asset('assets/images/levels/1.png',) : Image.asset('assets/images/levels/1a.png',))),),
//               Positioned(left: x*0.07, top:y*0.06, child:GestureDetector(onTap: () async {await savedValues.setCurrentPlayedLevelNumber(2);print('LEVEL BUTTON 2');await widget.gameRef.pickLevel(2);await levelOverlays();},child: SizedBox(height: x*0.1,width: y*0.1,child: lastFinishedLevel < 2  ? Image.asset('assets/images/levels/2.png',) : Image.asset('assets/images/levels/2a.png',))),),
//               Positioned(left: x*0.18, top:y*0.02, child:GestureDetector(onTap: () async {await savedValues.setCurrentPlayedLevelNumber(3); print('LEVEL BUTTON 2');await widget.gameRef.pickLevel(3);await levelOverlays();},child: SizedBox(height: x*0.1,width: y*0.1,child: lastFinishedLevel < 3 ? Image.asset('assets/images/levels/3.png',) : Image.asset('assets/images/levels/3a.png',))),),
//               Positioned(left: x*0.28, top:y*0.075, child:GestureDetector(onTap: () async {await savedValues.setCurrentPlayedLevelNumber(4);  BrickBreakGame();},child: SizedBox(height: x*0.1,width: y*0.1,child: lastFinishedLevel < 4 ? Image.asset('assets/images/levels/4.png',) : Image.asset('assets/images/levels/4a.png',))),),
//               Positioned(left: x*0.39, top:y*0.03, child:GestureDetector(onTap: () async {await savedValues.setCurrentPlayedLevelNumber(5);  BrickBreakGame();},child: SizedBox(height: x*0.1,width: y*0.1,child: lastFinishedLevel < 5 ? Image.asset('assets/images/levels/5.png',) : Image.asset('assets/images/levels/5a.png',))),),
//               Positioned(left: x*0.49, top:y*0.01, child:GestureDetector(onTap: (){print('5 was tapped');},child: SizedBox(height: x*0.1,width: y*0.1,child: lastFinishedLevel < 6 ? Image.asset('assets/images/levels/6.png',) : Image.asset('assets/images/levels/6a.png',))),),
//               Positioned(left: x*0.56, top:y*0.07, child:GestureDetector(onTap: (){print('7 was tapped');},child: SizedBox(height: x*0.1,width: y*0.1,child: lastFinishedLevel < 7 ? Image.asset('assets/images/levels/7.png',) : Image.asset('assets/images/levels/7a.png',))),),
//               Positioned(left: x*0.67, top:y*0.09, child:GestureDetector(onTap: (){print('8 was tapped');},child: SizedBox(height: x*0.1,width: y*0.1,child: lastFinishedLevel < 8 ? Image.asset('assets/images/levels/8.png',) : Image.asset('assets/images/levels/8a.png',))),),
//               Positioned(left: x*0.75, top:y*0.05, child:GestureDetector(onTap: (){print('9 was tapped');},child: SizedBox(height: x*0.1,width: y*0.1,child: lastFinishedLevel < 9 ? Image.asset('assets/images/levels/9.png',) : Image.asset('assets/images/levels/9a.png',))),),
//               Positioned(left: x*0.85, top:y*0.08, child:GestureDetector(onTap: (){print('10 was tapped');},child: SizedBox(height: x*0.1,width: y*0.1,child: lastFinishedLevel < 10 ? Image.asset('assets/images/levels/10.png',) : Image.asset('assets/images/levels/10a.png',))),),
//               ]
//         ));
//   }
// }