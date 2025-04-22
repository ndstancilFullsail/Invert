import 'dart:async';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:invert/Base%20Fuctions/chat.dart';
import 'package:invert/Base%20Fuctions/friends.dart';
import 'package:invert/Base%20Fuctions/voiceconnect.dart';
import 'package:invert/Pages/base_layout.dart';
import 'package:invert/Pages/discover.dart';
import 'package:toastification/toastification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invert/Firebase/firebasefunctions.dart';
import 'package:invert/main.dart';
import 'package:invert/Firebase/utils.dart';


class DMChatScreen extends StatefulWidget {
  final String senderusername; 
  final String receiverusername;
  // Required parameter

  const DMChatScreen({super.key, required this.senderusername, required this.receiverusername}); // Mark as required

  @override
  State<DMChatScreen> createState() => _DMChatScreenState();
}
class _DMChatScreenState extends State<DMChatScreen> {

  final FirebaseFunctions _databaseService = FirebaseFunctions();
  List<Map<String, dynamic>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  Timer? _timer;
  String? username = FirebaseAuth.instance.currentUser!.displayName;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String teamname = FirebaseFunctions().getTeamFromCollection(FirebaseAuth.instance.currentUser!.email.toString()).toString();

@override
  void initState() {
    super.initState();
    _fetchMessages();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => _fetchMessages()); // Poll messages every 2 seconds
  }

  void _fetchMessages() async {
    List<Map<String, dynamic>>? messages = await _databaseService.fetchDirectMessagesForSender(widget.senderusername, widget.receiverusername);
    if (mounted) {
      setState(() {
        _messages = messages;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    await _databaseService.sendDirectMessage(widget.senderusername, widget.receiverusername, _messageController.text.trim());
    _messageController.clear();
    _fetchMessages(); // Manually refresh messages
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop polling when screen is closed
    super.dispose();
  }

  Future<void> _handleLogout() async {
    try {
      await _auth.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          autoCloseDuration: const Duration(seconds: 5),
          title: const Text('Logout Successfully'),
          alignment: Alignment.bottomRight,
        );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: maincolor,
     appBar: AppBar(title: Text(widget.receiverusername)),
      body: BaseLayout(
        body: Row (
          children: <Widget> [
            //Team Members List
            Expanded(
              flex: 1,
              child:Card(
                elevation: 8,
                margin: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              child:Container(
                
                color: Color.fromARGB(255, 255, 255, 255),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Team Members', 
                      style: TextStyle(
                        fontSize: 24, 
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold),
                        ),
                    SizedBox(height: 20),
                    FutureBuilder(
                        future: FirebaseFunctions().fetchTeamMembersWithFields(teamname),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (snapshot.hasData) {
                              // Extract team members from the snapshot data
                              Map<String, List<Map<String, dynamic>>> teamDetails = snapshot.data as Map<String, List<Map<String, dynamic>>>;
                              
                              // Extract the list of team members (for example, from the first entry in the map)
                              List<Map<String, dynamic>> members = teamDetails.values.first;

                              return Expanded(
                                child: ListView.builder(
                                  itemCount: members.length,
                                  itemBuilder: (context, index) {
                                    // Get the username of each team member
                                    String username = members[index]['username'];
                                    String baseUserid = members[index]['email'];
                                    String userTokenPath = tokenPLACEHOLDER;
                                    
                                    getToken(username).then((value){
                                      userTokenPath = value;
                                    });

                                    return Friends(
                                      uiWidget: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: NetworkImage(userTokenPath),
                                          ),
                                          Text(username)
                                        ],
                                      ),
                                    ), userid: baseUserid);
            
          },
        ),
      );
    } else {
      return Center(child: Text('No team members found.'));
    }
  },
),
                  ],
                ),

              )

              )

            ),
            //Chat Messages
            Expanded(
  flex: 3,
  child: Column(
    children: <Widget>[
      Expanded(
        child: ListView.builder(
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            final message = _messages[index];
            bool isMe = message['sender'] == widget.senderusername;

            return Align(
               alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
  child: Container(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width * 0.7, // restrict width of the bubble
    ),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: isMe ? maincolor : maingray,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isMe ? 'You' : message['sender'] ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 5),
         Text(
            message['text'] ?? '',
            style: TextStyle(color: Colors.white),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        
      ],
    ),
  ),
);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.send, color: maincolor),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    ],
  ),
),
          //User Profile
          Expanded(
            flex: 1,
            child: Card(
              color: Color.fromARGB(255, 255, 255, 255),
              elevation: 8,
              margin: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            child: Column(

              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('placeholder.png'), // Replace with actual image URL
                ),
                SizedBox(height: 10),
                Text(
                  widget.receiverusername,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Badges',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'LeaderBoard',
                  style: TextStyle(fontSize: 18),
                ),
               
                





              ],
            ),
            ),
            )
          ],
        
        ),
      
      ),
   );
  }
}