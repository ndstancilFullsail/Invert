import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';
import 'meetingScreen.dart';
import 'api.dart';


String token12 = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiJmNWE5Mzc5ZC04MjFjLTQ5NGYtYjk5OS0xNmFjM2YxOWEwODEiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTczNzM5NjUzOSwiZXhwIjoxNzM4MDAxMzM5fQ.qZQos_Z-3Mc_F-cULXW_H4MyLRfH5HguI3Iuxhya304";



class JoinScreen extends StatefulWidget{
  JoinScreen({super.key});

  final _meetingIdController = TextEditingController();


  @override
  State<JoinScreen> createState() => _JoinScreen();

}

class _JoinScreen extends State<JoinScreen> {


void onCreateButtonPressed(BuildContext context) async {
    await createMeeting().then((meetingId) {
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => StartScreen(
            meetingId: meetingId,
            token: token,
          ),
        ),
      );
    });
  }


  void onJoinButtonPressed(BuildContext context) {
    String meetingId = widget._meetingIdController.text;
    var re = RegExp("\\w{4}\\-\\w{4}\\-\\w{4}");
    if (meetingId.isNotEmpty && re.hasMatch(meetingId)) {
      widget._meetingIdController.clear();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => StartScreen(
            meetingId: meetingId,
            token: token,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter valid meeting id"),
      ));
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 30,
              width: 200,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Meeting Id',
                  border: OutlineInputBorder(),
                ),
                controller: widget._meetingIdController,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () {
                  onCreateButtonPressed(context);
                }, 
                child: Text('Host Session')),
                SizedBox(width: 50),
                ElevatedButton(onPressed: () {
                  onJoinButtonPressed(context);
                }, 
                child: Text('Join Session'))
      
              ],
            )
      
          ],
        )
      ),
    );
}



}