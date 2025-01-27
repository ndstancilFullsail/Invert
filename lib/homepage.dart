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
                  title: Text('Login Successfully'),
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

