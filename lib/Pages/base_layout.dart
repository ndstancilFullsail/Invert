import 'package:flutter/material.dart';
import 'package:invert/Pages/home.dart';
import '../Base Fuctions/chat.dart';
import 'package:invert/Pages/settings.dart';
import 'package:invert/Pages/userprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invert/Firebase/firebasefunctions.dart';

class BaseLayout extends StatefulWidget {
  final Widget body;

  const BaseLayout({super.key, required this.body});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String email = FirebaseAuth.instance.currentUser!.email.toString();
  late String team;


  void getTeamname()
  {
    FirebaseFunctions().getTeamFromCollection(email).then((value) {
      team = value;
    });
  }

  @override
  void initState() {
    getTeamname();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home'),
      // ),
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 200,
            color: Color(0xFF146C94),
            child: Column(
              children: [
                // Top Circle for Logo
                Container(
                  margin: const EdgeInsets.all(16),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // Background color for the logo circle
                    image: DecorationImage(
                      image: AssetImage('assets/public_speaking.png'), // Logo image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Navigation Icons with onTap
                ListTile(
                  leading: Icon(Icons.explore_outlined, color: Colors.white),
                  title: Text("Discover", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pushNamed(context, '/discover');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.home_outlined,color: Colors.white,),
                  title: Text("Home",style: TextStyle(color: Colors.white),),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(teamname: team)),);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.message_outlined, color: Colors.white),
                  title: Text("Chat", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(teamname: team)),);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.leaderboard_outlined, color: Colors.white),
                  title: Text("Leaderboard", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pushNamed(context, '/leaderboard');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings_outlined, color: Colors.white),
                  title: Text("Settings", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()),);
                  },
                ),
                Spacer(),
                // Bottom Circle for User Profile
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfile()),);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white, // Background color for the profile circle
                      image: DecorationImage(
                        image: AssetImage('assets/public_speaking.png'), // User profile image (Public speaking is placeholder so the error doesn't show)
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: widget.body,
          ),
        ],
      ),
    );
  }
}
