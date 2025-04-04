import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invert/Firebase/firebasefunctions.dart';

class DMChatScreen extends StatefulWidget {
  final String senderusername; 
  final String receiverusername;// Required parameter

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

@override
  void initState() {
    super.initState();
    _fetchMessages();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => _fetchMessages()); // Poll messages every 2 seconds
  }

  void _fetchMessages() async {
    List<Map<String, dynamic>>? messages = await _databaseService.fetchDirectMessages(widget.senderusername, widget.receiverusername);
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(title: Text(widget.receiverusername)), // Use the receiver's username as the title
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