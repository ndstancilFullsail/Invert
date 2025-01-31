import 'package:flutter/material.dart';
import 'home.dart';
import 'challenges_page.dart'; 
import 'settings.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: {
        '/challenges': (context) => ChallengesPage(), 
        '/settings': (context) => SettingsPage(), 
      },
    );
  }
}
