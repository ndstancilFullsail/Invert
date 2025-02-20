import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  _ChallengesPageState createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  final DatabaseReference leaderboardRef = FirebaseDatabase.instance.ref().child("Leaderboard");
  List<Map<String, dynamic>> leaderboard = [];

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  void fetchLeaderboard() {
    leaderboardRef.orderByChild("challengesScore").limitToLast(10).onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        List<Map<String, dynamic>> players = [];
        data.forEach((key, value) {
          players.add({
            "username": value["username"],
            "fullname": value["fullname"],
            "score": value["challengesScore"],
            "profilePicture": value["profilePicture"]
          });
        });

        players.sort((a, b) => b["score"].compareTo(a["score"]));

        setState(() {
          leaderboard = players;
        });
      }
    });
  }

  void updateLeaderboard(String userId, String username, String fullname, int additionalScore, String profilePicture) {
    DatabaseReference userRef = leaderboardRef.child(userId);

    userRef.once().then((snapshot) {
      if (snapshot.snapshot.value != null) {
        Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
        int currentScore = userData["challengesScore"] ?? 0;
        userRef.update({
          "challengesScore": currentScore + additionalScore,
        });
      } else {
        userRef.set({
          "username": username,
          "fullname": fullname,
          "challengesScore": additionalScore,
          "profilePicture": profilePicture
        });
      }
    }).catchError((error) {
      print("Error updating leaderboard: $error");
    });
  }

  void completeChallenge(String userId, String username, String fullname, int challengeScore, String profilePicture) {
    updateLeaderboard(userId, username, fullname, challengeScore, profilePicture);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 100,
            color: const Color(0xFF146C94),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Challenges",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: List.generate(9, (index) {
                        return ChallengeCard(
                          title: "Challenge ${index + 1}",
                          progress: (index % 4) * 0.25,
                          isComplete: index % 2 == 0,
                          imagePlaceholder: Icons.image,
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF146C94), Color(0xFF1E88E5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Leaderboard",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: leaderboard.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: leaderboard.length,
                          itemBuilder: (context, index) {
                            var player = leaderboard[index];
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
                                    backgroundImage: player["profilePicture"] != null
                                        ? NetworkImage(player["profilePicture"])
                                        : const AssetImage('assets/profile.png') as ImageProvider,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          player["username"],
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Points: ${player["score"]}",
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
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

class ChallengeCard extends StatelessWidget {
  final String title;
  final double progress;
  final bool isComplete;
  final IconData imagePlaceholder;

  const ChallengeCard({
    super.key,
    required this.title,
    required this.progress,
    required this.isComplete,
    required this.imagePlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(imagePlaceholder, size: 48),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 8),
          Text(isComplete ? "Complete" : "In Progress"),
        ],
      ),
    );
  }
}

class SidebarIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const SidebarIcon({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
