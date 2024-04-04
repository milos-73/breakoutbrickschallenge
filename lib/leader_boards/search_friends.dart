import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:initial_project/forge2d_game_world.dart';
import 'package:initial_project/services/hex_color.dart';
import 'package:initial_project/services/update_record.dart';

import '../overlays/leaderBoard.dart';
import '../overlays/searching_friend_text_field.dart';
import '../ui/dbTools.dart';

enum FriendIsExisting {
  noSearch,
  canceled,
  yes,
  no
}

class SearchFriends extends StatefulWidget {

  final BrickBreakGame game;
  SearchFriends({required this.game, Key? key}) : super(key: key);

  @override
  State<SearchFriends> createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {

  final DbTools dbTools = DbTools();

 String? userNameOfFriend;
 String? points;
 String? stars;
 String? userIdOfFriend;

  bool _isShow = true;

  String value = "";

 FriendIsExisting friendIsExisting = FriendIsExisting.noSearch;

  @override
  void initState() {
    print('userID: ${widget.game.keyID}');
    super.initState();
  }

  //Query dbRef = FirebaseDatabase.instance.ref().child('leaderboard').orderByChild('points').limitToLast(20);
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('leaderBoard');

  Future<void> requestFriendship({required Map friendDetails, String? userKey}) async {

    DatabaseReference friendReference = FirebaseDatabase.instance.ref().child('leaderboard/${friendDetails['keyId']}/ReceivedFriendshipRequests');
    DatabaseReference myReference = FirebaseDatabase.instance.ref().child('leaderboard/$userKey/SentFriendshipRequests');

    await myReference.update({
      friendDetails['keyId'].toString() : friendDetails['keyId'].toString()
    });

    await friendReference.update({
      userKey ?? '' : userKey ?? ''
    });

  }


  Widget listItem({required Map leaderBoard}) {
    return
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: HexColor('##72a7ff')),
                onPressed: (){setState(() {_isShow = true;});
                //Navigator.push(context, MaterialPageRoute(builder: (context) => SearchingFriend(game: widget.game)));
                widget.game.overlays.add('blackScreen');
                displayTextInputDialog(context: context);
                },icon:  FaIcon(FontAwesomeIcons.magnifyingGlass,color: HexColor('#1f180e'),size: 15,), label: const Text('Search for Friend'),),
              const SizedBox(height: 20,),
                     Visibility(
                       visible: _isShow,
                       child: Container(
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
                               GestureDetector(onTap: () {
                                 requestFriendship(friendDetails: leaderBoard, userKey: widget.game.keyID );
                                 setState(() {_isShow = !_isShow;});
                                 },

                              child: FaIcon(FontAwesomeIcons.solidPaperPlane,color: HexColor('#72a7ff'),size: 15,),
                             )],
                         ),
                       ],
                   ),
                  ],
                ),
              ),
                     )
          ],) );
     }

  Widget noSearch() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: HexColor('##72a7ff')),
              onPressed: (){
              widget.game.overlays.add('blackScreen');
              displayTextInputDialog(context: context);
            },icon:  FaIcon(FontAwesomeIcons.magnifyingGlass,color: HexColor('#1f180e'),size: 15,), label: Text('Search for Friend',style: TextStyle(color: HexColor('#524124')),),),
            const SizedBox(height: 20,),
            //const Center(child: Text('Please search for your friend',style: TextStyle(color: Colors.white),))
          ],) );
  }

  Widget notExisting() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             ElevatedButton.icon(
             style: ElevatedButton.styleFrom(backgroundColor: HexColor('##72a7ff')),
               onPressed: (){
              widget.game.overlays.add('blackScreen');
              displayTextInputDialog(context: context);
            },icon:  FaIcon(FontAwesomeIcons.magnifyingGlass,color: HexColor('#1f180e'),size: 15,), label: const Text('Search for Friend'),),
            const SizedBox(height: 20,),
            const Center(child: Text('The user name is not valid or user does not exists',style: TextStyle(color: Colors.white),))
          ],) );
  }

  Widget canceled() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: HexColor('##72a7ff')),
              onPressed: (){
                widget.game.overlays.add('blackScreen');
                displayTextInputDialog(context: context);
              },icon:  FaIcon(FontAwesomeIcons.magnifyingGlass,color: HexColor('#1f180e'),size: 15,), label: const Text('Search for Friend'),),
            // const SizedBox(height: 20,),
            // const Center(child: Text('',style: TextStyle(color: Colors.white),))
          ],) );
  }

  @override

  Widget build(BuildContext context) {

   if (friendIsExisting == FriendIsExisting.yes) {

    Query friends = FirebaseDatabase.instance.ref().child('leaderboard').orderByChild('userName').equalTo(userNameOfFriend).limitToFirst(1);

    return FirebaseAnimatedList(shrinkWrap: true, reverse: true,
      query: friends,
      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

        Map leaderBoard = snapshot.value as Map;
        leaderBoard['key'] = snapshot.key;

       return listItem(leaderBoard: leaderBoard);});}

        if (friendIsExisting == FriendIsExisting.no) {
          return notExisting();
        }
        if (friendIsExisting == FriendIsExisting.canceled) {
     return canceled();
   }
        else {
          return noSearch();
        }
     }


  Future<void> addFriend({required Map friendDetails, String? userKey}) async {

    DatabaseReference friendReference = FirebaseDatabase.instance.ref().child('leaderboard/$userKey/friends');
    DatabaseReference myReference = FirebaseDatabase.instance.ref().child('leaderboard/${friendDetails['keyId']}/friends');

    await friendReference.update({
      friendDetails['keyId'].toString() : friendDetails['keyId'].toString()
      });

   await myReference.update({
   userKey ?? '' : userKey ?? ''
});

  }

  Future<void> displayTextInputDialog({required BuildContext context}) async {
    final TextEditingController textFieldController = TextEditingController();

    String? codeDialog;
    String? valueText;
    //String? customProfileName = ;

    return showDialog(
        barrierDismissible: false, barrierColor: Colors.black,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: HexColor('#ffdfab').withOpacity(0.9),
            title: const Row(
              children: [
                FaIcon(FontAwesomeIcons.magnifyingGlass,size: 15),
                SizedBox(width: 5,),
                Text('Search your friend'),
              ],
            ),
            content: TextField(
              onChanged: (value) => userNameOfFriend = value,
              onSubmitted: (value) async {


                if(await dbTools.checkUserName(userNameOfFriend!) == false){
                  setState(() {friendIsExisting = FriendIsExisting.no;});
                  widget.game.overlays.remove('blackScreen');
                  if (context.mounted){
                  Navigator.pop(context);}
                }else{
                  friendIsExisting = FriendIsExisting.yes;
                  widget.game.overlays.remove('blackScreen');
                  if (context.mounted){
                    Navigator.pop(context);}
                }
                            },
              controller: textFieldController,
              decoration:
              InputDecoration(hintText: 'Write the exact user name', filled: true,fillColor: HexColor('#fef8d0')),
            ),
            actions: <Widget>[
              MaterialButton(
                color: HexColor('#8bd6f5'),
                textColor: Colors.white,
                child: Text('CANCEL',style: TextStyle(color: HexColor('#1c2b31'),fontWeight: FontWeight.w500),),
                onPressed: () {
                  friendIsExisting = FriendIsExisting.canceled;
                  widget.game.overlays.remove('blackScreen');
                  print('userNameOfFriend: $userNameOfFriend');
                  if (context.mounted){
                    Navigator.pop(context);}
                },
              ),
              MaterialButton(
                  color: HexColor('#8bf5aa'),
                  textColor: Colors.white,
                  child: Text('OK',style: TextStyle(color: HexColor('#1c2b31'),fontWeight: FontWeight.w500),),
                  onPressed: () async {
                    if(await dbTools.checkUserName(userNameOfFriend!) == false){
                      setState(() {
                        friendIsExisting = FriendIsExisting.no;});
                      widget.game.overlays.remove('blackScreen');
                      if (context.mounted){
                        Navigator.pop(context);}
                    }else{
                      friendIsExisting = FriendIsExisting.yes;
                      widget.game.overlays.remove('blackScreen');
                      if (context.mounted){
                        Navigator.pop(context);}
                    }
                   })
            ],
          );
        });
  }
}