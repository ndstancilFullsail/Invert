import 'package:flutter/material.dart';
import 'base_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:videosdk/videosdk.dart';

class HomeScreen extends StatefulWidget {
  final String team; // Add team parameter

  const HomeScreen({super.key, required this.team}); // Update constructor

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String token;
  late String meetingIds;
  late Room _channel;

  var datebase = FirebaseFirestore.instance;

  void getMeetingInfo() async {
    var db = FirebaseFirestore.instance.collection('VoiceInfo').doc('Info');
    await db.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        token = data['token'];
        meetingIds = data['meetingId'];
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  void onJoinButtonPressed(String nameofChannel) {
    _channel = VideoSDK.createRoom(
      roomId: meetingIds,
      displayName: nameofChannel,
      token: token,
      camEnabled: false,
      micEnabled: true,
    );

    _channel.join();
  }

  @override
  void initState() {
    super.initState();
    getMeetingInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      body: Row(
        children: [
          // Chat Section
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to ${widget.team}!', // Display the team name
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Chat Section',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right-side for Channels
          Container(
            width: 300, // Width for the channels section
            color: Colors.blue[100],
            padding: const EdgeInsets.all(16), // Padding
            child: Column(
              children: [
                // Text Channels Section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Text Channels',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(title: Text('# Text Channel 1')),
                      ListTile(title: Text('# Text Channel 2')),
                      ListTile(title: Text('# Text Channel 3')),
                      ListTile(title: Text('# Text Channel 4')),
                      ListTile(title: Text('# Text Channel 5')),
                      ListTile(title: Text('# Text Channel 6')),
                    ],
                  ),
                ),
                // Voice Channels Section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Voice Channels',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text('Voice Channel 1'),
                        leading: Icon(Icons.mic),
                        onTap: () {
                          onJoinButtonPressed('Voice Channel 1');
                        },
                      ),
                      ListTile(
                        title: Text('Voice Channel 2'),
                        leading: Icon(Icons.mic),
                      ),
                      ListTile(
                        title: Text('Voice Channel 3'),
                        leading: Icon(Icons.mic),
                      ),
                      ListTile(
                        title: Text('Voice Channel 4'),
                        leading: Icon(Icons.mic),
                      ),
                      ListTile(
                        title: Text('Voice Channel 5'),
                        leading: Icon(Icons.mic),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(team: 'Default Team'),
  ));
}