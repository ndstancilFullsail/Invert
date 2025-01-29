import 'package:flutter/material.dart';
import 'New_user_onboarding.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          // Box for Logo at//
          Container(
            width: double.infinity,
            height: 100, // Height for the logo box
            color: Colors.grey[300], // Background color for the logo box

            child: const Center(
              child: Text(
                'Logo Here',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                // Left-side//
                Expanded(
                  flex: 1,
                  child: Container(
                    child: const Center(
                      child: Text(
                        'This Home Screen!',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),

                // Right-side//
                Container(
                  width: 300, //width for the right-hand side
                  color: Colors.blue[100],
                  padding: const EdgeInsets.all(16), // padding
                  child: Column(
                    children: [
                      // Box for Teams
                      Expanded(
                        child: Card(
                          elevation: 4, // shadow, spokky scary
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Teams',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Team Name: Example Team',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 10),
                                const Icon(
                                  Icons.group,
                                  size: 50, // Emblem size
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Details about teams will go here.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Space between boxes

                      // Box for Personal Challenges
                      Expanded(
                        child: Card(
                          elevation: 4, // spooky shadows
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Personal Challenges',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  '1. Challenge 1\n2. Challenge 2\n3. Challenge 3\n4. Challenge 4\n5. Challenge 5',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}
