import 'package:flutter/material.dart';
import 'base_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      body: Row(
        children: [
          // Chat Section
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Chat Section',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          // Right-side for Channels
          Container(
            width: 300, // Width for the channels section
            color: Colors.blue[100],
            padding: const EdgeInsets.all(16), // Padding
            child: Column(
              children: [
                // Text Channels Section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Text Channels',
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(title: Text('# Text Channel 1')),
                      ListTile(title: Text('# Text Channel 2')),
                      ListTile(title: Text('# Text Channel 3')),
                      ListTile(title: Text('# Text Channel 4')),
                      ListTile(title: Text('# Text Channel 5')),
                      ListTile(title: Text('# Text Channel 6')),
                    ],
                  ),
                ),
                // Voice Channels Section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Voice Channels',
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text('Voice Channel 1'),
                        leading: Icon(Icons.mic),
                      ),
                      ListTile(
                        title: Text('Voice Channel 2'),
                        leading: Icon(Icons.mic),
                      ),
                      ListTile(
                        title: Text('Voice Channel 3'),
                        leading: Icon(Icons.mic),
                      ),
                      ListTile(
                        title: Text('Voice Channel 4'),
                        leading: Icon(Icons.mic),
                      ),
                      ListTile(
                        title: Text('Voice Channel 5'),
                        leading: Icon(Icons.mic),
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
