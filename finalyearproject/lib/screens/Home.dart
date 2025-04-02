import 'package:animate_do/animate_do.dart';
import 'package:finalyearproject/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'communication.dart';
import 'problem_solving.dart';
import 'time_management.dart';
import 'emotional_intelligence.dart';
import 'assessment_page.dart';
import 'interview.dart';


class homepage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homepage> {
  bool _showLoading = true;
  bool _isAssessmentCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkAssessmentStatus();
    Timer(Duration(seconds: 2), () {
      setState(() {
        _showLoading = false;
      });
    });
  }

  Future<void> _checkAssessmentStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAssessmentCompleted = prefs.getBool('isAssessmentCompleted') ?? false;
    });
  }

  Future<void> _markAssessmentCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAssessmentCompleted', true);
    setState(() {
      _isAssessmentCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showLoading
          ? _buildLoadingScreen()
          : !_isAssessmentCompleted
          ? AssessmentPage(onComplete: _markAssessmentCompleted)
          : MainContent(),

    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to SS Development",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Lottie.asset(
              'assets/images/loading.json',
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  final List<String> skills = [
    "Communication",
    "Problem Solving",
    "Time Management",
    "Emotional Intelligence",
    "Interview",
  ];

  final List<Widget> skillPages = [
    VideoRecorderApp(),
    ProblemSolvingPage(),
    TimeManagementPage(),
    EmotionalIntelligencePage(),
    InterviewPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Soft Skills", style: GoogleFonts.lato(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      drawer: _buildDrawer(context),
      body: _buildSkillGrid(context),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Text(
                'Welcome to Soft Skills',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text('Log out', style: TextStyle(color: Colors.white)),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('isAssessmentCompleted');
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3 / 3,
        ),
        itemCount: skills.length,
        itemBuilder: (context, index) {
          return FadeInUp(
            duration: Duration(milliseconds: 500 * (index + 1)),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => skillPages[index],
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Center(
                  child: Text(
                    skills[index],
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}