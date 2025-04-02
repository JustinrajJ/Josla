import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:finalyearproject/screens/ListeningSkill.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

import 'Home.dart';

void main() {
  runApp(VideoRecorderApp());
}

class VideoRecorderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Recorder & YouTube',
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
    {'title': 'Introduction', 'route': YouTubeList()},
    {'title': 'Record Your Skill', 'route': VideoListScreen()},
    {'title': 'Body Language', 'route': YouTubeListScreen()},
    {'title': 'Listening Skill', 'route': Listen()},
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
            'Communication Skills',
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

// Video List Page
class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final List<File> _videoFiles = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedVideos = prefs.getStringList('video_paths');
    if (savedVideos != null) {
      setState(() {
        _videoFiles.addAll(savedVideos.map((path) => File(path)).toList());
      });
    }
  }

  Future<void> _saveVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> paths = _videoFiles.map((file) => file.path).toList();
    await prefs.setStringList('video_paths', paths);
  }

  Future<void> _recordVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      setState(() {
        _videoFiles.add(File(video.path));
      });
      _saveVideos();
    }
  }

  void _openVideoPlayer(File videoFile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoFile: videoFile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Video List',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: _videoFiles.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.video_library, size: 80, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                'No videos recorded yet',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: _videoFiles.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.video_library, color: Colors.blue.shade800),
                ),
                title: Text(
                  'Video ${index + 1}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                trailing: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.play_arrow, color: Colors.green.shade800),
                ),
                onTap: () => _openVideoPlayer(_videoFiles[index]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 2,
            )
          ],
        ),
        child: FloatingActionButton(
          onPressed: _recordVideo,
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 8,
          child: Icon(Icons.videocam, size: 28, color: Colors.white),
        ),
      ),
    );
  }
}

// Video Player Page
class VideoPlayerScreen extends StatefulWidget {
  final File videoFile;

  VideoPlayerScreen({required this.videoFile});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Player')),
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _togglePlayPause,
              child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            ),
          ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}

// YouTube List Page
class YouTubeListScreen extends StatelessWidget {
  final List<String> _youtubeVideos = [
    'https://youtu.be/4jwUXV4QaTw?si=5DTUAoG7VS5lcmxK',
    'https://youtu.be/VRJzvJ5XPQI?si=RwpZ4WjFkuIIapUB',
    'https://youtu.be/gkag3o8G9ng?si=EUqo7KeR_-JmDPGW',
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
        title: Center(
          child: Text(
            'Body Language',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
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
                color: Colors.white,
                elevation: 6,
                shadowColor: Colors.black.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Icon(Icons.play_circle_fill, color: Colors.grey, size: 40),
                  title: Text(
                    'Body Language ${index + 1}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
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
      appBar: AppBar(title: Text('Player')),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
      ),
    );
  }
}

class YouTubeList extends StatelessWidget {
  final List<String> _youtubeVideos = [
    'https://youtu.be/Nkwdchyo2t8?si=4pGZqxBi3q2ovmfh',
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
class YouTubePlayerScreencom extends StatefulWidget {
  final String youtubeUrl;

  YouTubePlayerScreencom({required this.youtubeUrl});

  @override
  _YouTubePlayerScreenStatecom createState() => _YouTubePlayerScreenStatecom();
}

class _YouTubePlayerScreenStatecom extends State<YouTubePlayerScreencom> {
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