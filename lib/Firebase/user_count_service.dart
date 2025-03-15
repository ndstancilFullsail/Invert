import 'package:cloud_firestore/cloud_firestore.dart';

class UserCountService {
  // Singleton instance
  static final UserCountService _instance = UserCountService._internal();
  factory UserCountService() => _instance;
  UserCountService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to listen for real-time user count updates
  Stream<int> listenToUserCount(String teamName) {
    return _firestore.collection('teams').doc(teamName).snapshots().map((snapshot) {
      return snapshot.exists ? snapshot['userCount'] ?? 0 : 0;
    });
  }

  // Method to initialize user count for a team
  Future<void> initializeUserCount(String teamName) async {
    try {
      await _firestore.collection('teams').doc(teamName).set({
        'userCount': 0,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error initializing user count: $e');
    }
  }

  // Method to increment user count for a team
  Future<void> incrementUserCount(String teamName) async {
    try {
      await _firestore.collection('teams').doc(teamName).set({
        'userCount': FieldValue.increment(1),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error incrementing user count: $e');
    }
  }

  // Method to decrement user count for a team
  Future<void> decrementUserCount(String teamName) async {
    try {
      await _firestore.collection('teams').doc(teamName).set({
        'userCount': FieldValue.increment(-1),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error decrementing user count: $e');
    }
  }

  // Method to fetch user count for a team
  Future<int> getUserCount(String teamName) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('teams').doc(teamName).get();
      return snapshot.exists ? snapshot['userCount'] ?? 0 : 0;
    } catch (e) {
      print('Error fetching user count: $e');
      return 0;
    }
  }
}