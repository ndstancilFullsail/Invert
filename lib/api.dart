import 'dart:convert';
import 'package:http/http.dart' as http;


String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiJmNWE5Mzc5ZC04MjFjLTQ5NGYtYjk5OS0xNmFjM2YxOWEwODEiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTczNzM5NjUzOSwiZXhwIjoxNzM4MDAxMzM5fQ.qZQos_Z-3Mc_F-cULXW_H4MyLRfH5HguI3Iuxhya304";


Future<String> createMeeting() async {
  final http.Response httpResponse = await http.post(
    Uri.parse("https://api.videosdk.live/v2/rooms"),
    headers: {'Authorization': token},
  );


  return json.decode(httpResponse.body)['roomId'];
}