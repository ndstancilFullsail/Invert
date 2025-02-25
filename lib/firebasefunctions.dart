

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class FirebaseFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String databaseUrl = "https://nvert-1ec6c-default-rtdb.firebaseio.com/";

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

  void addUserDetails(String fullname, String username, String email, CollectionReference userdata) async {
    await userdata.doc(email).set({
      'Full Name': fullname,
      'Username': username,
      'Email': email,
      'Team Name': 'Unassigned',
      'User ID': FirebaseAuth.instance.currentUser!.uid,
    });
    
  }
  Future<String> getFullName() async {
      
      String fullname = '';
      String email = FirebaseAuth.instance.currentUser!.email.toString();
       try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .doc(email) // Replace with your document ID
          .get();
      if (doc.exists) {
        fullname =doc.get('Full Name');
        return fullname;
      }
      else {
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
          .collection('users') // Replace with your collection name
          .doc(email) // Replace with your document ID
          .get();
      if (doc.exists) {
        username =doc.get('Username');
        return username;
      }
      else {
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
          .collection('users') // Replace with your collection name
          .doc(email) // Replace with your document ID
          .get();
      if (doc.exists) {
        useremail =doc.get('Email');
        return useremail;
      }
      else {
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
          .collection('users') // Replace with your collection name
          .doc(email) // Replace with your document ID
          .get();
      if (doc.exists) {
        team =doc.get('Team Name');
        return team;
      }
      else {
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

    void _AddUsertoRealtimeDatabase(String team) async {
      String username = await getUsernameFromCollection();
      
      DatabaseReference ref = FirebaseDatabase.instance.ref('TeamChats').child(team).child('Users').push();
      ref.set({
        'User': username,
      });
    }

    

  Future<void> sendMessage(String teamId, String senderId, String message) async {
    final url = Uri.parse("$databaseUrl/TeamChats/$teamId/Messages.json");
    final response = await http.post(
      url,
      body: json.encode({
        "sender": senderId,
        "text": message,
        "Timestamp": DateTime.now().millisecondsSinceEpoch,
      }),
    );

    if (response.statusCode == 200) {
      print("Message sent successfully!");
    } else {
      print("Error sending message: ${response.body}");
    }
  }

  Future<List<Map<String, dynamic>>?> fetchMessages(String teamId) async {
    final url = Uri.parse("$databaseUrl/TeamChats/$teamId/Messages.json?orderBy=\"Timestamp\"");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>?;
      if (data == null) return [];
      
      List<Map<String, dynamic>> messages = data.entries.map((e) {
        return {"id": e.key, ...e.value as Map<String, dynamic>};
      }).toList().cast<Map<String, dynamic>>();

      messages.sort((a, b) => (a["Timestamp"] ?? 0).compareTo(b["Timestamp"] ?? 0));
      return messages;
    } else {
      print("Error fetching messages: ${response.body}");
      return [];
    }
  }
}

