import 'package:flutter/material.dart';
import 'package:invert/voiceconnect.dart';
import 'base_layout.dart';
import 'package:invert/firebasefunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:videosdk/videosdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat.dart';
import 'discover.dart';

class HomeScreen extends StatefulWidget {
  final String teamname; // Required parameter

  const HomeScreen({super.key, required this.teamname}); // Mark as required

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String token;
  late String meetingId;
  late Room _channel;
  late String userName;
  bool connected = false;
  bool micEnabled = true;
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchMeetingInfo();
    _fetchUserName();
    _checkTeamAndNavigate();
  }

  // Fetch meeting info from Firestore
  Future<void> _fetchMeetingInfo() async {
    try {
      final doc = await _firestore.collection('VoiceInfo').doc('Info').get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          token = data['token'];
          meetingId = data['meetingId'];
        });
      } else {
        print('VoiceInfo document does not exist');
      }
    } catch (e) {
      print('Error fetching meeting info: $e');
    }
  }

  // Fetch username from Firestore
  Future<void> _fetchUserName() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          setState(() {
            userName = doc.get('Username') as String;
          });
        }
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
  }

  // Check if the team is 'The Explorers' and navigate to DiscoverPage
  void _checkTeamAndNavigate() {
    if (widget.teamname == 'The Explorers') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DiscoverPage(teamname: widget.teamname), // Pass teamname
          ),
        );
      });
    }
  }

  // Join a voice channel
  void _joinVoiceChannel(String channelName) {
    _channel = VideoSDK.createRoom(
      roomId: meetingId,
      displayName: channelName,
      token: token,
      camEnabled: false,
      micEnabled: micEnabled,
    );
    _setRoomEvents();
    _channel.join();
    setState(() {
      connected = true;
    });
  }

  // Set up room event listeners
  void _setRoomEvents() {
    _channel.on(Events.roomJoined, () {
      _addUserToVoiceChannel();
    });

    _channel.on(Events.roomLeft, () {
      _removeUserFromVoiceChannel();
    });
  }

  // Add user to Firestore voice channel
  Future<void> _addUserToVoiceChannel() async {
    try {
      final userId = _auth.currentUser!.uid;
      await _firestore
          .collection('Teams')
          .doc(widget.teamname) // Use widget.teamname
          .collection('VoiceCH1')
          .doc(userId)
          .set({
        "Username": userName,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error adding user to voice channel: $e');
    }
  }

  // Remove user from Firestore voice channel
  Future<void> _removeUserFromVoiceChannel() async {
    try {
      final userId = _auth.currentUser!.uid;
      await _firestore
          .collection('Teams')
          .doc(widget.teamname) // Use widget.teamname
          .collection('VoiceCH1')
          .doc(userId)
          .delete();
    } catch (e) {
      print('Error removing user from voice channel: $e');
    }
  }

  // Toggle microphone state
  void _toggleMicrophone() {
    if (micEnabled) {
      _channel.muteMic();
    } else {
      _channel.unmuteMic();
    }
    setState(() {
      micEnabled = !micEnabled;
    });
  }

  // Leave the voice channel
  void _leaveVoiceChannel() {
    _channel.leave();
    setState(() {
      connected = false;
    });
  }

  // Handle logout
  Future<void> _handleLogout() async {
    try {
      await _firebaseFunctions.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (Route<dynamic> route) => false,
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
                    builder: (context) => DiscoverPage(teamname: widget.teamname), // Pass teamname
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: _handleLogout,
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
                child: ChatPage(teamname: widget.teamname),
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
                          onTap: () => _joinVoiceChannel('Voice Channel 1'),
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
                              onPressed: _toggleMicrophone,
                              icon: Icon(micEnabled ? Icons.mic : Icons.mic_off),
                            ),
                            LeaveButton(
                              connect: connected,
                              icon: Text('Leave'),
                              onPressed: _leaveVoiceChannel,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _handleLogout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: Size(double.infinity, 40),
                          ),
                          child: Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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