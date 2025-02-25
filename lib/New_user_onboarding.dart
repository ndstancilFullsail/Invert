import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:invert/firebasefunctions.dart';
import 'home.dart';
import 'discover.dart';

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
    final String champion = 'Champions';
    final String creative = 'Creatives';
    final String innovator = 'Innovators';
    final String philosopher = 'Philosophers';
    final String thinker = 'Thinkers';
    final String explorer = 'Explorers';

  // List of onboarding questions with options
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is your favorite type of communication activity?',
      'options': [
        {'text': 'Public Speaking', 'value': 'Public Speaking'},
        {'text': 'Group Discussions', 'value': 'Group Discussions'},
        {'text': 'One-on-One Conversations', 'value': 'One-on-One Conversations'},
        {'text': 'Writing', 'value': 'Writing'},
      ],
    },
    {
      'question': 'What is your preferred way of learning new skills?',
      'options': [
        {'text': 'Watching Videos', 'value': 'Watching Videos'},
        {'text': 'Reading Articles', 'value': 'Reading Articles'},
        {'text': 'Participating in Workshops', 'value': 'Participating in Workshops'},
        {'text': 'Practicing Alone', 'value': 'Practicing Alone'},
      ],
    },
    {
      'question': 'What topics are you most interested in?',
      'options': [
        {'text': 'Technology', 'value': 'Technology'},
        {'text': 'Art', 'value': 'Art'},
        {'text': 'Science', 'value': 'Science'},
        {'text': 'Sports', 'value': 'Sports'},
        {'text': 'Philosophy', 'value': 'Philosophy'},
      ],
    },
  ];

  int currentQuestionIndex = 0; // Track the current question index
  List<String> userAnswers = []; // Store user answers

  // Function to handle the "Next" button
  void nextQuestion(String answer) async {
    setState(() {
      userAnswers.add(answer); // Add the users answer to the list
    });

    // Check if there are more questions
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++; // Move to the next question
      });
    } else {
      // If all questions are answered, assign a team and navigate
      String team = assignTeam(userAnswers);
      _AddUsertoTeamCollections(team);
      if (team == 'The Explorers') {
        // If the user is assigned to "The Explorers," send them to the Discover page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DiscoverPage(),
          ),
        );
      } else {
        // Otherwise, send them to the HomeScreen with their assigned team
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(team: team),
          ),
        );
      }
    }
  }

  // Function to assign a team based on user answers
  String assignTeam(List<String> answers) {
    String communicationPreference = answers[0];
    String learningPreference = answers[1];
    String interest = answers[2];

    // Define team assignment rules
    final Map<List<String>, String> teamRules = {
      ['Public Speaking', 'Participating in Workshops', 'Technology']: 'The Innovators',
      ['Group Discussions', 'Watching Videos', 'Art']: 'The Creatives',
      ['One-on-One Conversations', 'Reading Articles', 'Science']: 'The Thinkers',
      ['Writing', 'Practicing Alone', 'Philosophy']: 'The Philosophers',
      ['Public Speaking', 'Participating in Workshops', 'Sports']: 'The Champions',
    };

    // Check if the user's answers match any rule
    for (var rule in teamRules.entries) {
      if (rule.key[0] == communicationPreference &&
          rule.key[1] == learningPreference &&
          rule.key[2] == interest) {
        return rule.value; // Return the corresponding team
      }
    }

    // Default team for unmatched combinations
    return 'The Explorers';
  }

  // ignore: non_constant_identifier_names
  void _AddUsertoTeamCollections(String team) {
    

    switch (team){
      case 'The Champions':
        FirebaseFunctions().addUsertoTeamCollection(champion);
        FirebaseFunctions().addUsertoTeam(champion);
        break;
      case 'The Creatives':
        FirebaseFunctions().addUsertoTeamCollection(creative);
        FirebaseFunctions().addUsertoTeam(creative);

        break;
      case 'The Innovators':
        FirebaseFunctions().addUsertoTeamCollection(innovator);
        FirebaseFunctions().addUsertoTeam(innovator);
        break;
      case 'The Philosophers':
        FirebaseFunctions().addUsertoTeamCollection(philosopher);
        FirebaseFunctions().addUsertoTeam(philosopher);
        break;
      case 'The Thinkers':
        FirebaseFunctions().addUsertoTeamCollection(thinker);
        FirebaseFunctions().addUsertoTeam(thinker);
        break;
      case 'The Explorers':
        FirebaseFunctions().addUsertoTeamCollection(explorer);
        FirebaseFunctions().addUsertoTeam(explorer);
        break;
      }
    
    
  }

  // Function to skip onboarding and go to the Discover page
  void skipOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DiscoverPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Onboarding'),
        actions: [
          // Skip button in the app bar
          TextButton(
            onPressed: skipOnboarding,
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the current question
            Text(
              questions[currentQuestionIndex]['question'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Display the options for the current question
            Expanded(
              child: Column(
                children: questions[currentQuestionIndex]['options']
                    .map<Widget>((option) {
                  return GestureDetector(
                    onTap: () => nextQuestion(option['value']),
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