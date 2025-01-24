import 'package:flutter/material.dart';
import 'package:invert/join.dart';
import 'package:invert/signup_page.dart';

//Do Not change//
void main()
 {
  runApp(const InVertApp());
}
//Do Not change//

class InVertApp extends StatelessWidget 
{
  const InVertApp({super.key});

  @override
  Widget build(BuildContext context)
   {
    return MaterialApp(
      title: 'InVert',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JoinScreen(),
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
          const BrandingSection(),
          // Right Login Section
          Expanded(
            flex: 3,
            child: Center(
              child: SizedBox(
                width: 300,
                child: const LoginForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// This is the left side of the login page the blue side//
class BrandingSection extends StatelessWidget
 {
  const BrandingSection({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Expanded(
      flex: 2,
      child: Container(
        color: Colors.blue[700],
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
    );
  }
}
// End of the left side of the login page the blue side//

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Log In',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter both username and password')),
              );
            } else {
              //  login logic
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
          child: const Text(
            'Log In',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: const Text("Don't have an account? Sign Up"),
        ),
      ],
    );
  }
}
