import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  var db = FirebaseFirestore.instance.collection("VoiceInfo").doc("Info");
  
  await db.set({'token':token});

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





