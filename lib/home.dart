import 'package:flutter/material.dart';
import 'package:invert/voiceconnect.dart';
import 'base_layout.dart';
import 'package:invert/firebasefunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:videosdk/videosdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'chat.dart';
import 'discover.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  final String team;

  const HomeScreen({super.key, required this.team});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String token;
  late String meetingIds;
  late Room _channel;
  late String userName;
  bool connected = false;
  bool micphEnable = true;
  var database = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase realdatabase = FirebaseDatabase.instance;
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions();

  void getMeetingInfo() async {
    var datab = FirebaseFirestore.instance.collection('VoiceInfo').doc('Info');
    await datab.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        token = data['token'];
        meetingIds = data['meetingId'];
      },
      onError: (e) => print("Error completing: $e"),
    );

    var database = FirebaseFirestore.instance.collection('users').doc('eimBKOW0O3Vl0AnViRfw');
    await database.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        userName = data['Username'];
      }
    );
  }

  void onJoinButtonPressed(String nameofChannel) {
    _channel = VideoSDK.createRoom(
      roomId: meetingIds,
      displayName: nameofChannel,
      token: token,
      camEnabled: false,
      micEnabled: micphEnable,
    );
    setRoomEvents();
    _channel.join();
  }

  void joinRoom() async {
    var db = FirebaseFirestore.instance.collection('Teams').doc('Champions').collection('VoiceCH1').doc('eimBKOW0O3Vl0AnViRfw');
    await db.set({
      "Username": userName
    }, SetOptions(merge: true));
  }

  void leaveRoom() async {
    var db = FirebaseFirestore.instance.collection('Teams').doc('Champions').collection('VoiceCH1');
    await db.doc('eimBKOW0O3Vl0AnViRfw').delete();
  }

  @override
  void initState() {
    super.initState();
    getMeetingInfo();

    if (widget.team == 'The Explorers') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DiscoverPage(),
          ),
        );
      });
    }
  }

  void setRoomEvents() {
    _channel.on(Events.roomJoined, () {
      joinRoom();
    });

    _channel.on(Events.roomLeft, () {
      leaveRoom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Discover'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiscoverPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                print('Logout button tapped');
                try {
                  print('Attempting to sign out...');
                  await _firebaseFunctions.signOut();
                  print('Sign out successful, navigating to login');
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  print('Error during sign out: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Logout failed. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: BaseLayout(
        body: Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(16),
                child: ChatPage(),
              ),
            ),
            Container(
              width: 300,
              color: Colors.blue[100],
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
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
                          onTap: () {
                            onJoinButtonPressed('Voice Channel 1');
                            setState(() {
                              connected = true;
                            });
                          },
                        ),
                        ParticipantToken(),
                        ListTile(title: Text('Voice Channel 2')),
                        ListTile(title: Text('Voice Channel 3')),
                        ListTile(title: Text('Voice Channel 4')),
                        ListTile(title: Text('Voice Channel 5')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                micphEnable ? _channel.muteMic() : _channel.unmuteMic();
                                micphEnable = !micphEnable;
                              },
                              icon: Icon(Icons.mic)
                            ),
                            LeaveButton(
                              connect: connected,
                              icon: Text('Leave'),
                              onPressed: () {
                                _channel.leave();
                                setState(() {
                                  connected = false;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            print('Logout button pressed');
                            try {
                              print('Attempting to sign out...');
                              await _firebaseFunctions.signOut();
                              print('Sign out successful, navigating to login');
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login',
                                (Route<dynamic> route) => false,
                              );
                            } catch (e) {
                              print('Error during sign out: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Logout failed. Please try again.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: Size(double.infinity, 40),
                          ),
                          child: Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
