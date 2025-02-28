import 'package:cloud_firestore/cloud_firestore.dart';

class UserCountService {
  // Method to listen for real-time user count updates
  Stream<int> listenToUserCount(String teamName) {
    return _firestore.collection('user_counts').doc(teamName).snapshots().map((snapshot) {
      return snapshot.exists ? snapshot['count'] : 0;
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to initialize user count for a team
  Future<void> initializeUserCount(String teamName) async {
    await _firestore.collection('user_counts').doc(teamName).set({
      'count': 0,
    });
  }

  // Method to update user count for a team
  Future<void> updateUserCount(String teamName, int count) async {
    await _firestore.collection('user_counts').doc(teamName).update({
      'count': count,
    });
  }

  // Method to fetch user count for a team
  Future<int> getUserCount(String teamName) async {
    DocumentSnapshot snapshot = await _firestore.collection('user_counts').doc(teamName).get();
    return snapshot.exists ? snapshot['count'] : 0;
  }
}
