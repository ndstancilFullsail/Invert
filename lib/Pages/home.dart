import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:invert/Base%20Fuctions/friends.dart';
import 'package:invert/Firebase/utils.dart';
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
  final String teamname;
  const HomeScreen({super.key, required this.teamname});

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
  late Future<Map<String, List<Map<String, dynamic>>>> teammemberFuture;

  @override
  void initState() {
    super.initState();
    _fetchMeetingInfo();
    _fetchUserName();
    _checkTeamAndNavigate();
    teammemberFuture = _firebaseFunctions.fetchTeamMembersWithFields(widget.teamname);
    _checkTeamAndNavigate();
  }

  Future<void> _fetchMeetingInfo() async {
    try {
      final doc = await _firestore
          .collection('Teams')
          .doc(widget.teamname)
          .collection('VoiceInfo')
          .doc('Info')
          .get();
      if (doc.exists && mounted) {
        final data = doc.data()!;
        List<String> temp = [
          data['meetingId0'],
          data['meetingId1'],
          data['meetingId2'],
          data['meetingId3'],
          data['meetingId4'],
        ];
        setState(() {
          token = data['token'];
          meetingIds = temp;
        });
      }
    } catch (e) {
      print('Error fetching meeting info: $e');
    }
  }

  Future<void> _fetchUserName() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.email).get();
        if (doc.exists && mounted) {
          setState(() {
            userName = doc.get('Username') as String;
          });
        }
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
  }

  void _checkTeamAndNavigate() {
    if (widget.teamname == 'The Explorers') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DiscoverPage(teamname: widget.teamname),
          ),
        );
      });
    }
  }

  void _joinVoiceChannel(String channelName, String channelId) {
    _channel = VideoSDK.createRoom(
      roomId: channelId,
      displayName: channelName,
      token: token,
      camEnabled: false,
      micEnabled: micEnabled,
    );
    _setRoomEvents(channelName);
    _channel.join();
    setState(() => connected = true);
  }

  void _setRoomEvents(String channelName) {
    _channel.on(Events.roomJoined, () {
      _addUserToVoiceChannel(channelName);
    });
    _channel.on(Events.roomLeft, () {
      _removeUserFromVoiceChannel(channelName);
    });
  }

  Future<void> _addUserToVoiceChannel(String channelName) async {
    try {
      final userId = _auth.currentUser!.uid;
      await _firestore
          .collection('Teams')
          .doc(widget.teamname)
          .collection(channelName)
          .doc(userId)
          .set({ "Username": userName }, SetOptions(merge: true));
    } catch (e) {
      print('Error adding user to voice channel: $e');
    }
  }

  Future<void> _removeUserFromVoiceChannel(String channelName) async {
    try {
      final userId = _auth.currentUser!.uid;
      await _firestore
          .collection('Teams')
          .doc(widget.teamname)
          .collection(channelName)
          .doc(userId)
          .delete();
    } catch (e) {
      print('Error removing user from voice channel: $e');
    }
  }

  void _toggleMicrophone() {
    if (micEnabled) _channel.muteMic();
    else _channel.unmuteMic();
    setState(() => micEnabled = !micEnabled);
  }

  void _leaveVoiceChannel() {
    _channel.leave();
    setState(() => connected = false);
  }

  Future<void> _handleLogout() async {
    try {
      await _auth.signOut();
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 5),
        title: const Text('Logout Successfully'),
        alignment: Alignment.bottomRight,
      );
    } catch (e) {
      if (!mounted) return;
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
     print("HomeScreen build triggered — mounted: $mounted");
    return Row(
          children: [
            Expanded(
              child: Container(
                color: mainwhite,
                padding: const EdgeInsets.all(16),
                child: ChatPage(teamname: widget.teamname),
              ),
            ),
            Container(
              width: 300,
              color: const Color.fromARGB(255, 246, 241, 241),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    color: const Color.fromARGB(255, 217, 217, 217),
                    child: SizedBox(
                      height: 300,
                      child: Column(
                        children: [
                          const Text(
                            'Team Members',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder(
                            future: teammemberFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (snapshot.hasData) {
                                final teamDetails = snapshot.data as Map<String, List<Map<String, dynamic>>>;
                                final members = teamDetails.values.first;
                                return Expanded(
                                  child: ListView.builder(
                                    itemCount: members.length,
                                    itemBuilder: (context, i) {
                                      final u = members[i];
                                      
                                      return Friends(
                                        uiWidget: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              FutureBuilder(
                                                future: getToken(u['username']),
                                                builder: (context, snapshot) {

                                                  if(snapshot.connectionState == ConnectionState.waiting)
                                                  {
                                                    return CircularProgressIndicator();
                                                  }
                                                  else if(snapshot.hasData)
                                                  {
                                                    return CircleAvatar(
                                                      radius: 20,
                                                      backgroundImage: NetworkImage(snapshot.data!),
                                                    );
                                                  }
                                                  else{
                                                    return Text('Error');
                                                  }
                                                },
                                              ),
                                              const SizedBox(width: 8),
                                              Text(u['username'] ?? ''),
                                            ],
                                          ),
                                        ),
                                        userid: u['email'],
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const Center(child: Text('No team members found.'));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Voice Channels', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView(
                      children: [
                        for (var i = 0; i < meetingIds.length; i++) ...[
                          ListTile(
                            title: Text('Voice Channel ${i + 1}'),
                            onTap: () => _joinVoiceChannel('Voice Channel ${i + 1}', meetingIds[i]),
                          ),
                          ParticipantToken(team: widget.teamname, channel: 'Voice Channel ${i + 1}'),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: _toggleMicrophone,
                              icon: Icon(micEnabled ? Icons.mic : Icons.mic_off),
                            ),
                            LeaveButton(connect: connected, icon: const Text('Leave'), onPressed: _leaveVoiceChannel),
                          ],
                        ),
                      ],
                    ),
                  ),
                      
                  
                  
                ],
              ),
            ),
          ],
        );
  }
}
