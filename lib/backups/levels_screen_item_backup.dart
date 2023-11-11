// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// import '../forge2d_game_world.dart';
// import '../services/saved_values.dart';
//
// class LevelsScreenItems extends StatefulWidget {
//   final String? imageAsset;
//   final BrickBreakGame gameRef;
//   final int index;
//
//
//   const LevelsScreenItems({Key? key,  required this.index,required this.gameRef, this.imageAsset}) : super(key: key);
//
//   @override
//   State<LevelsScreenItems> createState() => _LevelsScreenItemsState();
// }
//
// class _LevelsScreenItemsState extends State<LevelsScreenItems>{
//   SavedValues savedValues = SavedValues();
//
//   Future<void>levelOverlays()async {
//     widget.gameRef.overlays.remove('LevelsMap');
//     widget.gameRef.overlays.remove('blackScreen');
//     widget.gameRef.overlays.add('PreGame');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double brickWidth = (MediaQuery.of(context).size.width /4)-25;
//     double brickHeight = MediaQuery.of(context).size.width /8;
//
//     print('brickWidth${brickWidth}');
//     print('20%: ${brickWidth*0.2}');
//
//
//
//     return InkWell(onTap: () async {
//
//       await savedValues.setCurrentPlayedLevelNumber(widget.index+1);print('LEVEL BUTTON 1'); await widget.gameRef.pickLevel(widget.index+1); await levelOverlays();
//
//     }, child: Padding(
//       padding: const EdgeInsets.only(left: 4,right: 4,top: 10),
//       child: Container(alignment: AlignmentDirectional.topCenter, width: brickWidth,
//         child: Stack(
//
//             children: [
//               Image.asset('assets/images/levels/emptyBrick1.png',fit: BoxFit.cover),
//               Positioned(left:brickWidth*0.23, top: brickHeight*0.05,height: MediaQuery.of(context).size.width /10,width: 28, child: Image.asset('assets/images/levels/6.png')),
//               //Positioned(left: brickWidth*0.55,top: brickHeight *0.1,child: SizedBox(height: MediaQuery.of(context).size.width /10,width: 28, child: Image.asset('assets/images/levels/2.png'),)),
//               Positioned(left: brickWidth*0.55,top:brickHeight*0.05, height: MediaQuery.of(context).size.width /10,width: 28, child: Image.asset('assets/images/levels/2.png')),
//               //const Positioned(top:0, left: 0, child: FaIcon(FontAwesomeIcons.circle, color: Colors.yellow,size: 10,)),
//               //Positioned(top:0, left: brickWidth, child: FaIcon(FontAwesomeIcons.circle, color: Colors.yellow,size: 10,))
//             ]
//         ),
//       ),
//     ));
//
//     //child: Padding(padding: const EdgeInsets.only(left: 4,right: 4), child: Center(child: Image.asset('${widget.imageAsset}') ,), ),);
//   }
// }
