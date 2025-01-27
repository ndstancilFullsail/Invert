import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invert/forgotpassword.dart';
import 'package:invert/signuppage.dart';
import 'package:invert/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invert/signuputils.dart';
import 'package:toastification/toastification.dart';
import 'package:invert/homepage.dart';




void main() async {

  await setup();
  runApp(const InVertApp());
}
//Do Not change//

Future<void> setup() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase(); 
}

class InVertApp extends StatefulWidget {
  const InVertApp({super.key});

  @override
  State<InVertApp> createState() => _InVertAppState();
}

class _InVertAppState extends State<InVertApp> {
  @override
  Widget build(BuildContext context)
   {
    return MaterialApp(
      title: 'InVert',
      theme: ThemeData(
        primaryColor: Colors.cyan[800],
      ),
      home: const LoginPage(),
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
          const BrandingSection(),
          // Right Login Section
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
          // Right Login Section
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
                    // Email Input
                    TextFormField(
                      controller: _emailcontroller,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Password Input
                    TextFormField(
                      controller: _passwordcontroller,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context)=> ForgotPassword(),
                          ),
                        );
                      },
                      child: const Text("Forgot Password?", 
                      style: TextStyle(
                        color: Color.fromARGB(255,20, 108, 148),
                      ),
                      ),
                    ),
                    const SizedBox(height: 15),
                   

                    // Login Button
                    ElevatedButton(
                      onPressed: _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Color.fromARGB(128,20, 108, 148),
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
                    // Sign-Up Text
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context)=> SignUpPage(),
                          ),
                        );
                      },
                      child: const Text("Don't have an account? Sign Up",
                      style: TextStyle(
                        color: Color.fromARGB(255,20, 108, 148),
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

   void _signIn() async{
  
  String email = _emailcontroller.text.trim();
  String password = _passwordcontroller.text.trim();

  User? user = await FirebaseSignUp().signInWithEmailandPassword(email, password);
  if(user != null){
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text('Login Successfully'),
      alignment: Alignment.centerRight,
      );
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context)=> const Homepage(),
        ),
      );
    }else{
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 5),
        title: Text('Invalid Email or Password'),
        alignment: Alignment.centerRight,
        );

    }
  }
}