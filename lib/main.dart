import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import 'package:invert/Firebase/firebasefunctions.dart';
import 'package:invert/Pages/forgotpassword.dart';
import 'Pages/home.dart';
import 'package:invert/Pages/signuppage.dart';
import 'Pages/discover.dart'; 
import 'package:invert/Pages/New_user_onboarding.dart'; 
import 'Firebase/firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  runApp(const InVertApp());
}

Future<void> setupFirebase() async {
  try {
    print('Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
    rethrow;
  }
}


class InVertApp extends StatefulWidget {
  const InVertApp({super.key});

  @override
  State<InVertApp> createState() => _InVertAppState();
}

class _InVertAppState extends State<InVertApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InVert',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 20, 107, 148),
      ),
      home: LoginPage(),
      
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
  String explorers = 'The Explorers';


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
    String team = await FirebaseFunctions().getTeamFromCollection(email);
    bool checkuser = await FirebaseFunctions().checkUser(email);
   
    

    try {
      print("Attempting to sign in with email: $email"); // Logging the email
      User? user = await FirebaseFunctions().signInWithEmailAndPassword(email, password);
      if (user != null) {
        print("Login successful for user: $email");
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          autoCloseDuration: const Duration(seconds: 5),
          title: const Text('Login Successfully'),
          alignment: Alignment.centerRight,
        );

          if (checkuser == true) {

      FirebaseFunctions().changeStatus(email);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NewUserOnboarding(),
          ),
        );
        } else {
        if (team != explorers) {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(teamname: team,),
          ),
        );
          } else {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiscoverPage(teamname: ''),
          ),
        );
      }
     }


        
        
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
