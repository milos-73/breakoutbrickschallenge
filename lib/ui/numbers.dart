import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/saved_values.dart';

class Numbers extends StatefulWidget {

  final int number;

  const Numbers({Key? key, required this.number}) : super(key: key);

  @override
  State<Numbers> createState() => _NumbersState();
}

class _NumbersState extends State<Numbers> {

  SavedValues savedValues = SavedValues();
  String number1 = '';
  String number2 = '';

 Future <String?> getNumber1(int index) async {
   int letterCount = index.toString().length ;
   if (letterCount > 0){
     String number = index.toString()[0];
     return number;
   }else{String number = '-';
     return number; }
    }

  Future <String?> getNumber2(int index) async{
    int letterCount = index.toString().length ;
    if (letterCount > 0){
      String number = index.toString()[1];
      return number;
    }else{String number = '-';
    return number; }
  }


  @override
  void initState(){
    if (widget.number.toString().length == 1){getNumber1(widget.number).then((value) => setState((){number1 = value!;}));}
    if (widget.number.toString().length == 2){ getNumber1(widget.number).then((value) => setState((){number1 = value!;}));
    getNumber2(widget.number).then((value) => setState((){number2 = value!;}));}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double brickWidth = (MediaQuery.of(context).size.width /4)-25;
    double brickHeight = MediaQuery.of(context).size.width /8;


    return InkWell(onTap: () async {

      }, child: Padding(
      padding: const EdgeInsets.only(left: 4,right: 4,top: 10),
      child: Container(alignment: AlignmentDirectional.topCenter, width: brickWidth,
        child: Stack(

            children: [
              Image.asset('assets/images/levels/emptyBrick1.png',fit: BoxFit.cover),
              Positioned(left:brickWidth*0.23, top: brickHeight*0.05,height: MediaQuery.of(context).size.width /10,width: 28, child: Image.asset('assets/images/levels/$number1.png')),
              //Positioned(left: brickWidth*0.55,top: brickHeight *0.1,child: SizedBox(height: MediaQuery.of(context).size.width /10,width: 28, child: Image.asset('assets/images/levels/2.png'),)),
              Positioned(left: brickWidth*0.55,top:brickHeight*0.05, height: MediaQuery.of(context).size.width /10,width: 28, child: Image.asset('assets/images/levels/$number2.png')),
              //const Positioned(top:0, left: 0, child: FaIcon(FontAwesomeIcons.circle, color: Colors.yellow,size: 10,)),
              //Positioned(top:0, left: brickWidth, child: FaIcon(FontAwesomeIcons.circle, color: Colors.yellow,size: 10,))
            ]
        ),
      ),
    ));

     }
}
