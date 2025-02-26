import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:videosdk/videosdk.dart';
import 'package:firebase_database/firebase_database.dart';


var videoSdkAPIKey = "f5a9379d-821c-494f-b999-16ac3f19a081";
var videoSecretKey = "1101fb1d41d6d9f2d6af7d43b744d9acf728b97275861e331d2ff92b98fa4944";

class VoiceStart{
  String token = '';

void setInfo() async{
  var expirationDelta = 5; 
  int expirition  = DateTime.now().add(Duration(days: expirationDelta)).microsecondsSinceEpoch;

  var jwt = JWT({
    "exp": expirition,
    "apikey": videoSdkAPIKey,
	  "permissions": ['allow_join'],
});

  var token = jwt.sign(SecretKey(videoSecretKey),algorithm: JWTAlgorithm.HS256);

  var db = FirebaseFirestore.instance.collection("Teams").doc("Champions");
  
  await db.set({'token':token},SetOptions(merge: true));

    if(token != '')
    {
      final http.Response httpResponse = await http.post(
        Uri.parse("https://api.videosdk.live/v2/rooms"),
        headers: {'Authorization': token},
      );

      var meetingid = json.decode(httpResponse.body)['roomId'];

      await db.set({'meetingId':meetingid},SetOptions(merge: true));
    }

  }

}

class LeaveButton extends IconButton
{
  final bool connect;
  
  const LeaveButton({super.key,required this.connect, required super.onPressed, required super.icon});
  

  @override
  Widget build(BuildContext context) {

    Widget test = SizedBox();

    if(connect)
    {
      test = IconButton(
      onPressed: super.onPressed, 
      icon: super.icon);
    }

    return test;
  }
}

class ParticipantToken extends StatefulWidget
{
  const ParticipantToken({super.key});

  @override
  State<ParticipantToken> createState() => _ParticipantTokenState();
}

class _ParticipantTokenState extends State<ParticipantToken> {


  List<Widget> userTokens = [];

  void addToken(String data){
    setState(() {
      userTokens.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data),
          ],
        )
      );
    });
  }

  void getTokeninfo() async{

    var db = FirebaseFirestore.instance.collection('Teams').doc('Champions').collection('VoiceCH1');

    await db.get().then((onValue) {

        for(var docu in onValue.docs)
        {
          final data = docu.data();
          addToken(data['Username']);
        }
    }, onError: (e) {
      throw e;
    });


  }

  @override
  Widget build(BuildContext context) {


    return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('Teams').doc('Champions').collection('VoiceCh1').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    
        if(snapshot.hasError)
        {
            return const Text('Something went wrong');
        }
        if(snapshot.connectionState == ConnectionState.waiting)
        {
          return const Text("Loading");
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
           return const Text("No users found");
        }
    
        // snapshot.data!.docs.map((DocumentSnapshot document) {
        //         var data = document.data()! as Map<String, dynamic>;
        //         print(data['Username']);
        //         addToken(data['Username']);
        //       });

        //getTokeninfo();


        return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: userTokens
            ),
          );
        },
      );

  }
}

