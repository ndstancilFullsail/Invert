import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  _ChallengesPageState createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  List<Challenge> challenges = [];

  @override
  void initState() {
    super.initState();
    loadChallenges();
  }

  void loadChallenges() async {
    // Load challenges from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('challenges').get();
    setState(() {
      challenges = snapshot.docs.map((doc) => Challenge.fromFirestore(doc)).toList();
    });
  }

  void completeChallenge(int index) {
    setState(() {
      challenges[index].isComplete = true;
      challenges[index].progress = 1.0;
    });
    // Save progress to Firestore
    FirebaseFirestore.instance.collection('challenges').doc(challenges[index].id).update({
      'isComplete': true,
      'progress': 1.0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 100,
            color: Color(0xFF146C94),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      "Logo",
                      style: TextStyle(
                        color: Color(0xFF146C94),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SidebarIcon(icon: Icons.explore_outlined, label: "Discover"),
                    SidebarIcon(icon: Icons.message_outlined, label: "Chat"),
                    SidebarIcon(icon: Icons.leaderboard_outlined, label: "Leaderboard"),
                    SidebarIcon(icon: Icons.settings_outlined, label: "Settings"),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile.png'), // Placeholder for user profile image
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Challenges",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: List.generate(challenges.length, (index) {
                        return ChallengeCard(
                          title: challenges[index].title,
                          progress: challenges[index].progress,
                          isComplete: challenges[index].isComplete,
                          imagePlaceholder: Icons.image, // Placeholder for images
                          onComplete: () => completeChallenge(index),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Leaderboard
          Container(
            width: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF146C94), Color(0xFF1E88E5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "Leaderboard",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage('assets/user${index + 1}.png'), // Placeholder for leaderboard profile images
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "User ${index + 1}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Points: ${1000 - index * 50}",
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const SidebarIcon({super.key, 
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final String title;
  final double progress;
  final bool isComplete;
  final IconData imagePlaceholder;
  final VoidCallback onComplete;

  const ChallengeCard({super.key, 
    required this.title,
    required this.progress,
    required this.isComplete,
    required this.imagePlaceholder,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              imagePlaceholder,
              size: 48,
              color: Colors.grey,
            ), // Placeholder for image
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: progress == 1.0 ? Colors.green : Colors.blue,
            ),
            SizedBox(height: 8),
            Text(
              isComplete ? "Complete" : "${(progress * 100).toInt()}%",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 8),
            if (!isComplete)
              ElevatedButton(
                onPressed: onComplete,
                child: Text("Complete Challenge"),
              ),
          ],
        ),
      ),
    );
  }
}

class Challenge {
  String id;
  String title;
  double progress;
  bool isComplete;

  Challenge({required this.id, required this.title, required this.progress, required this.isComplete});

  factory Challenge.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Challenge(
      id: doc.id,
      title: data['title'] ?? '',
      progress: data['progress'] ?? 0.0,
      isComplete: data['isComplete'] ?? false,
    );
  }
}
