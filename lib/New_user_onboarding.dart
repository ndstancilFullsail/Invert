import 'package:flutter/material.dart';
import 'home.dart'; // Import the home screen

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

  void nextQuestion(String answer) {
    setState(() {
      userAnswers.add(answer);
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        // After answering all questions, go to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    });
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
                            style: TextStyle(fontSize: 16),
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
