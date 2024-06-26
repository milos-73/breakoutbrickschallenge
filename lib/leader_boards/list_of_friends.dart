import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../forge2d_game_world.dart';

class FriendsListBuilder extends StatefulWidget {

  final BrickBreakGame game;

  FriendsListBuilder({required this.game, Key? key}) : super(key: key);

  @override
  State<FriendsListBuilder> createState() => _FriendsListBuilderState();
}

final dbRef =  FirebaseDatabase.instance.ref().child('leaderboard').orderByChild('friends/7ROOfcPvEGRwVP87b9mBi5KhbMe2').equalTo('7ROOfcPvEGRwVP87b9mBi5KhbMe2');
//final dbRef =  FirebaseDatabase.instance.ref().child('leaderboard').orderByChild('friends/${game.keyID}').equalTo(widget.game.keyID);

List<Map<dynamic, dynamic>> list = [];
List<Map> friends = [];

class _FriendsListBuilderState extends State<FriendsListBuilder> {

  @override
  Widget build(BuildContext context) {
    print('IN STERAMBUILDER');
    return FutureBuilder(
        future: dbRef.once(),
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {

          if(snapshot.data?.snapshot.value != null){

            if (snapshot.hasData) {
              print(snapshot.data?.snapshot.value);
              list.clear();
              friends.clear();
              Map<dynamic,dynamic> values = snapshot.data?.snapshot.value as Map<dynamic, dynamic>;
              values.forEach((key, value) {
                list.add(values);

              });

              for(var i = 0; i < list.length; i++){
                friends.add({'userName': list[i].values.elementAt(i)['userName'], 'points' : list[i].values.elementAt(i)['points']});
              }
              friends.sort((a,b) => (b['points']).compareTo(a['points']));

              if (list.isNotEmpty) {
                return ListView.builder(

                  shrinkWrap: true,
                  itemCount: friends.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      margin: const EdgeInsets.all(6),
                      padding: const EdgeInsets.only(top: 6,bottom: 6,left: 15,right: 15),
                      height: 40,
                      color: Colors.black26.withOpacity(0.5),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${friends[index]['userName']}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.orange.shade200)),
                            ],
                          ),
                          Column(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${friends[index]['points'] ?? 0}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.orange.shade200)),
                            ],
                          ),

                        ],),);
                  },

                );

              } else {
                return const Center(child: Text('There are no friends in your list',style: TextStyle(color: Colors.white),));
              }

            }else {return const CircularProgressIndicator();

            }
          }
          return const Center(child: Text('There are no friends in your list',style: TextStyle(color: Colors.white),));

        }

        );
  }
}
