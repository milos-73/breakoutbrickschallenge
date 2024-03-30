import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/hex_color.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  Future<void>? _launched;

  final Uri _url = Uri.parse('https://mylocationnow.app');
  final Uri _url2 = Uri.parse('https://mylocationnow.app/privacy-policy');
  final Uri _url3 = Uri.parse('mailto:support@mylocationnow.app');

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
          Icon(FontAwesomeIcons.locationDot, size: 50, color: HexColor('#3B592D'),),
          SizedBox(height: 20,),
          Text('My Location Now'.toUpperCase(), style: TextStyle(fontSize: 27,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
          Text('Find, Send & Save', style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),),
          //Text('my current location', style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),),
          SizedBox(height: 5,),
          Text('verzia 1.2.8', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
          SizedBox(height: 20,),
          TextButton(onPressed: () => setState(() {_launched = _launchInBrowser(_url);}), child: const Text('mylocationnow.app'),style: TextButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero,tapTargetSize: MaterialTapTargetSize.shrinkWrap ),),
          Text('support@mylocationnow.app', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
          TextButton(onPressed: () => setState(() {_launched = _launchInBrowser(_url2);}), child: const Text('Privacy Policy'),style: TextButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero,tapTargetSize: MaterialTapTargetSize.shrinkWrap ),),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 2),
            child: Text('Development', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
          ),
          Text('Miloš Sálus', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
          Text('Pivo SALUS s.r.o.', style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400),),
          SizedBox(height: 15,),
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [FaIcon(FontAwesomeIcons.envelope, size: 20,),
                SizedBox(width: 8,),
                TextButton(onPressed: () => setState(() {_launched = _launchInBrowser(_url3);}), child: const Text('Report an issue', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),style: TextButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero,tapTargetSize: MaterialTapTargetSize.shrinkWrap ),),
              ],
            ),
          ),

        ],)
    );
  }
}
