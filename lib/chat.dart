import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invert/firebasefunctions.dart';


class ChatPage extends StatefulWidget {

  final String teamname;

  const ChatPage({super.key, required this.teamname});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  
  final FirebaseFunctions _databaseService = FirebaseFunctions();
  List<Map<String, dynamic>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  Timer? _timer;
  String? username = FirebaseAuth.instance.currentUser!.displayName;
  

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => _fetchMessages()); // Poll messages every 2 seconds
  }

  void _fetchMessages() async {
    List<Map<String, dynamic>>? messages = await _databaseService.fetchMessages(widget.teamname);
    if (mounted) {
      setState(() {
        _messages = messages;
      });
    }
  }

  Future<void> _sendMessage() async {
  

    if (_messageController.text.trim().isEmpty) return;
    await _databaseService.sendMessage(widget.teamname, username! , _messageController.text.trim());
    _messageController.clear();
    _fetchMessages(); // Manually refresh messages
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop polling when screen is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text("Team Chat: ${widget.teamname}")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                bool isMe = message["sender"] == username;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isMe ? "You" : message["sender"],
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 5),
                        Text(
                          message["text"],
                          style: TextStyle(color: Colors.white),
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
                      hintText: "Type a message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
