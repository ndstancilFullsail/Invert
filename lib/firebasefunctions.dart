import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final String databaseUrl = "https://nvert-1ec6c-default-rtdb.firebaseio.com/";

  // Sign up with email and password
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Sign Up Error: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Sign In Error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _auth.signOut();
        print('User signed out successfully');
      } else {
        print('No user is currently signed in');
      }
    } on FirebaseAuthException catch (e) {
      print('Sign Out Error: ${e.code} - ${e.message}');
      throw Exception('Failed to sign out: ${e.message}');
    } catch (e) {
      print('Unexpected Error during sign out: $e');
      throw Exception('Unexpected error during sign out: $e');
    }
  }

  // Save team selection to SharedPreferences
  Future<void> saveTeamSelection(String team) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTeam', team);
  }

  // Get team selection from SharedPreferences
  Future<String?> getTeamSelection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedTeam');
  }

  // Add user details to Firestore
  Future<void> addUserDetails(String fullName, String username, String email) async {
    try {
      await _firestore.collection('users').doc(email).set({
        'Full Name': fullName,
        'Username': username,
        'Email': email,
        'Team Name': 'Unassigned',
        'User ID': _auth.currentUser!.uid,
        'First Time': true,
      });
    } catch (e) {
      print('Error adding user details: $e');
      throw Exception('Failed to add user details: $e');
    }
  }

  // Get full name from Firestore
  Future<String> getFullName() async {
    try {
      String email = _auth.currentUser!.email!;
      DocumentSnapshot doc = await _firestore.collection('users').doc(email).get();
      if (doc.exists) {
        return doc.get('Full Name') as String;
      } else {
        return "No Name exists!";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  // Get username from Firestore
  Future<String> getUsernameFromCollection() async {
    try {
      String email = _auth.currentUser!.email!;
      DocumentSnapshot doc = await _firestore.collection('users').doc(email).get();
      if (doc.exists) {
        return doc.get('Username') as String;
      } else {
        return "No Username exists!";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  // Get email from Firestore
  Future<String> getEmailFromCollection() async {
    try {
      String email = _auth.currentUser!.email!;
      DocumentSnapshot doc = await _firestore.collection('users').doc(email).get();
      if (doc.exists) {
        return doc.get('Email') as String;
      } else {
        return "No email exists!";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  // Get team from Firestore
  Future<String> getTeamFromCollection(String email) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(email).get();
      if (doc.exists) {
        return doc.get('Team Name') as String;
      } else {
        return "No Team exists!";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  // Add user to a team in Firestore
  Future<void> addUsertoTeam(String team) async {
    try {
      String email = _auth.currentUser!.email!;
      await _firestore.collection('users').doc(email).update({
        'Team Name': team,
      });
    } catch (e) {
      print('Error adding user to team: $e');
      throw Exception('Failed to add user to team: $e');
    }
  }

  // Add user to a team collection in Firestore
  Future<void> addUsertoTeamCollection(String team) async {
    try {
      String email = _auth.currentUser!.email!;
      String username = await getUsernameFromCollection();
      await _firestore.collection('Teams').doc(team).collection('Members').doc(username).set({
        'Email': email,
      });
    } catch (e) {
      print('Error adding user to team collection: $e');
      throw Exception('Failed to add user to team collection: $e');
    }
  }

  // Add user to Realtime Database
  Future<void> addUserToTeamRealTime(String team, String username) async {
    try {
      final url = Uri.parse("$databaseUrl/TeamChats/$team/Users.json");
      final response = await http.post(
        url,
        body: json.encode({
          "Users": username,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add user to Realtime Database: ${response.body}');
      }
    } catch (e) {
      print('Error adding user to Realtime Database: $e');
      throw Exception('Failed to add user to Realtime Database: $e');
    }
  }

  // Send message to Realtime Database
  Future<void> sendMessage(String teamId, String senderId, String message) async {
    try {
      final url = Uri.parse("$databaseUrl/TeamChats/$teamId/Messages.json");
      final response = await http.post(
        url,
        body: json.encode({
          "sender": senderId,
          "text": message,
          "Timestamp": DateTime.now().millisecondsSinceEpoch,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send message: ${response.body}');
      }
    } catch (e) {
      print('Error sending message: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  // Fetch messages from Realtime Database
  Future<List<Map<String, dynamic>>> fetchMessages(String teamId) async {
    try {
      final url = Uri.parse("$databaseUrl/TeamChats/$teamId/Messages.json?orderBy=\"Timestamp\"");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>?;
        if (data == null) return [];

        List<Map<String, dynamic>> messages = data.entries.map((e) {
          return {"id": e.key, ...e.value as Map<String, dynamic>};
        }).toList();

        messages.sort((a, b) => (a["Timestamp"] ?? 0).compareTo(b["Timestamp"] ?? 0));
        return messages;
      } else {
        throw Exception('Failed to fetch messages: ${response.body}');
      }
    } catch (e) {
      print('Error fetching messages: $e');
      throw Exception('Failed to fetch messages: $e');
    }
  }

  // Check if user exists in Firestore
  Future<bool> checkUser(String email) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(email).get();
      return doc.exists && doc.get('First Time') as bool;
    } catch (e) {
      print('Error checking user: $e');
      return false;
    }
  }

  // Change user status in Firestore
  Future<void> changeStatus(String email) async {
    try {
      await _firestore.collection('users').doc(email).update({
        'First Time': false,
      });
    } catch (e) {
      print('Error changing user status: $e');
      throw Exception('Failed to change user status: $e');
    }
  }
}