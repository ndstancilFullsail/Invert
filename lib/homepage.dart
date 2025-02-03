import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

6





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
              Text(
                'Welcome to InVert',
              ),
              const SizedBox(height: 20),
              Text(
                'Email: $email\t',
              ),
              Text(
                'User ID: $uid\t',
              ),
              Text('Username: $name\t'),


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

