import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // If using Firebase
import 'package:google_fonts/google_fonts.dart'; // For custom fonts
import 'package:toastification/toastification.dart'; // For toast messages
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore
import 'package:invert/firebasefunctions.dart'; // For Firebase functions
import 'package:invert/forgotpassword.dart'; // For ForgotPassword screen
import 'package:invert/home.dart'; // For HomeScreen
import 'package:invert/signuppage.dart'; // For SignUpPage
import 'package:invert/discover.dart'; 
import 'package:invert/New_user_onboarding.dart'; 
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InVert',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 20, 107, 148),
      ),
      home: const LoginPage(), // Set the initial screen to LoginPage
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomeScreen(teamname: 'YourTeamName'),
        '/discover': (context) => DiscoverPage(teamname: 'Explorers'),
        '/signup': (context) => const SignUpPage(),
        '/forgot-password': (context) => const ForgotPassword(),
        '/onboarding': (context) => const NewUserOnboarding(),
        // Add other routes here
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool firsttime = true;
  String explorers = 'Explorers';

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
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
                  Image.asset(
                    'assets/images/db5ae0242b73f9d87a79ae1f36559913.png',
                  ),
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
          // Right Login Form Section
          Expanded(
            flex: 3,
            child: Center(
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Connect with other introverts.',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailcontroller,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordcontroller,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 20, 108, 148),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(128, 20, 108, 148),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(
                          color: Color.fromARGB(255, 20, 108, 148),
                        ),
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

  void _signIn() async {
    String email = _emailcontroller.text.trim();
    String password = _passwordcontroller.text.trim();

    try {
      print("Attempting to sign in with email: $email");
      User? user = await FirebaseFunctions().signInWithEmailAndPassword(email, password);

      if (user != null) {
        print("Login successful for user: $email");

        // Check if the user is new (First Time flag)
        bool isNewUser = await FirebaseFunctions().checkUser(email);

        if (isNewUser) {
          // Navigate to Onboarding Screen for new users
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const NewUserOnboarding(),
            ),
          );
        } else {
          // Fetch the user's team
          String team = await FirebaseFunctions().getTeamFromCollection(email);

          if (team == explorers) {
            // Navigate to DiscoverPage for Explorers
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DiscoverPage(teamname: team),
              ),
            );
          } else {
            // Navigate to HomeScreen for other teams
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(teamname: team),
              ),
            );
          }
        }

        // Show success message
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          autoCloseDuration: const Duration(seconds: 5),
          title: const Text('Login Successful'),
          alignment: Alignment.centerRight,
        );
      } else {
        print("Login failed for user: $email");
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          autoCloseDuration: const Duration(seconds: 5),
          title: const Text('Invalid Email or Password'),
          alignment: Alignment.centerRight,
        );
      }
    } on FirebaseAuthException catch (e) {
      print("Firebase error during login: ${e.code} - ${e.message}");
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 5),
        title: Text('Error: ${e.message ?? "Authentication failed"}'),
        alignment: Alignment.centerRight,
      );
    } catch (e) {
      print("Error during login: ${e.toString()}");
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 5),
        title: Text('Error: ${e.toString()}'),
        alignment: Alignment.centerRight,
      );
    }
  }
}