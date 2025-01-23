import 'package:flutter/material.dart';

class Homepage  extends StatefulWidget{
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}
  class _HomepageState extends State<Homepage> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('InVert'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'Welcome to InVert',
              ),
            ],
    
          ),
        ),
      );
    }
  }

