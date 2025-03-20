import 'package:cloud_firestore/cloud_firestore.dart';

class UserCountService {
  // Singleton instance
  static final UserCountService _instance = UserCountService._internal();
  factory UserCountService() => _instance;
  UserCountService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Listen for real-time memberCount updates in Teams collection
  Stream<int> listenToUserCount(String teamName) {
    return _firestore
        .collection('Teams') // Capital T
        .doc(teamName)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists ? (snapshot.data()?['memberCount'] ?? 0) : 0;
    });
  }

  // Listen for real-time onlineCount updates (if you're tracking online users)
  Stream<int> listenToOnlineCount(String teamName) {
    return _firestore
        .collection('Teams') // Capital T
        .doc(teamName)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists ? (snapshot.data()?['onlineCount'] ?? 0) : 0;
    });
  }

  // Initialize the doc with memberCount = 0 (and onlineCount if desired)
  Future<void> initializeUserCount(String teamName) async {
    try {
      await _firestore.collection('Teams').doc(teamName).set({
        'memberCount': 0,
        'onlineCount': 0, // only if you want it
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error initializing user count: $e');
    }
  }

  // Increment memberCount
  Future<void> incrementUserCount(String teamName) async {
    try {
      await _firestore.collection('Teams').doc(teamName).update({
        'memberCount': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing user count: $e');
    }
  }

  // Decrement memberCount
  Future<void> decrementUserCount(String teamName) async {
    try {
      await _firestore.collection('Teams').doc(teamName).update({
        'memberCount': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Error decrementing user count: $e');
    }
  }

  // Fetch the current memberCount for a team
  Future<int> getUserCount(String teamName) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('Teams').doc(teamName).get();
      return snapshot.exists ? (snapshot.data() as Map<String, dynamic>)['memberCount'] ?? 0 : 0;
    } catch (e) {
      print('Error fetching user count: $e');
      return 0;
    }
  }
}
