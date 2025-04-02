import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'Home.dart';

class TimeManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreenTime(),
    );
  }
}

class HomeScreenTime extends StatelessWidget {
  final List<Map<String, dynamic>> options = [
    {'title': 'Introduction', 'route': YouTubeListScreenemotime()},
    {'title': 'Calender', 'route': CalendarScreen()},
    {'title': 'TimeManaging', 'route': TimeWastingTestApp()},

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
            'Time Management Page',
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

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, String> _savedTasks = {};
  final TextEditingController _taskController = TextEditingController();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _initializeNotifications();
    _loadTasks();
  }

  void _initializeNotifications() async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: android);
    await _flutterLocalNotificationsPlugin.initialize(settings);
  }

  void _saveTask() async {
    if (_taskController.text.isEmpty) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _savedTasks[_selectedDate] = _taskController.text;
    Map<String, String> storedTasks = _savedTasks.map((key, value) =>
        MapEntry(key.toIso8601String(), value));
    await prefs.setString('tasks', jsonEncode(storedTasks));
    _scheduleNotification(_selectedDate, _taskController.text);
    setState(() {
      _taskController.clear();
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Task Saved!')));
  }

  void _scheduleNotification(DateTime date, String task) async {
    if (date.isBefore(DateTime.now())) return;
    final androidDetails = AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    final details = NotificationDetails(android: androidDetails);
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(date, tz.local);
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder!',
      'Task: $task',
      scheduledDate,
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      Map<String, dynamic> decodedTasks = jsonDecode(tasksString);
      _savedTasks = decodedTasks.map((key, value) =>
          MapEntry(DateTime.parse(key), value.toString()));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Premium dark theme
      appBar: AppBar(
        title: Text(
          "Task Board",
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
        actions: [
          IconButton(
            icon: Icon(Icons.question_mark_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrioritizationApp(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Premium Calendar UI
          Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              color: Colors.grey.shade900,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(color: Colors.white),
                  weekendTextStyle: TextStyle(color: Colors.orangeAccent),
                ),
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white70),
                  weekendStyle: TextStyle(color: Colors.orangeAccent),
                ),
              ),
            ),
          ),

          // Task Input Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter task...",
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.grey.shade800,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Add",
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Task List with Premium Cards
          Expanded(
            child: _savedTasks.isEmpty
                ? Center(
              child: Text(
                "No tasks added yet!",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white54,
                ),
              ),
            )
                : ListView.builder(
              itemCount: _savedTasks.length,
              itemBuilder: (context, index) {
                DateTime date = _savedTasks.keys.elementAt(index);
                return FadeInUp(
                  duration: Duration(milliseconds: 400 + (index * 100)),
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.deepPurpleAccent.withOpacity(0.9),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        _savedTasks[date]!,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        "${date.toLocal().toString().split(' ')[0]}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.white70),
                        onPressed: () {
                          setState(() {
                            _savedTasks.remove(date);
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TimeWastingTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TimeWastingTestPage(),
    );
  }
}

class TimeWastingTestPage extends StatefulWidget {
  @override
  _TimeWastingTestPageState createState() => _TimeWastingTestPageState();
}

class _TimeWastingTestPageState extends State<TimeWastingTestPage> {
  final TextEditingController workController = TextEditingController();
  final TextEditingController socialMediaController = TextEditingController();
  final TextEditingController entertainmentController = TextEditingController();
  final TextEditingController sleepController = TextEditingController();
  final TextEditingController otherController = TextEditingController();

  void _evaluateTime() {
    double work = double.tryParse(workController.text) ?? 0;
    double socialMedia = double.tryParse(socialMediaController.text) ?? 0;
    double entertainment = double.tryParse(entertainmentController.text) ?? 0;
    double sleep = double.tryParse(sleepController.text) ?? 0;
    double other = double.tryParse(otherController.text) ?? 0;

    double totalHours = work + socialMedia + entertainment + sleep + other;

    if (work >= 6 && work <= 8 && socialMedia <= 1 && entertainment <= 2 && sleep >= 7 && sleep <= 8) {
      _showMessage("You are eligible! ✅\nYou have a great balance for productivity.");
    } else {
      _showMessage("You are not eligible! ❌\nPlease manage your time better for a productive life.");
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Test Result"),
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
      backgroundColor: Colors.black, // Dark premium theme
      appBar: AppBar(
        leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => HomeScreenTime(),
    ),
    );
    },),
        title: Text(
          "Time-Wasting Awareness Test",
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
          children: [
            _buildTextField(workController, "Work/Study (hrs)"),
            _buildTextField(socialMediaController, "Social Media (hrs)"),
            _buildTextField(entertainmentController, "Entertainment (hrs)"),
            _buildTextField(sleepController, "Sleep (hrs)"),
            _buildTextField(otherController, "Other Activities (hrs)"),
            SizedBox(height: 20),

            // Animated Submit Button
            FadeInUp(
              duration: Duration(milliseconds: 500),
              child: ElevatedButton(
                onPressed: _evaluateTime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Submit",
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
    );
  }
}

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(

        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }




class PrioritizationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prioritization Techniques',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: PrioritizationScreen(),
    );
  }
}

class PrioritizationScreen extends StatelessWidget {
  final List<Map<String, String>> techniques = [
    {
      "title": "Eisenhower Matrix (Urgent-Important Matrix)",
      "statement":
      "Prioritizes tasks by categorizing them as Urgent & Important, Important but Not Urgent, Urgent but Not Important, and Neither.",
      "example": "Example: Handling work deadlines and long-term skill development.",
      "url": "https://youtu.be/tLLyi50M5KM?si=1q5BP0x9XPtZ_UWP"
    },
    {
      "title": "ABCD Method",
      "statement":
      "Categorizes tasks based on importance: A (Critical), B (Important), C (Nice-to-have), D (Delegate/Delete).",
      "example": "Example: Sorting daily tasks based on priority to avoid distractions.",
      "url": "https://youtu.be/FKOMTZ7PPLg?si=LXMZwVtnvOZvRDbn"
    },
    {
      "title": "MoSCoW Method",
      "statement":
      "Breaks tasks into Must Have, Should Have, Could Have, and Won’t Have to manage priorities.",
      "example": "Example: Organizing a project roadmap efficiently.",
      "url": "https://youtu.be/pm4GbSRMElc?si=BiIoz9a6IfznY8AY"
    },
    {
      "title": "80/20 Rule (Pareto Principle)",
      "statement":
      "States that 20% of tasks generate 80% of results. Focus on high-impact work first.",
      "example": "Example: Spending more time on tasks that bring the highest results.",
      "url": "https://youtu.be/lsGwqk_agcQ?si=93K7G0ULQzU_-Ak_"
    }
  ];

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Premium dark theme
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreenTime(),
              ),
            );
          },
        ),
        title: Text(
          "Prioritization Techniques",
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
          itemCount: techniques.length,
          itemBuilder: (context, index) {
            return FadeInUp(
              duration: Duration(milliseconds: 400 + (index * 100)),
              child: Card(
                color: Colors.grey.shade900,
                elevation: 6,
                shadowColor: Colors.purpleAccent.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        techniques[index]["title"]!,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purpleAccent,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        techniques[index]["statement"]!,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        techniques[index]["example"]!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => _launchURL(techniques[index]["url"]!),
                        icon: Icon(Icons.video_library, color: Colors.white),
                        label: Text(
                          "Watch Example",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


class YouTubeListScreenemotime extends StatelessWidget {
  final List<String> _youtubeVideos = [
    'https://youtu.be/iONDebHX9qk?si=hxAT6ZjuipJET8RG',
  ];

  void _openYouTubeVideo(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YouTubePlayerScreenemotime(youtubeUrl: url),
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
class YouTubePlayerScreenemotime extends StatefulWidget {
  final String youtubeUrl;

  YouTubePlayerScreenemotime({required this.youtubeUrl});

  @override
  _YouTubePlayerScreenStateemotime createState() => _YouTubePlayerScreenStateemotime();
}

class _YouTubePlayerScreenStateemotime extends State<YouTubePlayerScreenemotime> {
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