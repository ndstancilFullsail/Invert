import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invert/Firebase/firebasefunctions.dart';
import 'home.dart';
import 'package:invert/Firebase/user_count_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiscoverPage extends StatefulWidget {
  final String teamname;

  const DiscoverPage({super.key, required this.teamname});

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
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
  void initState() {
    super.initState();
    _initializeTeamCounts();
  }

  Future<void> _initializeTeamCounts() async {
    // Only initialize the team's document if it doesn't exist already.
    for (var team in teams) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Teams')
          .doc(team['name'])
          .get();
      if (!doc.exists) {
        await userCountService.initializeUserCount(team['name']);
      }
    }
  }

  int _calculateColumns(double width) {
    if (width > 1200) {
      return 4;
    } else if (width > 800) {
      return 3;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? username = FirebaseAuth.instance.currentUser?.displayName;
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = _calculateColumns(width);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(team['logo']),
            ),
            const SizedBox(height: 12),
            Text(
              team['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              team['description'],
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Row to show total (memberCount) and online (onlineCount) counts
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<int>(
                  stream: userCountService.listenToUserCount(team['name']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Total: ...');
                    } else if (snapshot.hasError) {
                      return const Text('Total: err');
                    } else {
                      final total = snapshot.data ?? 0;
                      return Text('Total: $total');
                    }
                  },
                ),
                const SizedBox(width: 8),
                StreamBuilder<int>(
                  stream: userCountService.listenToOnlineCount(team['name']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Online: ...');
                    } else if (snapshot.hasError) {
                      return const Text('Online: err');
                    } else {
                      final online = snapshot.data ?? 0;
                      return Text('Online: $online');
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _onJoinTeamPressed(context, team, username),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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

        await firebaseFunctions.incrementTeamMemberCount(team['name']);

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
