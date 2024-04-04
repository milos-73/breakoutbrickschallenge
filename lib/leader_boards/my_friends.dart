import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:initial_project/forge2d_game_world.dart';
import 'package:initial_project/services/update_record.dart';

import '../services/hex_color.dart';

class MyFriendsList extends StatefulWidget {

  final BrickBreakGame game;


  MyFriendsList({required this.game, Key? key}) : super(key: key);

  @override
  State<MyFriendsList> createState() => _MyFriendsListState();
}

class _MyFriendsListState extends State<MyFriendsList> {


  DatabaseReference reference = FirebaseDatabase.instance.ref().child('leaderBoard');

  Widget listItem({required Map leaderBoard}) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.only(top: 6,bottom: 6,left: 15,right: 15),
      height: 40,
      color: Colors.black26.withOpacity(0.5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.user,color: HexColor('#72a7ff'),size: 15,),
                  const SizedBox(width: 15,),
                  Text('${leaderBoard['userName']}',style: TextStyle(color: Colors.orange.shade200),),
                ],
              ),
            ],
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${leaderBoard['points']} / ${leaderBoard['stars']}',style: TextStyle(color: Colors.orange.shade200),),
                  const SizedBox(width: 15,),
                  GestureDetector(onTap: () {removeFriend(friendDetails: leaderBoard, userKey: widget.game.keyID );},
                    child: FaIcon(FontAwesomeIcons.x,color: HexColor('#72a7ff'),size: 15,),
                  )],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Query dbRef = FirebaseDatabase.instance.ref().child('leaderboard').orderByChild('friends/${widget.game.keyID}').equalTo(widget.game.keyID);


    return FirebaseAnimatedList(shrinkWrap: true, reverse: true,
      query: dbRef,
      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

        Map leaderBoard = snapshot.value as Map;
        leaderBoard['key'] = snapshot.key;

        return listItem(leaderBoard: leaderBoard);
      },
    );
  }


  Future<void> removeFriend({required Map friendDetails, String? userKey}) async {

    DatabaseReference friendReference = FirebaseDatabase.instance.ref().child('leaderboard/$userKey/friends');
    DatabaseReference myReference = FirebaseDatabase.instance.ref().child('leaderboard/${friendDetails['keyId']}/friends');

    await friendReference.child(friendDetails['keyId'].toString()).remove();
    await myReference.child(userKey!).remove();

  }
}