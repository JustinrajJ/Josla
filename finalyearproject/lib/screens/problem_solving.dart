import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:math';

import 'Home.dart';




class ProblemSolvingPage extends StatelessWidget {
  final List<Map<String, dynamic>> options = [
    {'title': 'Problem Solving', 'route': YouTubeListScreen()},
    {'title': 'RootCauseQuizApp', 'route': RootCauseQuizApp()},
    {'title': 'Suduko Game', 'route': SudokuApp()},
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
    },),
        title: Center(
          child: Text(
            'Problem Solving',
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
    'https://youtu.be/uqhOnXOiwOg?si=7jzN3EJy8k_ymfdL',
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
      appBar: AppBar(
        title: Text(
          'Problem Solving Videos',
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: _youtubeVideos.length,
          itemBuilder: (context, index) {
            return FadeInUp(
              duration: Duration(milliseconds: 500 + (index * 100)),
              child: Card(
                color: Colors.white.withOpacity(0.1),
                elevation: 6,
                shadowColor: Colors.black.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  leading: Icon(Icons.play_circle_fill, color: Colors.red, size: 40),
                  title: Text(
                    'Problem Solving ${index + 1}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70),
                  onTap: () => _openYouTubeVideo(context, _youtubeVideos[index]),
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




class SudokuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SudokuScreen(),
    );
  }
}

class SudokuScreen extends StatefulWidget {
  @override
  _SudokuScreenState createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  List<List<int>> grid = List.generate(9, (_) => List.generate(9, (_) => 0));

  @override
  void initState() {
    super.initState();
    generatePuzzle();
  }

  void generatePuzzle() {
    Random random = Random();
    for (int i = 0; i < 20; i++) {
      int row = random.nextInt(9);
      int col = random.nextInt(9);
      int num = random.nextInt(9) + 1;
      if (isValid(row, col, num)) {
        grid[row][col] = num;
      }
    }
    setState(() {});
  }

  bool isValid(int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (grid[row][i] == num || grid[i][col] == num) {
        return false;
      }
    }
    int boxX = (row ~/ 3) * 3;
    int boxY = (col ~/ 3) * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[boxX + i][boxY + j] == num) {
          return false;
        }
      }
    }
    return true;
  }

  void updateCell(int row, int col, int num) {
    if (grid[row][col] == 0 && isValid(row, col, num)) {
      setState(() {
        grid[row][col] = num;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Premium Dark Theme
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProblemSolvingPage(),
              ),
            );
          },
        ),
        title: Text(
          "Sudoku Game",
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
      body: Stack(
        children: [
          // Fantasy Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 9,
                      childAspectRatio: 1,
                    ),
                    itemCount: 81,
                    itemBuilder: (context, index) {
                      int row = index ~/ 9;
                      int col = index % 9;
                      return FadeIn(
                        duration: Duration(milliseconds: 300 + (index % 9) * 50),
                        child: GestureDetector(
                          onTap: () => _showNumberPicker(context, row, col),
                          child: Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.purpleAccent, width: 1.5),
                              color: grid[row][col] == 0
                                  ? Colors.black.withOpacity(0.8)
                                  : Colors.deepPurpleAccent.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purpleAccent.withOpacity(0.3),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                grid[row][col] == 0 ? "" : grid[row][col].toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.purpleAccent,
                                      blurRadius: 5,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNumberPicker(BuildContext context, int row, int col) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          title: Text(
            "Pick a Number",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(9, (index) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(12),
                ),
                onPressed: () {
                  updateCell(row, col, index + 1);
                  Navigator.pop(context);
                },
                child: Text(
                  "${index + 1}",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}


class RootCauseQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "An online store's sales have dropped by 30%. What is the root cause?",
      "options": [
        "Customers find products expensive",
        "Website has slow loading speed",
        "Competitor launched a better discount campaign"
      ],
      "answerIndex": 2
    },
    {
      "question": "Employees are missing deadlines frequently. What is the root cause?",
      "options": [
        "Employees lack motivation",
        "Project deadlines are unrealistic",
        "Poor communication between teams"
      ],
      "answerIndex": 1
    },
    {
      "question": "A mobile app has seen a 50% drop in daily users. What could be the root cause?",
      "options": [
        "Too many ads in the app",
        "App crashes frequently",
        "A new competitor app launched"
      ],
      "answerIndex": 1
    },
    {
      "question": "Many employees are taking frequent sick leaves. What is the possible root cause?",
      "options": [
        "Poor working conditions in the office",
        "Lack of work-life balance",
        "Employees are disengaged"
      ],
      "answerIndex": 0
    },
    {
      "question": "A product on an online marketplace is receiving low ratings. What is the likely root cause?",
      "options": [
        "Poor customer service",
        "Product quality issues",
        "Price is too high"
      ],
      "answerIndex": 1
    },
    {
      "question": "A website that was ranking on the first page of Google has dropped to page 5. What is the possible root cause?",
      "options": [
        "Website content is outdated",
        "Competitor websites improved their SEO",
        "Too many ads on the website"
      ],
      "answerIndex": 0
    },
    {
      "question": "The number of car accidents in a city has increased by 20%. What could be the root cause?",
      "options": [
        "Poor road conditions",
        "Increase in number of new drivers",
        "Lack of traffic rules enforcement"
      ],
      "answerIndex": 2
    },
    {
      "question": "A company’s inventory records show 1,000 items, but only 850 are physically present. What is the root cause?",
      "options": [
        "Theft or fraud",
        "Software error in inventory system",
        "Items were misplaced during shipping"
      ],
      "answerIndex": 0
    },
    {
      "question": "A school has seen a decline in students’ exam performance. What could be the root cause?",
      "options": [
        "Teachers are not skilled enough",
        "Students are not getting proper study materials",
        "Students are spending more time on social media"
      ],
      "answerIndex": 1
    },
    {
      "question": "Customers are complaining about delayed deliveries. What is the most likely root cause?",
      "options": [
        "Poor weather conditions",
        "Warehouse staff shortage",
        "Delivery company mismanagement"
      ],
      "answerIndex": 2
    }
  ];

  void _checkAnswer(int selectedIndex) {
    if (selectedIndex == _questions[_currentQuestionIndex]['answerIndex']) {
      _score++;
      _showFeedback(true);
    } else {
      _showFeedback(false);
    }
  }

  void _showFeedback(bool isCorrect) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isCorrect ? "Correct!" : "Wrong Answer"),
          content: Text(isCorrect
              ? "Well done! That's the right answer."
              : "Oops! Try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _nextQuestion();
              },
              child: Text("Next"),
            )
          ],
        );
      },
    );
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _showFinalScore();
    }
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Quiz Completed!",),
          content: Text("Your Score: $_score/${_questions.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentQuestionIndex = 0;
                  _score = 0;
                });
              },
              child: Text("Restart Quiz"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProblemSolvingPage(),
              ),
            );
          },
        ),
        title: Text(
          "Root Cause Analysis Quiz",
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
      body: Stack(
        children: [
          // Fantasy Background

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Question Container
                FadeInUp(
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.purpleAccent, width: 2),
                    ),
                    child: Text(
                      _questions[_currentQuestionIndex]['question'],
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ...List.generate(3, (index) {
                  return FadeInUp(
                    duration: Duration(milliseconds: 600 + (index * 100)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ElevatedButton(
                        onPressed: () => _checkAnswer(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Colors.purple.withOpacity(0.6),
                          elevation: 6,
                        ),
                        child: Text(
                          _questions[_currentQuestionIndex]['options'][index],
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
