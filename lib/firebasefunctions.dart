import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invert/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailandPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<User?> signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      print('Starting sign out process...');
      final user = _auth.currentUser;
      if (user != null) {
        print('Signing out user: ${user.uid} (${user.email})');
        await _auth.signOut();
        print('Sign out completed successfully');
      } else {
        print('No user is currently signed in');
        throw Exception('No user is currently signed in');
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during sign out: ${e.code} - ${e.message}');
      throw Exception('Failed to sign out: ${e.message}');
    } catch (e) {
      print('Unexpected error during sign out: $e');
      throw Exception('Unexpected error during sign out: $e');
    }
  }

  Future<void> saveTeamSelection(String team) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTeam', team);
  }

  Future<String?> getTeamSelection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedTeam');
  }

  Future<void> navigateToLogin(BuildContext context) async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void addUserDetails(String fullname, String username, String email, CollectionReference userdata) async {
    await userdata.doc(email).set({
      'Full Name': fullname,
      'Username': username,
      'Email': email,
      'Team': 'Unassigned',
      'User ID': FirebaseAuth.instance.currentUser!.uid,
    });
  }
  
  Future<String> getFullName() async {
    String fullname = '';
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get();
      if (doc.exists) {
        fullname = doc.get('Full Name');
        return fullname;
      } else {
        return "No Name exists!";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<String> getUsernameFromCollection() async {
    String username = '';
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get();
      if (doc.exists) {
        username = doc.get('Username');
        return username;
      } else {
        return "No Username exists!";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
  
  Future<String> getEmailFromCollection() async {
    String useremail = '';
    String email = FirebaseAuth.instance.currentUser!.email!;
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get();
      if (doc.exists) {
        useremail = doc.get('Email');
        return useremail;
      } else {
        return "No email exists!";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<String> getTeamFromCollection() async {
    String team = '';
    String email = FirebaseAuth.instance.currentUser!.email!;
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .get();
      if (doc.exists) {
        team = doc.get('Team');
        return team;
      } else {
        return "No Team exists!";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  void addUsertoTeam(String team) async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      'Team Name': team,
    });
  }

  void addUsertoTeamCollection(String team) async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    String username = await getUsernameFromCollection();
    await FirebaseFirestore.instance.collection('Teams').doc(team).collection('Members').doc(username).set({
      'Email': email,
    });
  }
}
