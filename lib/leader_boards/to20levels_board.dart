import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:initial_project/forge2d_game_world.dart';

class Top20LevelsBoard extends StatefulWidget {

  BrickBreakGame game;


  Top20LevelsBoard({required this.game, Key? key}) : super(key: key);

  @override
  State<Top20LevelsBoard> createState() => _Top20LevelsBoardState();
}

class _Top20LevelsBoardState extends State<Top20LevelsBoard> {

  Query dbRef = FirebaseDatabase.instance.ref().child('leaderboard').orderByChild('stars').limitToLast(20);
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('leaderBoard');

  Widget listItem({required Map leaderBoard}) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.only(top: 6,bottom: 6,left: 15,right: 15),
      height: 40,
      color: Colors.black26.withOpacity(0.5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${leaderBoard['userName']}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.orange.shade200),),
            ],),
          Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text('${leaderBoard['stars'] ?? 0}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.orange.shade200)),
          ],),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //
          //     const SizedBox(height: 5,),
          //
          //     const SizedBox(height: 5,),
          //     Text('${widget.game.keyID}',style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          //     const SizedBox(height: 5,),
          //     Text('${leaderBoard['key']}',style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         //GestureDetector(onTap: () {Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateRecord(studentKey: leaderBoard['key'])));},
          //           GestureDetector(onTap: () {addFriend(friendKey: leaderBoard['key'], userKey: widget.game.keyID);},
          //           child: Row(
          //             children: [
          //               Icon(Icons.add,color: Theme.of(context).primaryColor,),
          //             ],
          //           ),
          //         ),
          //         const SizedBox(width: 6,),
          //         GestureDetector(onTap: () {removeFriend(friendKey: leaderBoard['key'], userKey: widget.game.keyID);
          //         //GestureDetector(onTap: () {reference.child(leaderBoard['key']).remove();
          //         },
          //           child: Row(
          //             children: [
          //               Icon(Icons.delete,color: Colors.red[700],),
          //             ],
          //           ),
          //         ),
          //       ],
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(shrinkWrap: true, reverse: true,
      query: dbRef,
      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

        Map leaderBoard = snapshot.value as Map;
        leaderBoard['key'] = snapshot.key;

        //print('leaderBoard: ${leaderBoard}');

        return listItem(leaderBoard: leaderBoard);
      },
    );
  }
}