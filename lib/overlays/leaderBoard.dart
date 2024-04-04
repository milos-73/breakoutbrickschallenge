import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:initial_project/forge2d_game_world.dart';
import 'package:initial_project/leader_boards/sent_friendship_request.dart';
import 'package:initial_project/leader_boards/top20Levels_friends.dart';
import 'package:initial_project/leader_boards/top20_board.dart';
import 'package:initial_project/services/fetch_data.dart';

import '../leader_boards/list_of_friends.dart';
import '../leader_boards/my_friends.dart';
import '../leader_boards/recieved_friendship_requests.dart';
import '../leader_boards/search_friends.dart';
import '../leader_boards/to20levels_board.dart';

import '../leader_boards/top20challenege_friends.dart';


enum LeaderBoardScreen {
  top20challenge,
  top20stars,
  friendsList,
  friendRequests,
  searchFriends,
}

class LeaderBoard extends StatefulWidget {

  final BrickBreakGame game;

  const LeaderBoard({Key? key, required this.game}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {

  LeaderBoardScreen leaderBoard = LeaderBoardScreen.top20challenge;

  @override
  void initState() {

    super.initState();
  }

// build the app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
         // AppBar
        body: Container(constraints: const BoxConstraints.expand(),decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg/levels2.jpg"),fit: BoxFit.cover)),
          child: Container(width: 1080,height: MediaQuery.of(context).size.height,decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/bg/bg16.jpg"),fit: BoxFit.contain,)),
            child:  Center(
              child: AspectRatio(aspectRatio: 9/19,
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [Padding(
                        padding: const EdgeInsets.only(top: 15,bottom: 15,left: 10,right: 10),
                        child:
                        leaderBoard == LeaderBoardScreen.top20challenge ? const Text('TOP 20 challenge World',style: TextStyle(color: Colors.white,fontSize: 20),)
                            : leaderBoard == LeaderBoardScreen.top20stars ? const Text('TOP 20 Levels Worlds',style: TextStyle(color: Colors.white,fontSize: 20),)
                            : leaderBoard == LeaderBoardScreen.friendsList ? const Text('My Friends',style: TextStyle(color: Colors.white,fontSize: 20),)
                            : leaderBoard == LeaderBoardScreen.friendRequests ? const Text('My received requests',style: TextStyle(color: Colors.white,fontSize: 20),)
                            //: leaderBoard == LeaderBoardScreen.friendRequests ? const Text('Friends Requests',style: TextStyle(color: Colors.white,fontSize: 20),)
                            : const Text('TOP 20',style: TextStyle(color: Colors.white,fontSize: 20),)
                      ),],),
                    Expanded(
                      child: Column(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //leaderBoard == LeaderBoardScreen.top20 ? const Expanded(child: FetchData())
                                leaderBoard == LeaderBoardScreen.top20challenge ? Flexible(child: Top20Board(game: widget.game,))
                              : leaderBoard == LeaderBoardScreen.top20stars ? Flexible(child: Top20LevelsBoard(game: widget.game))
                              : leaderBoard == LeaderBoardScreen.friendsList ? Flexible(child: MyFriendsList(game: widget.game))
                              : leaderBoard == LeaderBoardScreen.friendRequests ? Flexible(child: ReceivedFriendshipRequest(game: widget.game))
                              : const Center(child: Text('List of Users',style: TextStyle(color: Colors.white),),),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Column(
                      children: [Padding(
                          padding: const EdgeInsets.only(top: 15,bottom: 15,left: 10,right: 10),
                          child:
                          leaderBoard == LeaderBoardScreen.top20challenge ? const Text('TOP 20 challenge Friends',style: TextStyle(color: Colors.white,fontSize: 20),)
                              : leaderBoard == LeaderBoardScreen.top20stars ? const Text('TOP 20 Levels Friends',style: TextStyle(color: Colors.white,fontSize: 20),)
                              : leaderBoard == LeaderBoardScreen.friendsList ? const Text('Send request',style: TextStyle(color: Colors.white,fontSize: 20),)
                              : leaderBoard == LeaderBoardScreen.friendRequests ? const Text('My send requests',style: TextStyle(color: Colors.white,fontSize: 20),)
                              //: leaderBoard == LeaderBoardScreen.friendRequests ? const Text('Friends Requests',style: TextStyle(color: Colors.white,fontSize: 20),)
                              : const Text('TOP 20',style: TextStyle(color: Colors.white,fontSize: 20),)
                      ),],),
                    Expanded(
                      child: Column(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //leaderBoard == LeaderBoardScreen.top20 ? const Expanded(child: FetchData())
                          leaderBoard == LeaderBoardScreen.top20challenge ? Flexible(child: Top20challengeFriends(game: widget.game))
                              : leaderBoard == LeaderBoardScreen.top20stars ? Flexible(child: Top20LevelsFriends(game: widget.game))
                              : leaderBoard == LeaderBoardScreen.friendsList ? Flexible(child: SearchFriends(game: widget.game))
                              : leaderBoard == LeaderBoardScreen.friendRequests ? Flexible(child: SentFriendshipRequest(game: widget.game))
                              : const Center(child: Text('List of Users',style: TextStyle(color: Colors.white),),),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        FittedBox(fit: BoxFit.scaleDown,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(onPressed: () {setState(() {leaderBoard = LeaderBoardScreen.top20challenge;});}, icon: const FaIcon(FontAwesomeIcons.trophy),color: Colors.white,),
                                IconButton(onPressed: () {setState(() {leaderBoard = LeaderBoardScreen.top20stars;}); }, icon: const FaIcon(FontAwesomeIcons.rankingStar),color: Colors.white,),
                                IconButton(onPressed: () {setState(() {leaderBoard = LeaderBoardScreen.friendsList;});}, icon: const FaIcon(FontAwesomeIcons.userGroup),color: Colors.white,),
                                IconButton(onPressed: () {setState(() {leaderBoard = LeaderBoardScreen.friendRequests;});}, icon: const FaIcon(FontAwesomeIcons.handshakeSimple),color: Colors.white,),
                                IconButton(onPressed: () {setState(() {widget.game.overlays.remove('LeaderBoard');widget.game.overlays.add('MainMenu');});}, icon: const FaIcon(FontAwesomeIcons.x),color: Colors.white,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                   ],
                ),
              ),
            ),
          ),
        ), // TabBarView
      ), // DefaultTabController
    ); // MaterialApp
  }
}
