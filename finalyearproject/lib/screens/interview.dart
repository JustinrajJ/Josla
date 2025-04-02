import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



class InterviewPage extends StatelessWidget {
  final List<Map<String, dynamic>> options = [
    {'title': 'Introduction', 'route': YouTubeListScreen()},
    {'title': 'Interview', 'route': RealTimeQuestionint()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Interview Page',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            return FadeInUp(
              duration: Duration(milliseconds: 400 * (index + 1)),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => options[index]['route'],
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 8,
                  color: Colors.white.withOpacity(0.1),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    title: Text(
                      options[index]['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

class YouTubeListScreen extends StatelessWidget {
  final List<String> _youtubeVideos = [
    'https://youtu.be/sAaEWwJ1bDI?si=tTR3tidZZCYEVaor',
  ];

  void _openYouTubeVideo(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YouTubePlayerScreen(youtubeUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Premium dark theme
      appBar: AppBar(
        title: Text(
          "Introduction",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: _youtubeVideos.length,
          itemBuilder: (context, index) {
            return FadeInUp(
              duration: Duration(milliseconds: 400 + (index * 100)),
              child: Card(
                color: Colors.grey.shade900,
                elevation: 6,
                shadowColor: Colors.redAccent.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent.withOpacity(0.2),
                    ),
                    child: Icon(Icons.play_circle_fill, color: Colors.redAccent, size: 40),
                  ),
                  title: Text(
                    "Demo ${index + 1}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () => _openYouTubeVideo(context, _youtubeVideos[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// YouTube Player Page
class YouTubePlayerScreen extends StatefulWidget {
  final String youtubeUrl;

  YouTubePlayerScreen({required this.youtubeUrl});

  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Player', style: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.5),),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}


class RealTimeQuestionint extends StatefulWidget {
  const RealTimeQuestionint({Key? key}) : super(key: key);

  @override
  _RealTimeQuestionStateint createState() => _RealTimeQuestionStateint();
}

class _RealTimeQuestionStateint extends State<RealTimeQuestionint> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedOption;

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "Tell me about yourself.",
      "options": [
        "I am hardworking and need a job.",
        "I have relevant skills and experience that align with this role.",
        "I don’t know what to say."
      ],
      "answer": 1
    },
    {
      "question": "What are your strengths?",
      "options": [
        "I work well under pressure and adapt quickly.",
        "I don’t have any strengths.",
        "I never make mistakes."
      ],
      "answer": 0
    },
    {
      "question": "What are your weaknesses?",
      "options": [
        "I have no weaknesses.",
        "I sometimes focus too much on details, but I’m working on improving efficiency.",
        "I don’t like working in teams."
      ],
      "answer": 1
    },
    {
      "question": "Why do you want to work for this company?",
      "options": [
        "Because I need a job.",
        "I admire your company’s work and want to contribute my skills to its growth.",
        "I don’t know much about your company."
      ],
      "answer": 1
    },
    {
      "question": "Where do you see yourself in five years?",
      "options": [
        "I want to grow in my career and take on more responsibilities.",
        "I don’t think about the future.",
        "I will leave this job in a year."
      ],
      "answer": 0
    },
    {
      "question": "Why should we hire you?",
      "options": [
        "Because I need this job more than others.",
        "I have the right skills and a strong work ethic.",
        "I don’t know, it’s your choice."
      ],
      "answer": 1
    },
    {
      "question": "Describe a time you faced a challenge and how you handled it.",
      "options": [
        "I gave up when it got difficult.",
        "I analyzed the situation, identified solutions, and implemented the best one.",
        "I ignored the problem and hoped it would go away."
      ],
      "answer": 1
    },
    {
      "question": "How do you handle criticism?",
      "options": [
        "I take it positively and use it for improvement.",
        "I argue with the person giving feedback.",
        "I ignore criticism completely."
      ],
      "answer": 0
    },
    {
      "question": "What motivates you?",
      "options": [
        "Opportunities to learn, grow, and contribute to meaningful work.",
        "Only money.",
        "Nothing really motivates me."
      ],
      "answer": 0
    },
    {
      "question": "How do you work under pressure?",
      "options": [
        "I stay calm, prioritize tasks, and focus on solutions.",
        "I panic and give up.",
        "I blame others for the stress."
      ],
      "answer": 0
    },

    {
      "question": "What is the difference between leadership and management?",
      "options": [
        "Leaders inspire, managers organize and execute.",
        "There is no difference.",
        "Managers do everything, and leaders do nothing."
      ],
      "answer": 0
    },
    {
      "question": "How do you handle conflicts at work?",
      "options": [
        "I listen to both sides and find a solution that works for everyone.",
        "I avoid conflicts completely.",
        "I argue until I win."
      ],
      "answer": 0
    },
    {
      "question": "How do you prioritize tasks?",
      "options": [
        "I identify urgent and important tasks first.",
        "I do tasks randomly.",
        "I wait for someone else to decide."
      ],
      "answer": 0
    },
    {
      "question": "What would you do if you made a mistake at work?",
      "options": [
        "Own up to it, correct it, and learn from it.",
        "Hide it and hope no one notices.",
        "Blame someone else."
      ],
      "answer": 0
    },
    {
      "question": "How do you adapt to change in the workplace?",
      "options": [
        "I remain flexible, learn new skills, and embrace change.",
        "I resist all changes.",
        "I ignore change and keep working the same way."
      ],
      "answer": 0
    },
    {
      "question": "What would you do if your manager gives you a task you don’t know how to complete?",
      "options": [
        "Ask for clarification, research, and try my best.",
        "Complain that it’s too difficult.",
        "Ignore the task."
      ],
      "answer": 0
    },
    {
      "question": "How do you deal with a difficult coworker?",
      "options": [
        "Remain professional, communicate clearly, and focus on work.",
        "Argue with them all the time.",
        "Ignore them completely and refuse to work together."
      ],
      "answer": 0
    },
    {
      "question": "What would you do if you disagreed with your boss?",
      "options": [
        "Respectfully share my perspective and discuss a solution.",
        "Argue and refuse to follow instructions.",
        "Just do what I want without informing them."
      ],
      "answer": 0
    },
    {
      "question": "How do you stay productive at work?",
      "options": [
        "Plan tasks, avoid distractions, and take breaks when needed.",
        "Spend time on social media all day.",
        "Procrastinate until the last minute."
      ],
      "answer": 0
    },
    {
      "question": "How do you keep learning new skills?",
      "options": [
        "Take courses, read books, and seek mentorship.",
        "I don’t need to learn anything new.",
        "Only learn when forced to."
      ],
      "answer": 0
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
          content: Text("Your score is $_score/${_questions.length}.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("OK"),
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
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm exit
              child: Text("Exit"),
            ),
          ],
        );
      },
    )) ??
        false; // Default to false if null
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmExit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Assessment",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurpleAccent, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 10,
          shadowColor: Colors.black.withOpacity(0.5),
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
              // Progress Indicator
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / _questions.length,
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade800,
                  valueColor: AlwaysStoppedAnimation(Colors.deepPurpleAccent),
                ),
              ),
              SizedBox(height: 20),

              // Question Card
              FadeInUp(
                duration: Duration(milliseconds: 500),
                child: Card(
                  color: Colors.grey.shade900,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Question ${_currentQuestionIndex + 1} of ${_questions.length}",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _questions[_currentQuestionIndex]['question'],
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purpleAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Answer Options
              ..._questions[_currentQuestionIndex]['options']
                  .asMap()
                  .entries
                  .map((entry) {
                int index = entry.key;
                String option = entry.value;

                return FadeInLeft(
                  duration: Duration(milliseconds: 400 + (index * 100)),
                  child: Card(
                    color: _selectedOption == index
                        ? Colors.deepPurpleAccent
                        : Colors.grey.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: RadioListTile<int>(
                      activeColor: Colors.white,
                      value: index,
                      groupValue: _selectedOption,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                      title: Text(
                        option,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _selectedOption == index
                              ? Colors.white
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: 30),

              // Next Button
              FadeInUp(
                duration: Duration(milliseconds: 500),
                child: ElevatedButton(
                  onPressed: _selectedOption != null ? _nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    disabledBackgroundColor: Colors.grey.shade600,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    _currentQuestionIndex < _questions.length - 1
                        ? "Next"
                        : "Finish",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}