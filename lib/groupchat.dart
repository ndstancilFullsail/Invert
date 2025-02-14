import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GroupchatScreen extends StatefulWidget {
  const GroupchatScreen({super.key});

  @override
  State<GroupchatScreen> createState() => _GroupchatScreenState();
}


class _GroupchatScreenState extends State<GroupchatScreen> {

    TextEditingController messageController = TextEditingController();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseDatabase database = FirebaseDatabase.instance;



    void sendMessage() async {
      String message = messageController.text.trim();
      if (message.isNotEmpty) {
        await firestore.collection('groupchat').add({
          'message': message,
          'timestamp': DateTime.now(),
          'sender': FirebaseAuth.instance.currentUser!.displayName,
        });
        messageController.clear();
      }
    }



  
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('group_chats')
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final docs = snapshot.data?.docs ?? [];
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      title: Text(docs[index]['message']),
                      subtitle: Text('Sender: ${docs[index]['sender']}'),
                      trailing: Text(
                        DateTime.parse(docs[index]['createdAt'].toDate().toString()).toString(),
                      ),
                    );
                  },
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
                    controller: messageController,
                    decoration: InputDecoration(hintText: 'Enter your message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}