import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  _ChallengesPageState createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  // Reference to Firebase Realtime Database for the leaderboard
  final DatabaseReference leaderboardRef =
      FirebaseDatabase.instance.ref().child("Leaderboard");
  // Reference to Firestore for challenges
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> leaderboard = [];
  List<Map<String, dynamic>> challenges = [];

  @override
  void initState() {
    super.initState();
    fetchLeaderboard(); // Fetch leaderboard data
    fetchChallenges(); // Fetch challenges data
  }

  // Fetches the top players from Firebase Realtime Database
  void fetchLeaderboard() {
    leaderboardRef
        .orderByChild("challengesScore")
        .limitToLast(10)
        .onValue
        .listen((event) {
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

        // Sort players by score in descending order
        players.sort((a, b) => b["score"].compareTo(a["score"]));

        setState(() {
          leaderboard = players;
        });
      }
    });
  }

  // Fetches challenges from Firestore
  void fetchChallenges() async {
    QuerySnapshot snapshot = await firestore.collection('challenges').get();
    List<Map<String, dynamic>> fetchedChallenges = snapshot.docs.map((doc) {
      return {
        "id": doc.id,
        "title": doc["title"],
      };
    }).toList();

    setState(() {
      challenges = fetchedChallenges;
    });
  }

  // Updates leaderboard using the authenticated user's details
  void updateLeaderboard(int additionalScore) {
    final User? user = FirebaseAuth.instance.currentUser; // Get logged-in user

    if (user == null) {
      print("No authenticated user found.");
      return;
    }

    String userId = user.uid;
    String username = user.displayName ?? "Anonymous";
    String email = user.email ?? "";
    String? profilePicture = user.photoURL;

    DatabaseReference userRef = leaderboardRef.child(userId);

    userRef.once().then((snapshot) {
      if (snapshot.snapshot.value != null) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(snapshot.snapshot.value as Map);
        int currentScore = userData["challengesScore"] ?? 0;
        userRef.update({
          "challengesScore": currentScore + additionalScore,
        });
      } else {
        // If the user doesn't exist in the leaderboard, create a new entry
        userRef.set({
          "username": username,
          "fullname": email, // Using email as a fallback if full name isn't available
          "challengesScore": additionalScore,
          "profilePicture": profilePicture
        });
      }
    }).catchError((error) {
      print("Error updating leaderboard: $error");
    });
  }

  // Called when a user completes a challenge
  void completeChallenge(int challengeScore) {
    updateLeaderboard(challengeScore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar navigation
          Container(
            width: 100,
            color: const Color(0xFF146C94),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
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
                // Profile icon
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
          // Main content area
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
                    child: challenges.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.count(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            children: challenges.map((challenge) {
                              return ChallengeCard(
                                title: challenge["title"],
                                progress: 0.0, // Placeholder progress
                                isComplete: false, // Placeholder completion status
                                imagePlaceholder: Icons.image,
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ),
          ),
          // Leaderboard panel
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
                            return LeaderboardTile(player: player);
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

// Placeholder widgets for missing components
class SidebarIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const SidebarIcon({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: Colors.white);
  }
}

class ChallengeCard extends StatelessWidget {
  final String title;
  final double progress;
  final bool isComplete;
  final IconData imagePlaceholder;

  const ChallengeCard({required this.title, required this.progress, required this.isComplete, required this.imagePlaceholder, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(child: Text(title));
  }
}

class LeaderboardTile extends StatelessWidget {
  final Map<String, dynamic> player;

  const LeaderboardTile({required this.player, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(player['username']));
  }
}
