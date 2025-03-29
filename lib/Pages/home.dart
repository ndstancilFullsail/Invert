import 'package:flutter/material.dart';
import 'package:invert/main.dart';
import 'package:invert/Base%20Fuctions/voiceconnect.dart';
import 'base_layout.dart';
import 'package:invert/Firebase/firebasefunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:videosdk/videosdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Base Fuctions/chat.dart';
import 'discover.dart';
import 'dmchat.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  final String teamname; // Required parameter

  const HomeScreen({super.key, required this.teamname}); // Mark as required

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String token;
  List<String> meetingIds = [];
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
    //VoiceStart().setInfo(); //Only used for settings all of videoSDK config
  }

  // Fetch meeting info from Firestore
  Future<void> _fetchMeetingInfo() async {
    try {
      final doc = await _firestore.collection('Teams').doc(widget.teamname).collection('VoiceInfo').doc('Info').get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        List<String> temp = [];
        for(int i = 0; i < 5; i++)
        {
          temp.add(data['meetingId$i']);
        }

        setState(() {
          token = data['token'];
          meetingIds = List.from(temp);
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
        final doc = await _firestore.collection('users').doc(user.email).get();
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
  void _joinVoiceChannel(String channelName,String channelId) {
    _channel = VideoSDK.createRoom(
      roomId: channelId,
      displayName: channelName,
      token: token,
      camEnabled: false,
      micEnabled: micEnabled,
    );
    _setRoomEvents(channelName);
    _channel.join();
    setState(() {
      connected = true;
    });
  }

  // Set up room event listeners
  void _setRoomEvents(String channelName) {
    _channel.on(Events.roomJoined, () {
      _addUserToVoiceChannel(channelName);
    });

    _channel.on(Events.roomLeft, () {
      _removeUserFromVoiceChannel(channelName);
    });
  }

  // Add user to Firestore voice channel
  Future<void> _addUserToVoiceChannel(String channelName) async {
    try {
      final userId = _auth.currentUser!.uid;
      await _firestore
          .collection('Teams')
          .doc(widget.teamname) // Use widget.teamname
          .collection(channelName)
          .doc(userId)
          .set({
        "Username": userName,
      },SetOptions(merge: true));
    } catch (e) {
      print('Error adding user to voice channel: $e');
    }
  }

  // Remove user from Firestore voice channel
  Future<void> _removeUserFromVoiceChannel(String channelName) async {
    try {
      final userId = _auth.currentUser!.uid;
      await _firestore
          .collection('Teams')
          .doc(widget.teamname) // Use widget.teamname
          .collection(channelName)
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
                color: Color.fromARGB(255,246, 241, 241),
                padding: const EdgeInsets.all(16),
                child: ChatPage(teamname: widget.teamname),
              ),
            ),
            Container(
              width: 300,
              color: Color.fromARGB(255,246, 241, 241),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget> [
                  Card(color: Color.fromARGB(255, 217, 217, 217), child: SizedBox(height:300, child: Column(
                    
                    children: <Widget>[
                      Text('Team Members', 
                      style: TextStyle(
                        fontSize: 24, 
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        FutureBuilder(
  future: FirebaseFunctions().fetchTeamMembersWithFields(widget.teamname),
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

            return ListTile(
              title: Text(username),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DMChatScreen(
                    senderusername: userName,
                    receiverusername: username,
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Center(child: Text('No team members found.'));
    }
  },
),
                    ],
                  ))),
                  
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
                          onTap: () => _joinVoiceChannel('Voice Channel 1',meetingIds[0]),
                        ),
                        ParticipantToken(team: widget.teamname,channel: 'Voice Channel 1',),
                        ListTile(
                          title: Text('Voice Channel 2'),
                          onTap: () => _joinVoiceChannel('Voice Channel 2',meetingIds[1]),
                        ),
                        ParticipantToken(team: widget.teamname,channel: 'Voice Channel 2',),
                        ListTile(
                          title: Text('Voice Channel 3'),
                          onTap: () => _joinVoiceChannel('Voice Channel 3',meetingIds[2]),
                        ),
                         ParticipantToken(team: widget.teamname,channel: 'Voice Channel 3',),
                        ListTile(
                          title: Text('Voice Channel 4'),
                          onTap: () => _joinVoiceChannel('Voice Channel 4',meetingIds[3]),
                          ),
                           ParticipantToken(team: widget.teamname,channel: 'Voice Channel 4',),
                        ListTile(
                          title: Text('Voice Channel 5'),
                          onTap: () => _joinVoiceChannel('Voice Channel 5',meetingIds[4]),
                          ),
                           ParticipantToken(team: widget.teamname,channel: 'Voice Channel 5',),
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