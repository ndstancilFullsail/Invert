import 'package:flutter/material.dart';
import 'package:invert/signuppage.dart';
import 'package:invert/utils.dart';


void main() async {

  await setup();
  runApp(const InVertApp());
}

Future<void> setup() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase(); 
}

class InVertApp extends StatelessWidget {
  const InVertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InVert',
      theme: ThemeData(
        primaryColor: Colors.cyan[800],
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
              child: const Center(
                child: Text(
                  'nVert is your place to learn to connect.\nJoin a community that understands you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Right Login Section
          Expanded(
            flex: 3,
            child: Center(
              child: SizedBox(
                width: 300,
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
                    // Username Input
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Password Input
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                        // Add login functionality here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Color.fromARGB(255,20,107,148),
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
                    const SizedBox(height: 10),
                    // Sign-Up Text
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context)=> SignUpPage(),
                          ),
                        );
                      },
                      child: const Text("Don't have an account? Sign Up"),
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