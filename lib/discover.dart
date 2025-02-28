import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invert/firebasefunctions.dart';
import 'home.dart';

class DiscoverPage extends StatelessWidget {
  DiscoverPage({super.key});

  // List of teams and details
  final List<Map<String, dynamic>> teams = const [
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

  final String username = FirebaseAuth.instance.currentUser!.displayName!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // Two teams per row
            crossAxisSpacing: 5.0, // Spacing between columns
            mainAxisSpacing: 5.0, // Spacing between rows
            childAspectRatio: 1.0, // Adjust the aspect ratio for balanced cards
          ),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            return _buildTeamCard(team, context);
          },
        ),
      ),
    );
  }

  // Helper function to build a team card
  Widget _buildTeamCard(Map<String, dynamic> team, BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Team logo
            Image.asset(
              team['logo']!,
              width: 20,
              height: 20,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error); // Placeholder if image fails to load
              },
            ),
            SizedBox(height: 2),
            // Team name
            Text(
              team['name']!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            // Team description
            Text(
              team['description']!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2),
            // Member count TODO: Replace with live member count
            Text(
              '${team['memberCount']} members',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 2),
            // Select Team Button TODO: add team discrption on button press then user has to press join team
            ElevatedButton(
              onPressed: () {
                FirebaseFunctions().addUsertoTeam(team['name']!);
                FirebaseFunctions().addUsertoTeamCollection(team['name']!);
                FirebaseFunctions().addUserToTeamRealTime(team['name'], username);

               
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(team: team['name']!),
                  ),
                );
              },
              child: Text('Select Team'),
            ),
          ],
        ),
      ),
    );
  }
}