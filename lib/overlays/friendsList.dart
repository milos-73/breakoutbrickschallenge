import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:initial_project/forge2d_game_world.dart';

import '../services/fetch_data.dart';
import '../services/insert_data.dart';

class FriendsList extends StatefulWidget {
  final BrickBreakGame game;


  const FriendsList({Key? key, required this.game}) : super(key: key);

  @override
  State<FriendsList> createState() => _FriendsListState();
}





class _FriendsListState extends State<FriendsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(constraints: const BoxConstraints.expand(),decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg/levels2.jpg"),fit: BoxFit.cover)),
    child: Container(width: 1080,height: 2340,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg/bg16.jpg"),fit: BoxFit.contain,)),
      child: Center(
        child: AspectRatio(aspectRatio: 9/19,
        child:
        //         Column(children: [
        //   ElevatedButton(onPressed: (){}, child: const Text('List of Users'))
        //
        // ],),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Image(
                width: 300,
                height: 300,
                image: NetworkImage(
                    'https://seeklogo.com/images/F/firebase-logo-402F407EE0-seeklogo.com.png'),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Firebase Realtime Database Series in Flutter 2022',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push( context, MaterialPageRoute( builder: (context) => const InsertUserData()));
                },
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
                child: const Text('Insert Data'),
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) =>  FetchData(game: widget.game,)));
                },
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
                child: const Text('Fetch Data'),
              ),
            ],
          ),
        ),

        )
      ),
   )));
  }
}
