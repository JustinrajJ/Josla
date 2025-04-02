import 'package:flutter/material.dart';

class AssessmentPage extends StatefulWidget {
  final VoidCallback onComplete;

  const AssessmentPage({required this.onComplete, Key? key}) : super(key: key);

  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedOption;

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "How do you ensure clarity when explaining complex ideas to others?",
      "options": [
        "Use technical jargon and assume everyone understands",
        "Break the information into simple, digestible points and encourage questions",
        "Speak quickly and avoid pausing",
        "Focus on one part of the idea and ignore the rest"
      ],
      "answer": 1
    },
    {
      "question": "When you give feedback to a colleague, what is your primary focus?",
      "options": [
        "Highlighting only their mistakes",
        "Providing constructive feedback in a way that helps them improve",
        "Ignoring the positives and focusing only on the negatives",
        "Speaking as quickly as possible to avoid an awkward conversation"
      ],
      "answer": 1
    },
    {
      "question": "In a meeting, you notice that a colleague is not participating. How do you address this?",
      "options": [
        "Ignore them and focus on the active participants",
        "Encourage them politely to share their thoughts, creating a comfortable environment",
        "Ask them why they aren’t participating in front of the group",
        "Keep the conversation going without acknowledging their silence"
      ],
      "answer": 1
    },
    {
      "question": "When managing a team, how do you handle a situation where one member is consistently underperforming?",
      "options": [
        "Ignore the issue and hope it resolves itself",
        "Provide clear feedback, offer support, and set improvement goals together",
        "Give them more tasks to see if they improve",
        "Publicly reprimand them to set an example for the rest"
      ],
      "answer": 1
    },
    {
      "question": "As a team leader, what’s the best way to handle differing opinions within the group?",
      "options": [
        "Avoid confrontation and let the disagreement go unresolved",
        "Listen to all perspectives and find a compromise that benefits the team",
        "Push your own opinion until everyone agrees with you",
        "Ignore the differences and enforce a decision unilaterally"
      ],
      "answer": 1
    },
    {
      "question": "How do you ensure that your team stays motivated and productive over the long term?",
      "options": [
        "Reward them with material incentives only",
        "Provide regular feedback, set clear goals, and recognize achievements",
        "Focus only on individual performance, not teamwork",
        "Let them figure things out on their own without intervention"
      ],
      "answer": 1
    },
    {
      "question": "When faced with a difficult problem at work, what is your first step?",
      "options": [
        "Start working on the solution immediately without analyzing the issue",
        "Gather all the necessary information to understand the problem thoroughly",
        "Ask others to solve it for you",
        "Procrastinate and wait for someone else to find a solution"
      ],
      "answer": 1
    },
    {
      "question": "If your first solution to a problem doesn’t work, what do you do next?",
      "options": [
        "Give up and stop trying",
        "Analyze what went wrong, identify other potential solutions, and try again",
        "Blame others for not supporting your initial solution",
        "Stick with the original solution and hope it eventually works"
      ],
      "answer": 1
    },
    {
      "question": "When solving a problem, how do you ensure that you are making the best decision?",
      "options": [
        "Only focus on the quickest and easiest solution",
        "Consider all possible options, weigh the pros and cons, and make an informed decision",
        "Avoid any solution that involves change or risk",
        "Always rely on your intuition without considering the data"
      ],
      "answer": 1
    },
    {
      "question": "How do you contribute to the success of a team project?",
      "options": [
        "Focus only on completing your own tasks and ignore others",
        "Collaborate by sharing ideas, supporting teammates, and completing your own tasks on time",
        "Let others take the lead while you do the bare minimum",
        "Compete with other team members to prove you are the best"
      ],
      "answer": 1
    },

    {
      "question": "In a team environment, what is the most important aspect to ensure smooth collaboration?",
      "options": [
        "Focusing only on your individual goals",
        "Clear communication, mutual respect, and flexibility",
        "Being the person who makes the final decision",
        "Avoiding any conflicts, even if they are constructive"
      ],
      "answer": 1
    },
    {
      "question": "If you have a conflict with a teammate, what is the best way to resolve it?",
      "options": [
        "Avoid speaking to them until the issue resolves itself",
        "Discuss the issue calmly, listen to their perspective, and find a compromise",
        "Ignore their opinions and stick to your point of view",
        "Publicly confront them in front of the team"
      ],
      "answer": 1
    },
    {
      "question": "When dealing with a stressful situation, what is the most effective way to stay composed?",
      "options": [
        "Ignore your emotions and push through the stress",
        "Acknowledge your feelings, take a step back, and calmly assess the situation",
        "React impulsively without considering the consequences",
        "Avoid the situation completely"
      ],
      "answer": 1
    },
    {
      "question": "How do you handle feedback that you may not agree with?",
      "options": [
        "Defend yourself immediately without considering the feedback",
        "Listen carefully, reflect on the feedback, and see how you can use it to improve",
        "Ignore the feedback and continue with your usual approach",
        "Become defensive and argue with the person giving the feedback"
      ],
      "answer": 1
    },
    {
      "question": "How do you recognize when a team member is feeling overwhelmed or stressed?",
      "options": [
        "Ignore their feelings and focus only on the work at hand",
        "Observe their behavior for signs of stress, such as changes in attitude or productivity, and offer support",
        "Assume that everyone is handling their work fine without checking in",
        "Criticize them for not managing their work better"
      ],
      "answer": 1
    },
    {
      "question": "Can you share a time when you motivated yourself through a challenging period, and what did you learn from it?",
      "options": [
        "I relied on support from others to get through it",
        "I took on new challenges to distract myself from the difficulty",
        "I reminded myself of my long-term goals and the bigger picture",
        "I ignored the challenge and hoped it would pass"
      ],
      "answer": 2
    },
    {
      "question": "What did you learn from a situation where things didn’t go according to plan?",
      "options": [
        "I learned to avoid taking risks in the future",
        "I learned the importance of preparation and flexibility",
        "I learned that failure isn’t an option",
        "I learned that plans are never important and flexibility is key"
      ],
      "answer": 1
    },
    {
      "question": "How do you maintain a balance between your work responsibilities and personal life?",
      "options": [
        "I focus on work only and leave personal matters for later",
        "I carefully manage my time to ensure both aspects are balanced",
        "I prioritize personal life over work when things get stressful",
        "I struggle with balancing work and personal life but am trying to improve"
      ],
      "answer": 1
    },
    {
      "question": "If you could lead any type of project, what would it be, and how would you go about leading it?",
      "options": [
        "A highly structured project with clear tasks and deadlines",
        "A creative, open-ended project that encourages innovation",
        "A project where I manage the team’s day-to-day activities",
        "A project that requires detailed research and technical skills"
      ],
      "answer": 1
    },
    {
      "question": "Describe a situation where you introduced a creative solution that improved a process or outcome.",
      "options": [
        "I followed existing procedures to achieve the same outcome",
        "I suggested a small improvement that made a noticeable difference",
        "I implemented a major change that transformed the way we work",
        "I didn’t have the chance to contribute any new ideas"
      ],
      "answer": 1
    }
  ];

  void _nextQuestion() {
    if (_selectedOption == _questions[_currentQuestionIndex]['answer']) {
      _score++;
    }

    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _selectedOption = null; // Reset for next question
      } else {
        _showResults(); // Show results after the last question
      }
    });
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Assessment Complete"),
          content: Text("Your score is $_score/${_questions.length}."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                widget.onComplete(); // Notify parent and navigate to homepage
              },
              child: Text("Go to Homepage"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _confirmExit() async {
    return (await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Exit Assessment"),
          content: Text("Are you sure you want to exit the assessment? Your progress will be lost."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Return false if user cancels
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true), // Return true if user confirms
              child: Text("Exit"),
            ),
          ],
        );
      },
    )) ??
        false; // Default to false if dialog result is null
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmExit,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Assessment"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _confirmExit()) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / _questions.length,
              ),
              SizedBox(height: 10),
              Text(
                "Question ${_currentQuestionIndex + 1} of ${_questions.length}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              Text(
                _questions[_currentQuestionIndex]['question'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ..._questions[_currentQuestionIndex]['options']
                  .asMap()
                  .entries
                  .map((entry) {
                int index = entry.key;
                String option = entry.value;
                return RadioListTile<int>(
                  value: index,
                  groupValue: _selectedOption,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                  title: Text(option),
                );
              }).toList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectedOption != null
                    ? _nextQuestion
                    : null, // Disable button until an option is selected
                child: Text(
                  _currentQuestionIndex < _questions.length - 1
                      ? "Next"
                      : "Finish",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
