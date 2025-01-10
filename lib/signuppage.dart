import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SignUpPage extends StatefulWidget {
       const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final TextEditingController _fullnamecontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller = TextEditingController();

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
                  ),
              ),
            ),

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
                      ),
                      const SizedBox(height: 10),
                      // Username Input
                      TextField(
                        controller: _usernamecontroller,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          ),
                      ),
                      const SizedBox(height: 10),
                      // Email Input
                      TextField(
                        controller: _emailcontroller,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          ),
                      ),
                      const SizedBox(height: 10),
                      // Password Input
                      TextField(
                        controller: _passwordcontroller,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          ), 
                      ),
                      const SizedBox(height: 20),
                      // Confirm Password Input
                      TextField(
                        controller: _confirmpasswordcontroller,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(),
                          ),
                      ),
                      // Sign Up Button
                      ElevatedButton(
                        onPressed: () {
                          // Add sign up functionality here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 20, 107, 148),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

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