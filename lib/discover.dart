import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  // List of teams and their logos
  final List<Map<String, String>> teams = const [
    {
      'name': 'The Innovators',
      'logo': 'public_speaking.png',
    },
    {
      'name': 'The Creatives',
      'logo': 'public_speaking.png', 
    },
    {
      'name': 'The Thinkers',
      'logo': 'public_speaking.png', 
    },
    {
      'name': 'The Philosophers',
      'logo': 'public_speaking.png', 
    },
    {
      'name': 'The Champions',
      'logo': 'public_speaking.png', 
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final team = teams[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Team logo
                  Image.asset(
                    team['logo']!,
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error); // Placeholder if image fails to load
                    },
                  ),
                  SizedBox(width: 16.0),
                  // Team name
                  Text(
                    team['name']!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}