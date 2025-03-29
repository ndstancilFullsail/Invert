import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseFunctions {

  // Increment team member count (memberCount field in Teams collection)
  Future<void> incrementTeamMemberCount(String teamId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .update({
        'memberCount': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing team member count: $e');
    }
  }

  // Decrement team member count
  Future<void> decrementTeamMemberCount(String teamId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .update({
        'memberCount': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Error decrementing team member count: $e');
    }
  }


  Future<void> incrementOnlineCount(String teamId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .update({
        'onlineCount': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error incrementing online count: $e');
    }
  }

  Future<void> decrementOnlineCount(String teamId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Teams')
          .doc(teamId)
          .update({
        'onlineCount': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Error decrementing online count: $e');
    }
  }

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
      throw Exception('Failed to sign up: ${e.message}');
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
      throw Exception('Failed to sign in: ${e.message}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('User signed out successfully');
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
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedTeam', team);
    } catch (e) {
      print('Error saving team selection: $e');
      throw Exception('Failed to save team selection: $e');
    }
  }

  // Get team selection from SharedPreferences
  Future<String?> getTeamSelection() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('selectedTeam');
    } catch (e) {
      print('Error getting team selection: $e');
      throw Exception('Failed to get team selection: $e');
    }
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
        throw Exception('No Name exists!');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  Future<void> setOnlineStatus(String status, String email) async {
    try {
      
      await _firestore.collection('users').doc(email).update({
        'Online Status': status,
      });
    } catch (e) {
      print('Error setting online status: $e');
      throw Exception('Failed to set online status: $e');
    }
  }
  Future<String> getOnlineStatus() async {
    try {
      String email = _auth.currentUser!.email!;
      DocumentSnapshot doc = await _firestore.collection('users').doc(email).get();
      if (doc.exists) {
        return doc.get('Online Status') as String;
      } else {
        throw Exception('No Online Status exists!');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
 
  Future<String> getLastSeen() async {
    try {
      String email = _auth.currentUser!.email!;
      DocumentSnapshot doc = await _firestore.collection('users').doc(email).get();
      if (doc.exists) {
        return doc.get('Last Seen').DateTime.fromMillisecondsSinceEpoch().toString();
      } else {
        throw Exception('No Last Seen exists!');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

 

  Future<void> setLastSeen(String email) async {
    try {
      await _firestore.collection('users').doc(email).update({
        'Last Seen': DateTime.now().microsecondsSinceEpoch,
      });
    } catch (e) {
      print('Error setting last seen: $e');
      throw Exception('Failed to set last seen: $e');
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
        throw Exception('No Username exists!');
      }
    } catch (e) {
      throw Exception('Error: $e');
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
        throw Exception('No email exists!');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get team from Firestore
  Future<String> getTeamFromCollection(String email) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(email).get();
      if (doc.exists) {
        return doc.get('Team Name') as String;
      } else {
        throw Exception('No Team exists!');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addUsertoTeam(String team) async {
    try {
      String email = _auth.currentUser!.email!;
      DocumentReference userRef = _firestore.collection('users').doc(email);

      // Ensure user document exists before updating
      DocumentSnapshot userDoc = await userRef.get();
      if (!userDoc.exists) {
        await userRef.set({
          'Team Name': team,
          'Email': email,
        }, SetOptions(merge: true));
      } else {
        await userRef.update({
          'Team Name': team,
        });
      }

      print("Team successfully saved for user: $email");
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

      bool checker = await _checkTeamMembersCollections(team, username);
      if (!checker) {
        await _firestore.collection('Teams').doc(team).collection('Members').doc(username).set({
        'Email': email,
      });
      } else {
        print('User $username is already a member of team $team');
      }
      } catch (e) {
      print('Error adding user to team collection: $e');
      throw Exception('Failed to add user to team collection: $e');
    }
  }

  // Add user to Realtime Database
  Future<void> addUserToTeamRealTime(String team, String username) async {
      bool checker = await checkUserInTeamRealtime(team, username);
      if (!checker) {
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
      throw Exception('Failed to check user: $e');
    }
  }

  // Change user status in Firestore
  Future<void> changeStatus(String email, String team) async {
    try {
      await _firestore.collection('users').doc(email).update({
        'First Time': false,
      });

      // increments the memberCount
      await incrementTeamMemberCount(team);
    } catch (e) {
      print('Error changing user status: $e');
      throw Exception('Failed to change user status: $e');
    }
  }



Future<void> sendDirectMessage(String sender, String receiver, String message) async {
    try {
      final url = Uri.parse("$databaseUrl/DirectMessages/$sender/$receiver.json");
      final response = await http.post(
        url,
        body: json.encode({
          "sender": sender,
          "receiver": receiver,
          "text": message,
          "Timestamp": DateTime.now().millisecondsSinceEpoch,
        }),
      );
      final url2 = Uri.parse("$databaseUrl/DirectMessages/$receiver/$sender.json");
      final response2 = await http.post(
        url2,
        body: json.encode({
          "sender": sender,
          "receiver": receiver,
          "text": message,
          "Timestamp": DateTime.now().millisecondsSinceEpoch,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send direct message: ${response.body}');
      }  
    } catch (e) {
        print('Error sending direct message: $e');
        throw Exception('Failed to send direct message: $e');
    }
  }


  // Fetch direct messages from Firestore
  Future<List<Map<String, dynamic>>> fetchDirectMessages(String sender, String receiver) async {
    try {
      final url = Uri.parse("$databaseUrl/DirectMessages/$sender/$receiver.json?orderBy=\"Timestamp\"");
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
        throw Exception('Failed to fetch direct messages: ${response.body}');
      }
      
    } catch (e) {
      print('Error fetching direct messages: $e');
      throw Exception('Failed to fetch direct messages: $e');
    }
  }
 

  // Fetch team members from Firestore
 Future<Map<String, List<Map<String, dynamic>>>> fetchTeamMembersWithFields(String teamId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Teams').doc(teamId).collection('Members').get();
      List<Map<String, dynamic>> members = [];

      for (var doc in querySnapshot.docs) {
        members.add({
          'username': doc.id,
          'email': doc.get('Email'),
        });
      }

      return {teamId: members};
    } catch (e) {
      print('Error fetching team members: $e');
      throw Exception('Failed to fetch team members: $e');
    }
  }


  Future<bool> _checkTeamMembersCollections(String team, String username) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Teams').doc(team).collection('Members').get();
      for (var doc in querySnapshot.docs) {
        if (doc.id == username) {
          return true;
        }
        
      }
      return false;
      print('User $username is not a member of team $team');
    } catch (e) {
      print('Error checking team members: $e');
      throw Exception('Failed to check team members: $e');
    }
  }
  Future<bool> checkUserInTeamRealtime(String team, String username) async {
    try {
      final url = Uri.parse("$databaseUrl/TeamChats/$team/Users.json");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>?;
        if (data == null) return false;

        return data.values.contains(username);
      } else {
        throw Exception('Failed to check user in Realtime Database: ${response.body}');
      }
    } catch (e) {
      print('Error checking user in Realtime Database: $e');
      throw Exception('Failed to check user in Realtime Database: $e');
    }
  }
}
