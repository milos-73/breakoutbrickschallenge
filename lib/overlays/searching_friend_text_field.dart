import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:initial_project/forge2d_game_world.dart';

import '../leader_boards/search_friends.dart';


class SearchingFriend extends StatefulWidget {

  final BrickBreakGame game;

  const SearchingFriend({Key? key, required this.game}) : super(key: key);

  @override
  State<SearchingFriend> createState() => _SearchingFriendState();
}

class _SearchingFriendState extends State<SearchingFriend> {


  @override
  void initState() {
    super.initState();
  }

// build the app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold( resizeToAvoidBottomInset: false,
        // AppBar
        body: Container(constraints: const BoxConstraints.expand(),decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg/levels2.jpg"),fit: BoxFit.cover)),
          child: Center(
            child: SingleChildScrollView(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const Text(
                    'Find and check the username',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: TextField(textAlign: TextAlign.center,
                      onChanged: (value) => widget.game.searchedFriend = value,
                      onSubmitted: (value) {widget.game.searchedFriend = value;
                      widget.game.overlays.remove('SearchFriend');},
                      decoration: InputDecoration(filled: true,fillColor: Colors.white54, enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.amber, width: 3 ),
                          borderRadius: BorderRadius.circular(10)),
                          hintText: 'Názov alebo časť názvu pivovaru',
                          contentPadding: const EdgeInsets.fromLTRB(8, 8, 5, 5)),
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                  Center(
                      child: ElevatedButton(
                        onPressed: (){print('USER NAME: ${widget.game.searchedFriend}');
                        widget.game.overlays.remove('SearchFriend');
                          },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                        child: const Text(
                          'Find Friend',
                          style: TextStyle(fontSize: 16),
                        ),
                      )),


                ],
              ),
            ),
          ),
        ), // TabBarView
      ), // DefaultTabController
    ); // MaterialApp
  }
}
