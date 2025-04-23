import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:invert/Firebase/utils.dart';
import 'package:invert/Pages/home.dart';
import 'package:invert/Base%20Fuctions/chat.dart';
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
  late String email;
  String? team;

  @override
  void initState() {
    super.initState();
    email = _auth.currentUser!.email!;
    _getTeamname();
  }

  

  void _getTeamname() async {
    final result = await FirebaseFunctions().getTeamFromCollection(email);
    if(!mounted) return;
    setState(() {
      team = result;
    });
  }

  void _handleNavigation(String key) {
    if (team == null || !mounted) return;

    switch (key) {
      case 'home':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => HomeScreen(teamname: team!)));
        break;
      case 'discover':
        Navigator.pushNamed(context, '/discover');
        break;
      case 'chat':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ChatPage(teamname: team!)));
        break;
      case 'leaderboard':
        Navigator.pushNamed(context, '/leaderboard');
        break;
      case 'settings':
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SettingsPage()));
        break;
      case 'profile':
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const UserProfile()));
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
            child: widget.body,
          ),
        ],
      ),
    );
  }
}

class CustomNavDrawer extends StatefulWidget {
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const CustomNavDrawer({
    super.key,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<CustomNavDrawer> createState() => _CustomNavDrawerState();
}

class _CustomNavDrawerState extends State<CustomNavDrawer> {
  bool isExpanded = false;

  final Color lightBlue = const Color(0xFFB3E5FC);
  final Color iconColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isExpanded = true),
      onExit: (_) => setState(() => isExpanded = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isExpanded ? 220 : 70,
        decoration: BoxDecoration(
          color: lightBlue.withAlpha(1),
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
                Center(
                  child: CircleAvatar(
                    radius: isExpanded ? 35 : 25,
                    backgroundImage: const AssetImage('assets/public_speaking.png'),
                  ),
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
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, String key) {
    return InkWell(
      onTap: () {
        if (key == 'logout') {
          widget.onLogout();
        } else {
          widget.onNavigate(key);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            if (isExpanded) const SizedBox(width: 20),
            if (isExpanded)
              Text(
                label,
                style: TextStyle(
                  color: iconColor.withAlpha(90),
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
