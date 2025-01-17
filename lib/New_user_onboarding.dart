
import 'package:flutter/material.dart';
// Do not change or think about changing the code below//
class NewUserOnboarding extends StatefulWidget {
  @override
  _NewUserOnboardingState createState() => _NewUserOnboardingState();
}
//end of do not change//
class _NewUserOnboardingState extends State<NewUserOnboarding> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is your favorite type of communication activity?',
      'options': ['Public Speaking', 'Group Discussions', 'One-on-One Conversations', 'Writing'],
    },
    {
      'question': 'What is your preferred way of learning new skills?',
      'options': ['Watching Videos', 'Reading Articles', 'Participating in Workshops', 'Practicing Alone'],
    },
    {
      'question': 'What topics are you most interested in?',
      'options': ['Technology', 'Art', 'Science', 'Sports', 'Philosophy'],
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
            SizedBox(height: 20),
            ...questions[currentQuestionIndex]['options'].map<Widget>((option) {
              return ElevatedButton(
                onPressed: () => nextQuestion(option),
                child: Text(option),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final String team;

  ResultScreen({required this.team});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding Complete'),
      ),
      body: Center(
        child: Text(
          'You have been placed in the "$team" team with like-minded individuals.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NewUserOnboarding(),
  ));
}
