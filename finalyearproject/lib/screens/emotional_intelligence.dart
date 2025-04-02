import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'Home.dart';

class EmotionalIntelligencePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EmotionalIntelligence',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> options = [
    {'title': 'Introduction', 'route': YouTubeListScreenemo()},
    {'title': 'real time question', 'route': RealTimeQuestion()},
    {'title': 'real time Audio', 'route': RealTimeAudio()},
    {'title': 'real time Emotion', 'route': EmotionListPage()},

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainContent(),
              ),
            );
          },
        ),
        title: Center(
          child: Text(
            'Emotional Intelligence Page',
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

class RealTimeQuestion extends StatefulWidget {
  const RealTimeQuestion({Key? key}) : super(key: key);

  @override
  _RealTimeQuestionState createState() => _RealTimeQuestionState();
}

class _RealTimeQuestionState extends State<RealTimeQuestion> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedOption;

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "Your friend looks upset after a tough day at work. What do you say?",
      "options": [
        "I’m here if you want to talk about it.",
        "It happens to everyone, just move on.",
        "You should have handled it better.",
      ],
      "answer": 0
    },
    {
      "question": "A new teammate is nervous before their first presentation. How do you respond?",
      "options": [
        "You’ll probably mess up, but it’s fine.",
        "I believe in you! Want to practice together?",
        "It’s just a small presentation, don’t overthink it.",
      ],
      "answer": 1
    },
    {
      "question": "A team member misses a deadline due to personal issues. What do you say?",
      "options": [
        "Deadlines are important! You should have planned better.",
        "I understand things happen. Let me know how I can help.",
        "This isn’t an excuse. Everyone has problems.",
      ],
      "answer": 1
    },
    {
      "question": "A child is sad because they lost a school competition. How do you react?",
      "options": [
        "You’ll win next time, don’t be sad.",
        "I know it hurts, but I’m proud of your effort.",
        "It’s just a game, stop crying.",
      ],
      "answer": 1
    },
    {
      "question": "Your friend is overwhelmed with personal problems. What do you do?",
      "options": [
        "Everyone has problems, don’t be dramatic.",
        "I’m here for you. Do you want to talk about it?",
        "You should just focus on the positive.",
      ],
      "answer": 1
    },
    {
      "question": "A customer is frustrated about a delayed order. What do you say?",
      "options": [
        "It’s not my fault, you should be patient.",
        "I understand your frustration. Let me check how I can help.",
        "You’re overreacting, it’s just a small delay.",
      ],
      "answer": 1
    },
    {
      "question": "Your friend is going through a breakup. How do you comfort them?",
      "options": [
        "You’ll find someone else, don’t dwell on it.",
        "Breakups are painful. I’m here if you need support.",
        "They weren’t good for you anyway.",
      ],
      "answer": 1
    },
    {
      "question": "A classmate tells you they are struggling to understand a topic. What’s your response?",
      "options": [
        "That’s easy! How do you not get it?",
        "I struggled with that too. Let’s go through it together.",
        "Just watch some YouTube videos, you’ll figure it out.",
      ],
      "answer": 1
    },
    {
      "question": "A co-worker recently lost a loved one. How do you support them?",
      "options": [
        "At least they lived a long life.",
        "I’m so sorry for your loss. Let me know if you need anything.",
        "You should try to get over it and move on.",
      ],
      "answer": 1
    },
    {
      "question": "A parent expresses how exhausted they are from handling their kids. What do you say?",
      "options": [
        "You signed up for this, deal with it.",
        "That sounds really tough. Is there anything I can do to help?",
        "It’s not a big deal, parenting is supposed to be hard.",
      ],
      "answer": 1
    },
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


class  RealTimeAudio extends StatelessWidget {
  final List<Map<String, dynamic>> questions = [
    {
      "audioPath": "Audio/Audio6.mp3",
      "question": "How does the speaker feel in the audio?",
      "correctAnswer": "Happy"
    },
    {
      "audioPath": "Audio/Audio7.mp3",
      "question": "What emotion is expressed in this story?",
      "correctAnswer": "Sad"
    },
    {
      "audioPath": "Audio/Audio8.mp3",
      "question": "Which feeling best describes the speaker?",
      "correctAnswer": "Angry"
    },
    {
      "audioPath": "Audio/Audio9.mp3",
      "question": "What is the main emotion in the audio?",
      "correctAnswer": "Excited"
    },
    {
      "audioPath": "Audio/Audio10.mp3",
      "question": "What is the main emotion in the audio?",
      "correctAnswer": "Nervous"
    },
    {
      "audioPath": "Audio/Audio11.mp3",
      "question": "What is the main emotion in the audio?",
      "correctAnswer": "Relieved"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme for premium look
      appBar: AppBar(
        title: Text(
          "Listening Skill Test",
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
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return FadeInUp(
              duration: Duration(milliseconds: 400 + (index * 100)),
              child: Card(
                color: Colors.grey.shade900,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  leading: Icon(Icons.headset, color: Colors.purpleAccent, size: 40),
                  title: Text(
                    "Audio ${index + 1}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    questions[index]["question"],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  trailing: Icon(Icons.play_circle_fill, color: Colors.deepPurpleAccent, size: 40),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListeningSkill(
                          audioPath: questions[index]["audioPath"],
                          question: questions[index]["question"],
                          correctAnswer: questions[index]["correctAnswer"],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ListeningSkill extends StatefulWidget {
  final String audioPath;
  final String question;
  final String correctAnswer;

  ListeningSkill({
    required this.audioPath,
    required this.question,
    required this.correctAnswer,
  });

  @override
  _ListeningSkillState createState() => _ListeningSkillState();
}

class _ListeningSkillState extends State<ListeningSkill> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? selectedAnswer;

  final List<String> emotions = [
    "Sad",
    "Happy",
    "Angry",
    "Excited",
    "Nervous",
    "Relieved"
  ];

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  void _toggleMusic() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(widget.audioPath)); // Ensure correct path
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _seekAudio(Duration position) {
    _audioPlayer.seek(position);
  }

  void _checkAnswer() {
    if (selectedAnswer == null) {
      _showAlert("Alert", "Please select an emotion.");
      return;
    }

    if (selectedAnswer == widget.correctAnswer) {
      _showAlert("Correct!", "Your answer is correct.");
    } else {
      _showAlert("Incorrect", "The correct answer was '${widget.correctAnswer}'.");
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Listening Skill",style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
        ), backgroundColor: Colors.deepPurpleAccent,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Play/Pause Button
            ElevatedButton(
              onPressed: _toggleMusic,
              child: Text(isPlaying ? "Pause Audio" : "Play Audio"),
            ),
            SizedBox(height: 10),

            // Audio Progress Bar
            Slider(
              min: 0,
              max: _duration.inSeconds.toDouble(),
              value: _position.inSeconds.toDouble(),
              onChanged: (value) {
                _seekAudio(Duration(seconds: value.toInt()));
              },
            ),

            // Duration Text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_position)),
                Text(_formatDuration(_duration)),
              ],
            ),

            SizedBox(height: 20),

            // Question
            Text(
              widget.question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Emotion Choices
            Column(
              children: emotions.map((emotion) {
                return RadioListTile<String>(
                  title: Text(emotion),
                  value: emotion,
                  groupValue: selectedAnswer,
                  onChanged: (value) {
                    setState(() {
                      selectedAnswer = value;
                    });
                  },
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // Check Answer Button
            ElevatedButton(
              onPressed: _checkAnswer,
              child: Text("Submit Answer"),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}

class EmotionListPage extends StatelessWidget {
  final List<Map<String, dynamic>> emotionsList = [
    {
      "gifPath": "assets/images/happy.json",
      "question": "How does the character in the animation feel?",
      "correctAnswer": "Happy"
    },
    {
      "gifPath": "assets/images/crying.json",
      "question": "What emotion is being expressed?",
      "correctAnswer": "Crying"
    },
    {
      "gifPath": "assets/images/angry.json",
      "question": "What is the emotion of the character?",
      "correctAnswer": "Angry"
    },
    {
      "gifPath": "assets/images/confused.json",
      "question": "How is the character feeling?",
      "correctAnswer": "Confused"
    },
    {
      "gifPath": "assets/images/excitment.json",
      "question": "What best describes the animation?",
      "correctAnswer": "Excited"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark premium theme
      appBar: AppBar(
        title: Text(
          "Emotion Recognition",
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
          itemCount: emotionsList.length,
          itemBuilder: (context, index) {
            return FadeInUp(
              duration: Duration(milliseconds: 400 + (index * 100)),
              child: Card(
                color: Colors.grey.shade900,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  leading: Icon(Icons.face, color: Colors.purpleAccent, size: 40),
                  title: Text(
                    "Animation ${index + 1}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    emotionsList[index]["question"],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  trailing: Icon(Icons.play_circle_fill, color: Colors.deepPurpleAccent, size: 40),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmotionRecognition(
                          gifPath: emotionsList[index]["gifPath"],
                          question: emotionsList[index]["question"],
                          correctAnswer: emotionsList[index]["correctAnswer"],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EmotionRecognition extends StatefulWidget {
  final String gifPath;
  final String question;
  final String correctAnswer;

  EmotionRecognition({
    required this.gifPath,
    required this.question,
    required this.correctAnswer,
  });

  @override
  _EmotionRecognitionState createState() => _EmotionRecognitionState();
}

class _EmotionRecognitionState extends State<EmotionRecognition> {
  String? selectedAnswer;

  final List<String> emotions = [
    "Happy",
    "Crying",
    "Angry",
    "Confused",
    "Excited",

  ];

  void _checkAnswer() {
    if (selectedAnswer == null) {
      _showAlert("Alert", "Please select an emotion.");
      return;
    }

    if (selectedAnswer == widget.correctAnswer) {
      _showAlert("Correct!", "Your answer is correct.");
    } else {
      _showAlert("Incorrect", "The correct answer was '${widget.correctAnswer}'.");
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Emotion Recognition",style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
        ), backgroundColor: Colors.deepPurpleAccent,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // GIF Animation
            Lottie.asset(widget.gifPath, width: 200, height: 200),

            SizedBox(height: 20),

            // Question
            Text(
              widget.question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Emotion Choices
            Column(
              children: emotions.map((emotion) {
                return RadioListTile<String>(
                  title: Text(emotion),
                  value: emotion,
                  groupValue: selectedAnswer,
                  onChanged: (value) {
                    setState(() {
                      selectedAnswer = value;
                    });
                  },
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // Check Answer Button
            ElevatedButton(
              onPressed: _checkAnswer,
              child: Text("Submit Answer"),
            ),
          ],
        ),
      ),
    );
  }
}



class YouTubeListScreenemo extends StatelessWidget {
  final List<String> _youtubeVideos = [
    'https://youtu.be/LgUCyWhJf6s?si=0DyghrL7HXhi60YF',
  ];

  void _openYouTubeVideo(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YouTubePlayerScreenemo(youtubeUrl: url),
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
class YouTubePlayerScreenemo extends StatefulWidget {
  final String youtubeUrl;

  YouTubePlayerScreenemo({required this.youtubeUrl});

  @override
  _YouTubePlayerScreenStateemo createState() => _YouTubePlayerScreenStateemo();
}

class _YouTubePlayerScreenStateemo extends State<YouTubePlayerScreenemo> {
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