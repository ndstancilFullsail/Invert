import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;


var videoSdkAPIKey = "f5a9379d-821c-494f-b999-16ac3f19a081";
var videoSecretKey = "1101fb1d41d6d9f2d6af7d43b744d9acf728b97275861e331d2ff92b98fa4944";
var tokenPLACEHOLDER = 'https://firebasestorage.googleapis.com/v0/b/nvert-1ec6c.firebasestorage.app/o/placeholder.png?alt=media&token=38f352fe-73f2-49a7-92de-6f50af58bd7c';

class VoiceStart{
  String token = '';

void setInfo() async{
  var expirationDelta = 30; 
  int expirition  = DateTime.now().add(Duration(days: expirationDelta)).microsecondsSinceEpoch;

  var jwt = JWT({
    "exp": expirition,
    "apikey": videoSdkAPIKey,
	  "permissions": ['allow_join'],
});

  var token = jwt.sign(SecretKey(videoSecretKey),algorithm: JWTAlgorithm.HS256);

  var db = FirebaseFirestore.instance.collection("Teams").doc("The Thinkers").collection('VoiceInfo').doc('Info');
  
  await db.set({'token':token},SetOptions(merge: true));

    if(token != '')
    {
      
      for(int i = 0; i < 5;i++)
      {
        final http.Response httpResponse = await http.post(
          Uri.parse("https://api.videosdk.live/v2/rooms"),
          headers: {'Authorization': token},
        );

        var meetingid = json.decode(httpResponse.body)['roomId'];

        await db.set({'meetingId$i':meetingid},SetOptions(merge: true));
      }
      
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
  final String channel;
  final String team;
  const ParticipantToken({super.key, required this.channel, required this.team});

  @override
  State<ParticipantToken> createState() => _ParticipantTokenState();
}

class _ParticipantTokenState extends State<ParticipantToken> {


  List<Widget> userTokens = [];
  List<String> internalUsers = [];

  Future<String> resolveTokenPicture(String path) async{

    try{
      String download = await FirebaseStorage.instance
        .ref(path)
        .getDownloadURL();
        return download;
    }
    catch(e)
    {
        debugPrint('$e');
        return '';
    }
  }

  void resolveToken(List<String> external)
  {

        bool same = ListEquality().equals(internalUsers, external);

        if(!same)
        {
          List<Widget> temp = [];

          for(var item in external)
          {
            String tempPic = '';
            resolveTokenPicture('$item/$item.png').then((value){
              tempPic = value;
            });

            if(tempPic.isEmpty)
            {
              tempPic = tokenPLACEHOLDER;
            }

            temp.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(tempPic),
                        backgroundColor: Colors.transparent,
                        ),
                    ),
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
    stream: FirebaseFirestore.instance.collection('Teams').doc(widget.team).collection(widget.channel).snapshots(),
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
           return const SizedBox(width: 0,height: 0,);
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

