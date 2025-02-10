import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invert/base_layout.dart';


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
    
    @override
    Widget build(BuildContext context) {
      return BaseLayout(
        body: Row(
          children: <Widget> [
            Expanded(
              flex: 1,
              child: Container(
                color: Color.fromARGB(255, 20, 107, 148),
                child: Column(
                  children: <Widget> [
                    Card(child: SizedBox(height: 500, child:Column(
                      children: <Widget> [

                        Image.asset('assets/images/db5ae0242b73f9d87a79ae1f36559913.png'),

                        const SizedBox(height: 20),
                        Text(
                          'InVert is your place to learn to connect.',
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Welcome, $name',
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Email: $email',
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                      ],
                    ),
                    ),
                    ),
                    
                  ],
                
                ),
              ),
            ),
            Expanded(
              flex: 1, 
              child: Container()),

            Expanded(child: Container()),








          ]
            // Chat Section
            
        ),
      );
      
    }



    
  }

