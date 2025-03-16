import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invert/firebasefunctions.dart';
import 'home.dart';
import 'user_count_service.dart';

class DiscoverPage extends StatelessWidget {
  final String teamname;

  DiscoverPage({super.key, required this.teamname});

  final UserCountService userCountService = UserCountService();

  static const List<Map<String, dynamic>> teams = [
    {
      'name': 'The Innovators',
      'logo': 'assets/innovators_logo.png',
      'description': 'Tech enthusiasts who love building the future.',
    },
    {
      'name': 'The Creatives',
      'logo': 'assets/creatives_logo.png',
      'description': 'Artists and designers who bring ideas to life.',
    },
    {
      'name': 'The Thinkers',
      'logo': 'assets/thinkers_logo.png',
      'description': 'Deep thinkers who explore science and philosophy.',
    },
    {
      'name': 'The Philosophers',
      'logo': 'assets/philosophers_logo.png',
      'description': 'Lovers of wisdom and deep conversations.',
    },
    {
      'name': 'The Champions',
      'logo': 'assets/champions_logo.png',
      'description': 'Sports enthusiasts who strive for excellence.',
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
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
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

  Widget _buildTeamCard(
    Map<String, dynamic> team,
    BuildContext context,
    String? username,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(team['logo']),
            ),
            const SizedBox(height: 10),
            Text(
              team['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(team['description']),
            const SizedBox(height: 5),
            StreamBuilder<int>(
              stream: userCountService.listenToUserCount(team['name']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    '${snapshot.data ?? 0} members',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  );
                }
              },
            ),
            const SizedBox(height: 10),
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

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(teamname: team['name']),
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
