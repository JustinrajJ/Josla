import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class Listen extends StatelessWidget {
  final List<Map<String, dynamic>> options = [
    {'title': 'Listening Class 1', 'route': ListeningSkill1()},
    {'title': 'Listening Class 2', 'route': ListeningSkill2()},
    {'title': 'Listening Class 3', 'route': ListeningSkill3()},
    {'title': 'Listening Class 4', 'route': ListeningSkill4()},
    {'title': 'Listening Class 5', 'route': ListeningSkill5()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Listening Skills',
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

class ListeningSkill1 extends StatefulWidget {
  @override
  _ListeningSkillPageState createState() => _ListeningSkillPageState();
}

class _ListeningSkillPageState extends State<ListeningSkill1> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  final TextEditingController _textController = TextEditingController();

  final String predefinedPara =
      "Rahul was a manager at a big company. One day, a client complained about a mistake in a report. "
      "Frustrated, Rahul stormed into the office and yelled at his team. The atmosphere became tense, "
      "and everyone felt demotivated. A young intern, Aisha, observed the situation. Instead of reacting with fear, "
      "she calmly approached Rahul and said, 'I understand this is stressful. Let's take a deep breath and find a solution together.' "
      "Rahul paused. He realized he had let his anger take control. Instead of blaming his team, he focused on fixing the mistake. "
      "The team felt relieved, and they worked together efficiently. Later that day, Rahul thanked Aisha. "
      "'You helped me realize that staying calm and understanding emotions can solve problems better than anger.' "
      "From that day on, Rahul practiced emotional intelligence, controlling his reactions, understanding his team's emotions, "
      "and fostering a positive work environment.";

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
      await _audioPlayer.play(AssetSource('Audio/Audio1.mp3')); // Ensure this path is correct
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _seekAudio(Duration position) {
    _audioPlayer.seek(position);
  }

  void _checkTextMatch() {
    String inputText = _textController.text.trim();

    if (inputText.isEmpty) {
      _showAlert("Alert", "Please fill in your thoughts.");
      return;
    }

    if (inputText == predefinedPara) {
      _showAlert("Eligible", "Your input is an exact match.");
    } else if (_checkSimilarity(inputText, predefinedPara)) {
      _showAlert("OK", "Your input has similar words.");
    } else {
      _showAlert("Not Eligible", "Your input does not match.");
    }
  }

  bool _checkSimilarity(String input, String original) {
    List<String> inputWords = input.toLowerCase().split(' ');
    List<String> originalWords = original.toLowerCase().split(' ');

    int matchCount = inputWords.where((word) => originalWords.contains(word)).length;
    return matchCount >= (originalWords.length * 0.6);
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
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Premium dark theme
      appBar: AppBar(
        title: Text(
          "Listening Skill",
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Play/Pause Button
            FadeInLeft(
              duration: Duration(milliseconds: 500),
              child: ElevatedButton.icon(
                onPressed: _toggleMusic,
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                label: Text(
                  isPlaying ? "Pause Audio" : "Play Audio",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Audio Progress Bar
            FadeInUp(
              duration: Duration(milliseconds: 600),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 5,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 15),
                  activeTrackColor: Colors.purpleAccent,
                  inactiveTrackColor: Colors.grey.shade700,
                  thumbColor: Colors.purpleAccent,
                ),
                child: Slider(
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds.toDouble(),
                  onChanged: (value) {
                    _seekAudio(Duration(seconds: value.toInt()));
                  },
                ),
              ),
            ),

            // Duration Text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                ),
                Text(
                  _formatDuration(_duration),
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Text Input Field
            FadeInRight(
              duration: Duration(milliseconds: 700),
              child: TextField(
                controller: _textController,
                maxLines: 5,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Type the given paragraph...",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Check Eligibility Button
            FadeInUp(
              duration: Duration(milliseconds: 800),
              child: ElevatedButton(
                onPressed: _checkTextMatch,
                child: Text(
                  "Check Eligibility",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }


class ListeningSkill2 extends StatefulWidget {
  @override
  _ListeningSkillPageState2 createState() => _ListeningSkillPageState2();
}

class _ListeningSkillPageState2 extends State<ListeningSkill2> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  final TextEditingController _textController = TextEditingController();

  final String predefinedPara =
      "The Angry Customer & The Patient Cashier (Self-Regulation)"
  "Riya worked as a cashier in a busy supermarket. One evening, a frustrated customer yelled at her for a small billing mistake. "
      "Instead of reacting angrily, Riya took a deep breath and said, "
      "I understand your frustration. Let me fix this for you right away"

  "Her calm response immediately softened the customer’s anger. He later apologized, realizing he had overreacted."

 " Lesson: Controlling emotions in tense situations can turn conflicts into positive experiences.";

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
      await _audioPlayer.play(AssetSource('Audio/Audio2.mp3')); // Ensure this path is correct
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _seekAudio(Duration position) {
    _audioPlayer.seek(position);
  }

  void _checkTextMatch() {
    String inputText = _textController.text.trim();

    if (inputText.isEmpty) {
      _showAlert("Alert", "Please fill in your thoughts.");
      return;
    }

    if (inputText == predefinedPara) {
      _showAlert("Eligible", "Your input is an exact match.");
    } else if (_checkSimilarity(inputText, predefinedPara)) {
      _showAlert("OK", "Your input has similar words.");
    } else {
      _showAlert("Not Eligible", "Your input does not match.");
    }
  }

  bool _checkSimilarity(String input, String original) {
    List<String> inputWords = input.toLowerCase().split(' ');
    List<String> originalWords = original.toLowerCase().split(' ');

    int matchCount = inputWords.where((word) => originalWords.contains(word)).length;
    return matchCount >= (originalWords.length * 0.6);
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
      backgroundColor: Colors.black, // Premium dark theme
      appBar: AppBar(
        title: Text(
          "Listening Skill",
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Play/Pause Button
            FadeInLeft(
              duration: Duration(milliseconds: 500),
              child: ElevatedButton.icon(
                onPressed: _toggleMusic,
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                label: Text(
                  isPlaying ? "Pause Audio" : "Play Audio",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Audio Progress Bar
            FadeInUp(
              duration: Duration(milliseconds: 600),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 5,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 15),
                  activeTrackColor: Colors.purpleAccent,
                  inactiveTrackColor: Colors.grey.shade700,
                  thumbColor: Colors.purpleAccent,
                ),
                child: Slider(
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds.toDouble(),
                  onChanged: (value) {
                    _seekAudio(Duration(seconds: value.toInt()));
                  },
                ),
              ),
            ),

            // Duration Text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                ),
                Text(
                  _formatDuration(_duration),
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Text Input Field
            FadeInRight(
              duration: Duration(milliseconds: 700),
              child: TextField(
                controller: _textController,
                maxLines: 5,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Type the given paragraph...",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Check Eligibility Button
            FadeInUp(
              duration: Duration(milliseconds: 800),
              child: ElevatedButton(
                onPressed: _checkTextMatch,
                child: Text(
                  "Check Eligibility",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
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
  }}


class ListeningSkill3 extends StatefulWidget {
  @override
  _ListeningSkillPageState3 createState() => _ListeningSkillPageState3();
}

class _ListeningSkillPageState3 extends State<ListeningSkill3> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  final TextEditingController _textController = TextEditingController();

  final String predefinedPara =
     " The Two Friends & The Forgotten Birthday (Empathy)"
  "Amit and Rohit had been best friends for years. But on Amit’s birthday, Rohit completely forgot to wish him. Amit felt hurt and ignored him for days."

  "Later, Rohit finally asked, “Why are you avoiding me?” Amit replied angrily,"
      " You forgot my birthday! I thought you didn’t care about me."

  "Rohit sighed, I’m really sorry. My mother was in the hospital that day, and I was completely overwhelmed."

 " Amit immediately felt guilty. He had assumed the worst without understanding Rohit’s situation."

  " Lesson: Always try to understand others' perspectives before making judgments.";

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
      await _audioPlayer.play(AssetSource('Audio/Audio3.mp3')); // Ensure this path is correct
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _seekAudio(Duration position) {
    _audioPlayer.seek(position);
  }

  void _checkTextMatch() {
    String inputText = _textController.text.trim();

    if (inputText.isEmpty) {
      _showAlert("Alert", "Please fill in your thoughts.");
      return;
    }

    if (inputText == predefinedPara) {
      _showAlert("Eligible", "Your input is an exact match.");
    } else if (_checkSimilarity(inputText, predefinedPara)) {
      _showAlert("OK", "Your input has similar words.");
    } else {
      _showAlert("Not Eligible", "Your input does not match.");
    }
  }

  bool _checkSimilarity(String input, String original) {
    List<String> inputWords = input.toLowerCase().split(' ');
    List<String> originalWords = original.toLowerCase().split(' ');

    int matchCount = inputWords.where((word) => originalWords.contains(word)).length;
    return matchCount >= (originalWords.length * 0.6);
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
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Premium dark theme
      appBar: AppBar(
        title: Text(
          "Listening Skill",
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Play/Pause Button
            FadeInLeft(
              duration: Duration(milliseconds: 500),
              child: ElevatedButton.icon(
                onPressed: _toggleMusic,
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                label: Text(
                  isPlaying ? "Pause Audio" : "Play Audio",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Audio Progress Bar
            FadeInUp(
              duration: Duration(milliseconds: 600),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 5,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 15),
                  activeTrackColor: Colors.purpleAccent,
                  inactiveTrackColor: Colors.grey.shade700,
                  thumbColor: Colors.purpleAccent,
                ),
                child: Slider(
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds.toDouble(),
                  onChanged: (value) {
                    _seekAudio(Duration(seconds: value.toInt()));
                  },
                ),
              ),
            ),

            // Duration Text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                ),
                Text(
                  _formatDuration(_duration),
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Text Input Field
            FadeInRight(
              duration: Duration(milliseconds: 700),
              child: TextField(
                controller: _textController,
                maxLines: 5,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Type the given paragraph...",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Check Eligibility Button
            FadeInUp(
              duration: Duration(milliseconds: 800),
              child: ElevatedButton(
                onPressed: _checkTextMatch,
                child: Text(
                  "Check Eligibility",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
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

class ListeningSkill4 extends StatefulWidget {
  @override
  _ListeningSkillPageState4 createState() => _ListeningSkillPageState4();
}

class _ListeningSkillPageState4 extends State<ListeningSkill4> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  final TextEditingController _textController = TextEditingController();

  final String predefinedPara =
      "The Nervous Speaker & The Encouraging Mentor (Self-Awareness & Motivation)"
  "Priya had to give a presentation in front of her entire office. "
  "She was terrified and kept thinking, What if I mess up?"
 " Her mentor, Mr. Mehra, noticed her fear and said, Priya, it’s okay to be nervous. But instead of focusing on failure, focus on sharing your ideas confidently."

  "Taking his advice, Priya took a deep breath, smiled, and started speaking. She still felt nervous, but she pushed through it. By the end, the audience clapped, and her confidence grew."

  "Lesson: Understanding and managing fear can turn weaknesses into strengths.";

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
      await _audioPlayer.play(AssetSource('Audio/Audio4.mp3')); // Ensure this path is correct
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _seekAudio(Duration position) {
    _audioPlayer.seek(position);
  }

  void _checkTextMatch() {
    String inputText = _textController.text.trim();

    if (inputText.isEmpty) {
      _showAlert("Alert", "Please fill in your thoughts.");
      return;
    }

    if (inputText == predefinedPara) {
      _showAlert("Eligible", "Your input is an exact match.");
    } else if (_checkSimilarity(inputText, predefinedPara)) {
      _showAlert("OK", "Your input has similar words.");
    } else {
      _showAlert("Not Eligible", "Your input does not match.");
    }
  }

  bool _checkSimilarity(String input, String original) {
    List<String> inputWords = input.toLowerCase().split(' ');
    List<String> originalWords = original.toLowerCase().split(' ');

    int matchCount = inputWords.where((word) => originalWords.contains(word)).length;
    return matchCount >= (originalWords.length * 0.6);
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
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Premium dark theme
      appBar: AppBar(
        title: Text(
          "Listening Skill",
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Play/Pause Button
            FadeInLeft(
              duration: Duration(milliseconds: 500),
              child: ElevatedButton.icon(
                onPressed: _toggleMusic,
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                label: Text(
                  isPlaying ? "Pause Audio" : "Play Audio",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Audio Progress Bar
            FadeInUp(
              duration: Duration(milliseconds: 600),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 5,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 15),
                  activeTrackColor: Colors.purpleAccent,
                  inactiveTrackColor: Colors.grey.shade700,
                  thumbColor: Colors.purpleAccent,
                ),
                child: Slider(
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds.toDouble(),
                  onChanged: (value) {
                    _seekAudio(Duration(seconds: value.toInt()));
                  },
                ),
              ),
            ),

            // Duration Text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                ),
                Text(
                  _formatDuration(_duration),
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Text Input Field
            FadeInRight(
              duration: Duration(milliseconds: 700),
              child: TextField(
                controller: _textController,
                maxLines: 5,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Type the given paragraph...",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Check Eligibility Button
            FadeInUp(
              duration: Duration(milliseconds: 800),
              child: ElevatedButton(
                onPressed: _checkTextMatch,
                child: Text(
                  "Check Eligibility",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
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

class ListeningSkill5 extends StatefulWidget {
  @override
  _ListeningSkillPageState5 createState() => _ListeningSkillPageState5();
}

class _ListeningSkillPageState5 extends State<ListeningSkill5> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  final TextEditingController _textController = TextEditingController();

  final String predefinedPara =
      "The Rude Boss & The Smart Employee (Social Skills & Conflict Resolution)"
  "Arjun’s boss was always rude and dismissive. One day, when Arjun presented a new idea, his boss snapped, This is useless!"

 " Instead of getting angry, Arjun calmly said, I understand your concern. Could you tell me what specifically needs improvement?"

 " His boss was caught off guard. He realized Arjun wasn’t reacting emotionally but was genuinely looking for feedback. After a moment, he softened and gave constructive advice."

  "Lesson: Handling difficult people with patience and professionalism can turn a bad situation into an opportunity.";

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
      await _audioPlayer.play(AssetSource('Audio/Audio5.mp3')); // Ensure this path is correct
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _seekAudio(Duration position) {
    _audioPlayer.seek(position);
  }

  void _checkTextMatch() {
    String inputText = _textController.text.trim();

    if (inputText.isEmpty) {
      _showAlert("Alert", "Please fill in your thoughts.");
      return;
    }

    if (inputText == predefinedPara) {
      _showAlert("Eligible", "Your input is an exact match.");
    } else if (_checkSimilarity(inputText, predefinedPara)) {
      _showAlert("OK", "Your input has similar words.");
    } else {
      _showAlert("Not Eligible", "Your input does not match.");
    }
  }

  bool _checkSimilarity(String input, String original) {
    List<String> inputWords = input.toLowerCase().split(' ');
    List<String> originalWords = original.toLowerCase().split(' ');

    int matchCount = inputWords.where((word) => originalWords.contains(word)).length;
    return matchCount >= (originalWords.length * 0.6);
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
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Premium dark theme
      appBar: AppBar(
        title: Text(
          "Listening Skill",
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Play/Pause Button
            FadeInLeft(
              duration: Duration(milliseconds: 500),
              child: ElevatedButton.icon(
                onPressed: _toggleMusic,
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                label: Text(
                  isPlaying ? "Pause Audio" : "Play Audio",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Audio Progress Bar
            FadeInUp(
              duration: Duration(milliseconds: 600),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 5,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 15),
                  activeTrackColor: Colors.purpleAccent,
                  inactiveTrackColor: Colors.grey.shade700,
                  thumbColor: Colors.purpleAccent,
                ),
                child: Slider(
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds.toDouble(),
                  onChanged: (value) {
                    _seekAudio(Duration(seconds: value.toInt()));
                  },
                ),
              ),
            ),

            // Duration Text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                ),
                Text(
                  _formatDuration(_duration),
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Text Input Field
            FadeInRight(
              duration: Duration(milliseconds: 700),
              child: TextField(
                controller: _textController,
                maxLines: 5,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Type the given paragraph...",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Check Eligibility Button
            FadeInUp(
              duration: Duration(milliseconds: 800),
              child: ElevatedButton(
                onPressed: _checkTextMatch,
                child: Text(
                  "Check Eligibility",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
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



