import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:invert/Firebase/utils.dart';
import 'package:invert/Pages/home.dart';
import 'package:invert/Base%20Fuctions/chat.dart';
import 'package:invert/Pages/settings.dart';
import 'package:invert/Pages/userprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invert/Firebase/firebasefunctions.dart';

class BaseLayout extends StatefulWidget {
  final String teamName;

  const BaseLayout({super.key, required this.teamName});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String email;
  String? team;
  late Widget transfering;

  @override
  void initState() {
    super.initState();
    email = _auth.currentUser!.email!;
    transfering = HomeScreen(teamname: widget.teamName);
    _getTeamname();
  }

  void _getTeamname() async {
    final result = await FirebaseFunctions().getTeamFromCollection(email);
    if (!mounted) return;
    setState(() {
      team = result;
    });
  }

  void _handleNavigation(String key) {
    if (team == null || !mounted) return;

    switch (key) {
      case 'home':
        setState(() {
          transfering = HomeScreen(teamname: widget.teamName);
        });
        break;
      case 'discover':
        Navigator.pushNamed(context, '/discover');
        break;
      case 'chat':
        setState(() {
          transfering = ChatPage(teamname: widget.teamName);
        });
        break;
      case 'leaderboard':
        Navigator.pushNamed(context, '/leaderboard'); 
        break;
      case 'settings':
        setState(() {
          transfering = const SettingsPage();
        });
        break;
      case 'profile':
        setState(() {
          transfering = const UserProfile();
        });
        break;
    }
  }

  void _handleLogout() async {
    FirebaseFunctions().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CustomNavDrawer(
            onNavigate: _handleNavigation,
            onLogout: _handleLogout,
          ),
          Expanded(
            child: Scaffold(
              backgroundColor: maincolor,
              body: transfering,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomNavDrawer extends StatelessWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const CustomNavDrawer({super.key, required this.onNavigate, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final Color lightBlue = const Color(0xFFB3E5FC);
    final Color iconColor = Colors.white;

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: lightBlue.withOpacity(0.3),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage('assets/public_speaking.png'),
              ),
              const SizedBox(height: 20),
              _buildNavItem(Icons.explore, 'Discover', 'discover'),
              _buildNavItem(Icons.home, 'Home', 'home'),
              _buildNavItem(Icons.message, 'Chat', 'chat'),
              _buildNavItem(Icons.leaderboard, 'Leaderboard', 'leaderboard'),
              _buildNavItem(Icons.settings, 'Settings', 'settings'),
              const Spacer(),
              _buildNavItem(Icons.person, 'Profile', 'profile'),
              _buildNavItem(Icons.logout, 'Logout', 'logout'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, String key) {
    return InkWell(
      onTap: () {
        if (key == 'logout') {
          onLogout();
        } else {
          onNavigate(key);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
