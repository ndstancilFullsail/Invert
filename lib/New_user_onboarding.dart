import 'package:flutter/material.dart';
import 'home.dart'; 

void main() {
  runApp(MaterialApp(
    home: NewUserOnboarding(),
  ));
}

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
        {'text': 'Public Speaking'},
        {'text': 'Group Discussions'},
        {'text': 'One-on-One Conversations'},
        {'text': 'Writing'},
      ],
    },
    {
      'question': 'What is your preferred way of learning new skills?',
      'options': [
        {'text': 'Watching Videos'},
        {'text': 'Reading Articles'},
        {'text': 'Participating in Workshops'},
        {'text': 'Practicing Alone'},
      ],
    },
    {
      'question': 'What topics are you most interested in?',
      'options': [
        {'text': 'Technology'},
        {'text': 'Art'},
        {'text': 'Science'},
        {'text': 'Sports'},
        {'text': 'Philosophy'},
      ],
    },
  ];

  int currentQuestionIndex = 0;
  List<String> userAnswers = [];

  Future<void> nextQuestion(String answer) async {
    setState(() {
      userAnswers.add(answer);
    });

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // After answering all questions, assign team and navigate to HomeScreen
      String team = assignTeam(userAnswers);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(team: team), // Ensure HomeScreen accepts team parameter
        ),
      );
    }
  }

  String assignTeam(List<String> answers) {
    
    String communicationPreference = answers[0];
    String learningPreference = answers[1];
    String interest = answers[2];

    // Team names based on personality traits
    if (communicationPreference == 'Public Speaking' &&
        learningPreference == 'Participating in Workshops' &&
        interest == 'Technology') {
      return 'The Innovators';
    } else if (communicationPreference == 'Group Discussions' &&
        learningPreference == 'Watching Videos' &&
        interest == 'Art') {
      return 'The Creatives';
    } else if (communicationPreference == 'One-on-One Conversations' &&
        learningPreference == 'Reading Articles' &&
        interest == 'Science') {
      return 'The Thinkers';
    } else if (communicationPreference == 'Writing' &&
        learningPreference == 'Practicing Alone' &&
        interest == 'Philosophy') {
      return 'The Philosophers';
    } else if (communicationPreference == 'Public Speaking' &&
        learningPreference == 'Participating in Workshops' &&
        interest == 'Sports') {
      return 'The Champions';
    } else {
      // team for unmatched combinations
      return 'The Explorers';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Onboarding'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questions[currentQuestionIndex]['question'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Column(
                children: questions[currentQuestionIndex]['options']
                    .map<Widget>((option) {
                  return GestureDetector(
                    onTap: () => nextQuestion(option['text']),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            option['text'],
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
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