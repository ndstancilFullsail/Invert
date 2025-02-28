import 'package:flutter/material.dart';
import 'home.dart';
import 'user_count_service.dart';

class DiscoverPage extends StatelessWidget {
  UserCountService userCountService = UserCountService(); // Initialize user count service

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
            crossAxisCount: 5, //teams per row
            crossAxisSpacing: 4.0, //spacing between columns
            mainAxisSpacing: 4.0, // spacing between rows
            childAspectRatio: 0.8, // card aspect ratio
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

  // function to build a team card
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
              width: 16,
              height: 16,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error); // Placeholder if image fails to load
              },
            ),
            SizedBox(height: 1),
            // Team name
            Text(
              team['name']!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1),
            // Team description
            Text(
              team['description']!,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1),
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
                      fontSize: 10,
                      color: Colors.grey[800],
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 1),
            // Select Team Button TODO: add team description on button press then user has to press join team
            ElevatedButton(
              onPressed: () {
                // Navigate to HomeScreen with the selected team
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
