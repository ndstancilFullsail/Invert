import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invert/main.dart';
import 'package:toastification/toastification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Firebase/firebasefunctions.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userdata = FirebaseFirestore.instance.collection('users');

  @override
  void dispose() {
    _fullnamecontroller.dispose();
    _usernamecontroller.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _confirmpasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Branding Section
          Expanded(
            flex: 2,
            child: Container(
              color: const Color.fromARGB(255, 20, 107, 148),
              child: Column(
                children: [
                  Image.asset('assets/images/db5ae0242b73f9d87a79ae1f36559913.png'),
                  const SizedBox(height: 20),
                  Text(
                    'nVert is your place to learn to connect.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 34,
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
          // Right Sign-Up Form Section
          Expanded(
            flex: 3,
            child: Center(
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Full Name Input
                    TextFormField(
                      controller: _fullnamecontroller,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Username Input
                    TextFormField(
                      controller: _usernamecontroller,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Email Input
                    TextFormField(
                      controller: _emailcontroller,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Password Input
                    TextFormField(
                      controller: _passwordcontroller,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    // Confirm Password Input
                    TextFormField(
                      controller: _confirmpasswordcontroller,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    // Sign Up Button
                    ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 20, 107, 148),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signUp() async {
    String email = _emailcontroller.text.trim();
    String password = _passwordcontroller.text.trim();
    String username = _usernamecontroller.text.trim();
    String fullName = _fullnamecontroller.text.trim();

    // Check if passwords match
    if (_passwordcontroller.text != _confirmpasswordcontroller.text) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 5),
        title: const Text('Passwords do not match'),
        alignment: Alignment.bottomRight,
      );
      return;
    }

    try {
      // Sign up with email and password
      User? user = await FirebaseFunctions().signUpWithEmailAndPassword(email, password);

      if (user != null) {
        // Add user details to Firestore with First Time flag
        await FirebaseFunctions().addUserDetails(fullName, username, email);

        // Update user display name
        await user.updateDisplayName(username);

        // Show success message
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          autoCloseDuration: const Duration(seconds: 5),
          title: const Text('Account created successfully'),
          alignment: Alignment.bottomRight,
        );

        // Navigate to login page 
         Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            LoginPage(),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
    } on FirebaseAuthException catch (e) {
      // Show error message
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 5),
        title: Text('Sign up failed: ${e.message}'),
        alignment: Alignment.bottomRight,
      );
    }
  }



 
}