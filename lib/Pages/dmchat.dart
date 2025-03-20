import 'package:flutter/material.dart';
import 'base_layout.dart';

class DMChatScreen extends StatefulWidget {
  final String senderusername; 
  final String receiverusername;// Required parameter

  const DMChatScreen({super.key, required this.senderusername, required this.receiverusername}); // Mark as required

  @override
  State<DMChatScreen> createState() => _DMChatScreenState();
}
class _DMChatScreenState extends State<DMChatScreen> {
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