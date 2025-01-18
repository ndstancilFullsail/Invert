import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      
      body: Row(
        children: [
          // Left Branding Section
          Expanded(
            flex: 2,
            child: Container(
              color:  Color.fromARGB(255,20,107,148),
            child: Column(
              children: [
                Image.asset('assets/images/db5ae0242b73f9d87a79ae1f36559913.png',),
                const SizedBox(height: 20),
                 Text(
                  'nVert is your place to learn to connect.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 46,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Join a community that understands you.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    
                  ),
                ),
              ],
              ),
            ),
        ),
          // Right Login Section
          Expanded(
          flex:3,
          child: Center(
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailcontroller,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () {

                    },

                          style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 20, 107, 148),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                        child: const Text(
                          'Send Link to Email',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

      ),
);
  }
}

