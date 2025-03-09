import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


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
  List<String> internalUsers = [];

  void resolveToken(List<String> external)
  {

        bool same = ListEquality().equals(internalUsers, external);

        if(!same)
        {
          List<Widget> temp = [];

          for(var item in external)
          {
            temp.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item),
                  ],
                )
            );
          }
            internalUsers = List.from(external);
            userTokens = List.from(temp);
        }
  }



  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('Teams').doc('Champions').collection('VoiceCH1').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    
        if(snapshot.hasError)
        {
            return const Text('Something went wrong');
        }
        if(snapshot.connectionState == ConnectionState.waiting)
        {
          return const Text("Loading");
        }
        if (!snapshot.hasData || !snapshot.data!.docs.isNotEmpty) {
           return const Text("No users found"); //Sizebox(0,0)
        }

        List<String> firebaseUsers = [];
        
        for (var document in snapshot.data!.docs) {

          var data = document.data() as Map<String, dynamic>;
          firebaseUsers.add(data["Username"]);

        }
      
        resolveToken(firebaseUsers);  



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

