import 'package:flutter/material.dart';
import '../Firebase/firebasefunctions.dart';
import 'home.dart';
import 'discover.dart';

class NewUserOnboarding extends StatefulWidget {
  const NewUserOnboarding({super.key});

  @override
  _NewUserOnboardingState createState() => _NewUserOnboardingState();
}

class _NewUserOnboardingState extends State<NewUserOnboarding> {
  final String champion = 'The Champions';
  final String creative = 'The Creatives';
  final String innovator = 'The Innovators';
  final String philosopher = 'The Philosophers';
  final String thinker = 'The Thinkers';
  final String explorer = 'The Explorers';

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

  int currentQuestionIndex = 0;
  List<String> userAnswers = [];

  // Define team rules as a list of maps
  final List<Map<String, dynamic>> teamRules = [
    {
      'answers': ['Public Speaking', 'Participating in Workshops', 'Technology'],
      'team': 'The Innovators',
    },
    {
      'answers': ['Group Discussions', 'Watching Videos', 'Art'],
      'team': 'The Creatives',
    },
    {
      'answers': ['One-on-One Conversations', 'Reading Articles', 'Science'],
      'team': 'The Thinkers',
    },
    {
      'answers': ['Writing', 'Practicing Alone', 'Philosophy'],
      'team': 'The Philosophers',
    },
    {
      'answers': ['Public Speaking', 'Participating in Workshops', 'Sports'],
      'team': 'The Champions',
    },
  ];

  // Computes how many answers match a given rule
  int _matchScore(List<String> ruleAnswers, List<String> userAnswers) {
    int score = 0;
    for (var answer in ruleAnswers) {
      if (userAnswers.contains(answer)) {
        score++;
      }
    }
    return score;
  }

  // Returns the top two recommended teams based on match scores
  List<String> getRecommendedTeams(List<String> userAnswers) {
    List<Map<String, dynamic>> scoredRules = [];
    for (var rule in teamRules) {
      int score = _matchScore(List<String>.from(rule['answers']), userAnswers);
      scoredRules.add({'team': rule['team'], 'score': score});
    }
    // Sort descending by score
    scoredRules.sort((a, b) => b['score'].compareTo(a['score']));
    List<String> recommendations = [];
    for (var rule in scoredRules) {
      if (rule['score'] > 0) {
        recommendations.add(rule['team']);
      }
      if (recommendations.length == 2) break;
    }
    // If we didn't find two matches, add a default team as needed.
    if (recommendations.isEmpty) {
      recommendations.add(explorer);
    } else if (recommendations.length == 1) {
      recommendations.add(explorer);
    }
    return recommendations;
  }

  // For onboarding, assign a team based on an exact match if available
  String assignTeam(List<String> answers) {
    String communicationPreference = answers[0];
    String learningPreference = answers[1];
    String interest = answers[2];

    for (var rule in teamRules) {
      List<String> ruleAnswers = List<String>.from(rule['answers']);
      if (ruleAnswers[0] == communicationPreference &&
          ruleAnswers[1] == learningPreference &&
          ruleAnswers[2] == interest) {
        return rule['team'];
      }
    }
    return explorer;
  }

  // Add user to team collections
  Future<void> _addUserToTeamCollections(String team) async {
    try {
      switch (team) {
        case 'The Champions':
          await FirebaseFunctions().addUsertoTeamCollection('The Champions');
          await FirebaseFunctions().addUsertoTeam('The Champions');
          break;
        case 'The Creatives':
          await FirebaseFunctions().addUsertoTeamCollection('The Creatives');
          await FirebaseFunctions().addUsertoTeam('The Creatives');
          break;
        case 'The Innovators':
          await FirebaseFunctions().addUsertoTeamCollection('The Innovators');
          await FirebaseFunctions().addUsertoTeam('The Innovators');
          break;
        case 'The Philosophers':
          await FirebaseFunctions().addUsertoTeamCollection('The Philosophers');
          await FirebaseFunctions().addUsertoTeam('The Philosophers');
          break;
        case 'The Thinkers':
          await FirebaseFunctions().addUsertoTeamCollection('The Thinkers');
          await FirebaseFunctions().addUsertoTeam('The Thinkers');
          break;
        case 'The Explorers':
          await FirebaseFunctions().addUsertoTeamCollection('The Explorers');
          await FirebaseFunctions().addUsertoTeam('The Explorers');
          break;
      }
    } catch (e) {
      print('Error adding user to team: $e');
      throw Exception('Failed to add user to team: $e');
    }
  }

  void skipOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DiscoverPage(teamname: ''),
      ),
    );
  }

  void nextQuestion(String answer) async {
    setState(() {
      userAnswers.add(answer);
    });

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // After all questions,recommendations and assign a team
      List<String> recommendedTeams = getRecommendedTeams(userAnswers);
      String assignedTeam = assignTeam(userAnswers);
      await _addUserToTeamCollections(assignedTeam);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DiscoverPage(
            teamname: assignedTeam,
            recommendedTeams: recommendedTeams,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Onboarding'),
        actions: [
          TextButton(
            onPressed: skipOnboarding,
            child: const Text('Skip', style: TextStyle(color: Colors.white)),
          ),
        ],
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
