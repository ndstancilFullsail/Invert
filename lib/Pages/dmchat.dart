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
      appBar: AppBar(
        title: Text('${widget.senderusername} - ${widget.receiverusername}'),
      ),
      body: Center(
        child: Text('Chat between ${widget.senderusername} and ${widget.receiverusername}'),

      ),
    );
  }
}