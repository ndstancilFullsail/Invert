import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invert/firebasefunctions.dart';
import 'home.dart';
import 'user_count_service.dart';

class DiscoverPage extends StatelessWidget {
  final String teamname; // Required parameter

  DiscoverPage({super.key, required this.teamname}); // Mark as required

  final UserCountService userCountService = UserCountService(); // Initialize user count service

  // List of teams and details
  static const List<Map<String, dynamic>> teams = [
    {
      'name': 'The Innovators',
      'logo': 'assets/innovators_logo.png',
      'description': 'Tech enthusiasts who love building the future.',
      'memberCount': 120,
    },
    {
      'name': 'The Creatives',
      'logo': 'assets/creatives_logo.png',
      'description': 'Artists and designers who bring ideas to life.',
      'memberCount': 95,
    },
    {
      'name': 'The Thinkers',
      'logo': 'assets/thinkers_logo.png',
      'description': 'Deep thinkers who explore science and philosophy.',
      'memberCount': 80,
    },
    {
      'name': 'The Philosophers',
      'logo': 'assets/philosophers_logo.png',
      'description': 'Lovers of wisdom and deep conversations.',
      'memberCount': 65,
    },
    {
      'name': 'The Champions',
      'logo': 'assets/champions_logo.png',
      'description': 'Sports enthusiasts who strive for excellence.',
      'memberCount': 110,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final String? username = FirebaseAuth.instance.currentUser?.displayName;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Teams per row
            crossAxisSpacing: 16.0, // Spacing between columns
            mainAxisSpacing: 16.0, // Spacing between rows
            childAspectRatio: 0.8, // Card aspect ratio
          ),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            return _buildTeamCard(team, context, username);
          },
        ),
      ),
    );
  }

  // Function to build a team card
  Widget _buildTeamCard(
    Map<String, dynamic> team,
    BuildContext context,
    String? username,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Team logo
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(team['logo']),
              onBackgroundImageError: (exception, stackTrace) {
                // Placeholder if image fails to load
                const Icon(Icons.error);
              },
            ),
            const SizedBox(height: 16),
            // Team name
            Text(
              team['name'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Team description
            Text(
              team['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Member count
            StreamBuilder<int>(
              stream: userCountService.listenToUserCount(team['name']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    '${snapshot.data} members',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            // Select Team Button
            ElevatedButton(
              onPressed: () => _onJoinTeamPressed(context, team, username),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Join Team'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle team join button press
  void _onJoinTeamPressed(
    BuildContext context,
    Map<String, dynamic> team,
    String? username,
  ) async {
    if (username == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in. Please sign in.')),
      );
      return;
    }

    // Show confirmation dialog
    final bool confirmJoin = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Team'),
        content: Text('Are you sure you want to join ${team['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Join'),
          ),
        ],
      ),
    );

    if (confirmJoin == true) {
      try {
        final FirebaseFunctions firebaseFunctions = FirebaseFunctions();
        await firebaseFunctions.addUsertoTeam(team['name']);
        await firebaseFunctions.addUsertoTeamCollection(team['name']);
        await firebaseFunctions.addUserToTeamRealTime(team['name'], username);

        // Navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(teamname: team['name']), // Pass teamname
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join team: $e')),
        );
      }
    }
  }
}