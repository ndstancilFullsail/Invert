import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SignUpPage extends StatefulWidget {
       const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
    @override
  Widget build(BuildContext context) {

    
    return Scaffold(

      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Color.fromARGB(255, 20, 107, 148),
              child: Center(
                child: Text(
                  'nVert is your place to learn to connect. \nJoin a community that understands you.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,),
                  ),
                  )
              )
            )

            Expanded(
              flex: 3,
              child:Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Sign Up'
                      ),
                      const SizedBox(height: 20),
                      // Full Name Input
                      TextField(
                        controller: _fullnamecontroller,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(),
                          ),
                      )
                    ],
                  )
                ),
              )
              
              
        ),
        ],
      )
    );
  }
}