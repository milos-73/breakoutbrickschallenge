import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:initial_project/forge2d_game_world.dart';
import 'list_of_friends.dart';

class Top20LevelsBoardFriends extends StatefulWidget {

  BrickBreakGame game;

  Top20LevelsBoardFriends({required this.game, Key? key}) : super(key: key);

  @override
  State<Top20LevelsBoardFriends> createState() => _Top20LevelsBoardFriendsState();
}

Map snapshotMapMap = {};
Map filteredMap = {};

DatabaseReference reference = FirebaseDatabase.instance.ref().child('leaderBoard');


class _Top20LevelsBoardFriendsState extends State<Top20LevelsBoardFriends> {


  @override
  void initState() {
    super.initState();
  }

  Widget listItem({required Map leaderBoard}) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.only(top: 6,bottom: 6,left: 15,right: 15),
      height: 40,
      color: Colors.black26.withOpacity(0.5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text('${leaderBoard['userName']}',style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),),
            ],),
          Column(children: [
            Text('${leaderBoard['stars'] ?? 0}',style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white)),
          ],),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Query dbRef = FirebaseDatabase.instance.ref().child('leaderboard').orderByChild('friends/${widget.game.keyID}').equalTo(widget.game.keyID);
    const FriendsListBuilder();

    return FirebaseAnimatedList(shrinkWrap: true, reverse: true,

      query: dbRef,
      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

        Map leaderBoard = snapshot.value as Map<dynamic,dynamic>;
        leaderBoard['key'] = snapshot.key;

        List<Map<dynamic, dynamic>> filteredNewMap = [];

        return listItem(leaderBoard: leaderBoard);
      },
    );
  }
}