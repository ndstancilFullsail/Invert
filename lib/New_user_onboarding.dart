import 'package:flutter/material.dart';

class NewUserOnboarding extends StatefulWidget {
  const NewUserOnboarding({super.key});

  @override
  _NewUserOnboardingState createState() => _NewUserOnboardingState();
}

class _NewUserOnboardingState extends State<NewUserOnboarding> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is your favorite type of communication activity?',
      'options': [
        {
          'text': 'Public Speaking',
          'image': 'assets/public_speaking.png',
        },
        {
          'text': 'Group Discussions',
          'image': 'assets/group_discussions.png',
        },
        {
          'text': 'One-on-One Conversations',
          'image': 'assets/one_on_one.png',
        },
        {
          'text': 'Writing',
          'image': 'assets/writing.png',
        },
      ],
    },
    {
      'question': 'What is your preferred way of learning new skills?',
      'options': [
        {
          'text': 'Watching Videos',
          'image': 'assets/watching_videos.png',
        },
        {
          'text': 'Reading Articles',
          'image': 'assets/reading_articles.png',
        },
        {
          'text': 'Participating in Workshops',
          'image': 'assets/workshops.png',
        },
        {
          'text': 'Practicing Alone',
          'image': 'assets/practicing_alone.png',
        },
      ],
    },
    {
      'question': 'What topics are you most interested in?',
      'options': [
        {
          'text': 'Technology',
          'image': 'assets/technology.png',
        },
        {
          'text': 'Art',
          'image': 'assets/art.png',
        },
        {
          'text': 'Science',
          'image': 'assets/science.png',
        },
        {
          'text': 'Sports',
          'image': 'assets/sports.png',
        },
        {
          'text': 'Philosophy',
          'image': 'assets/philosophy.png',
        },
      ],
    },
  ];

  int currentQuestionIndex = 0;
  List<String> userAnswers = [];

  void nextQuestion(String answer) {
    setState(() {
      userAnswers.add(answer);
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        String team = categorizeUser(userAnswers);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(team: team),
          ),
        );
      }
    });
  }

  String categorizeUser(List<String> answers) {
    Map<String, String> teams = {
      'Public Speaking': 'Leaders',
      'Group Discussions': 'Collaborators',
      'One-on-One Conversations': 'Connectors',
      'Writing': 'Thinkers',
      'Technology': 'Innovators',
      'Art': 'Creators',
      'Science': 'Researchers',
      'Sports': 'Achievers',
      'Philosophy': 'Philosophers',
    };

    for (String answer in answers) {
      if (teams.containsKey(answer)) {
        return teams[answer]!;
      }
    }
    return 'Explorers';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Onboarding'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questions[currentQuestionIndex]['question'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 5,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                children: questions[currentQuestionIndex]['options']
                    .map<Widget>((option) {
                  return GestureDetector(
                    onTap: () => nextQuestion(option['text']),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            option['image'],
                            height: 80,
                            width: 80,
                          ),
                          SizedBox(height: 5),
                          Text(
                            option['text'],
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final String team;

  const ResultScreen({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding Complete'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Congratulations!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'You have been placed in the "$team" team with like-minded individuals.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
              child: Text('Go to Home Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (int index) {
              // Handle navigation here
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Profile'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Text(
                'Welcome to the Home Screen!',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NewUserOnboarding(),
  ));
}
