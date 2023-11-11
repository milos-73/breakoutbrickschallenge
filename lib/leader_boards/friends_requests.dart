import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:initial_project/forge2d_game_world.dart';
import 'package:initial_project/services/update_record.dart';

class FriendsRequests extends StatefulWidget {

  BrickBreakGame game;
  FriendsRequests({required this.game, Key? key}) : super(key: key);

    @override
  State<FriendsRequests> createState() => _FriendsRequestsState();
}

class _FriendsRequestsState extends State<FriendsRequests> {

   @override
  void initState() {
     print('userID: ${widget.game.keyID}');
    super.initState();
  }

  //Query dbRef = FirebaseDatabase.instance.ref().child('leaderboard').orderByChild('points').limitToLast(20);
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('leaderBoard');


  Widget listItem({required DataSnapshot leaderBoard}) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.only(top: 6,bottom: 6,left: 15,right: 15),
      height: 110,
      color: Colors.amberAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('User name: ${leaderBoard.value}',style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
          const SizedBox(height: 5,),
          // Text('Points: ${int.tryParse(leaderBoard['points'])}',style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          // const SizedBox(height: 5,),
          Text('${leaderBoard.key}',style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          // const SizedBox(height: 5,),
          // Text('${leaderBoard['key']}',style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //GestureDetector(onTap: () {Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateRecord(studentKey: leaderBoard['key'])));},
              // GestureDetector(onTap: () {addFriend(friendKey: leaderBoard['key'], userKey: widget.game.keyID);},
              //   child: Row(
              //     children: [
              //       Icon(Icons.add,color: Theme.of(context).primaryColor,),
              //     ],
              //   ),
              // ),
              // const SizedBox(width: 6,),
              // GestureDetector(onTap: () {removeFriend(friendKey: leaderBoard['key'], userKey: widget.game.keyID);
              //   //GestureDetector(onTap: () {reference.child(leaderBoard['key']).remove();
              // },
              //   child: Row(
              //     children: [
              //       Icon(Icons.delete,color: Colors.red[700],),
              //     ],
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Query friends = FirebaseDatabase.instance.ref().child('friends/${widget.game.keyID}');

    return FirebaseAnimatedList(shrinkWrap: true, reverse: true,
      query: friends,
      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

        print('leaderBoard2: ${snapshot.value}');

        //Map leaderBoard = snapshot as Map;
        //leaderBoard['key'] = snapshot.key;

        //print('leaderBoard3: ${leaderBoard.keys}');

        return listItem(leaderBoard: snapshot);

      },
    )
    ;
  }

  Future<void> addFriend({required userKey, required friendKey}) async {

    DatabaseReference reference = FirebaseDatabase.instance.ref().child('friends/$userKey');
    await reference.update({friendKey.toString():true});

  }

  Future<void> removeFriend({required userKey, required friendKey}) async {

    DatabaseReference reference = FirebaseDatabase.instance.ref().child('friends/$userKey');
    await reference.child('$friendKey').remove();

  }
}