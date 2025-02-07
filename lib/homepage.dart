import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invert/home.dart';
import 'package:invert/main.dart';
import 'package:toastification/toastification.dart';


class Homepage  extends StatefulWidget{
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final String email = FirebaseAuth.instance.currentUser!.email.toString();
    final String name = FirebaseAuth.instance.currentUser!.displayName.toString();
    final String  invalidUser = 'No user is currently signed in';



    Future<String> getFullName() async {
      String fullname = '';
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
        return "No email exists!";
      }

      
     
    } catch (e) {
      return "Error: $e";
    }
  }


    Future<String> getUsernameFromCollection() async {
      String fullname = '';
       try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .doc(email) // Replace with your document ID
          .get();
      if (doc.exists) {
        fullname =doc.get('Username');
        return fullname;
      }
      else {
        return "No email exists!";
      }

      
     
    } catch (e) {
      return "Error: $e";
    }
  }
  
    Future<String> getEmailFromCollection() async {
      String fullname = '';
       try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .doc(email) // Replace with your document ID
          .get();
      if (doc.exists) {
        fullname =doc.get('Email');
        return fullname;
      }
      else {
        return "No email exists!";
      }

      
     
    } catch (e) {
      return "Error: $e";
    }
  }
  Future<String> getTeamFromCollection() async {
      String fullname = '';
       try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .doc(email) // Replace with your document ID
          .get();
      if (doc.exists) {
        fullname =doc.get('Team');
        return fullname;
      }
      else {
        return "No email exists!";
      }
      } catch (e) {
      return "Error: $e";
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InVert'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to InVert',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
              const SizedBox(height: 20),
              Text(
                'Email: $email\t',
              ),
              Text(
                'User ID: $uid\t',
              ),
              Text('Username: $name\t'),

              FutureBuilder(future: getFullName(), builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading spinner
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Text(
                "Full Name: ${snapshot.data}",
                style: TextStyle(fontSize: 20),
                  );
                }
              },
            ),


              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {

                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                  toastification.show(
                  context: context,
                  type: ToastificationType.success,
                  style: ToastificationStyle.flat,
                  autoCloseDuration: const Duration(seconds: 5),
                  title: Text('Logout Successfully'),
                  alignment: Alignment.bottomRight,
                    );


                },
                child: const Text('Logout'),

              ),
              
              
            ],

    
          ),
        ),
      );
    }



    
  }

