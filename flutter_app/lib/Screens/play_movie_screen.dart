// ignore_for_file: prefer_const_constructors, prefer_final_fields, use_key_in_widget_constructors, deprecated_member_use, prefer_const_constructors_in_immutables, unused_field

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class PlayMovieScreen extends StatefulWidget {
  @override
  _PlayMovieScreenState createState() => _PlayMovieScreenState();
}

class _PlayMovieScreenState extends State<PlayMovieScreen> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  String? _selectedVideo;

  List<String> _videoUrls = [
    'http://127.0.0.1:8000/videos/atlas.mp4',
    'http://127.0.0.1:8000/videos/damsel.mp4',
    'http://127.0.0.1:8000/videos/Battleship.mp4',
    'http://127.0.0.1:8000/videos/Everest.mp4',
    'http://127.0.0.1:8000/videos/FALL_OF_JERUSALEM.mp4',
    'http://127.0.0.1:8000/videos/Godzilla_x_Kong.mp4',
    'http://127.0.0.1:8000/videos/Jaws.mp4',
    'http://127.0.0.1:8000/videos/MOnkey_Man.mp4',
    'http://127.0.0.1:8000/videos/NEVER_LET_GO.mp4',
    'http://127.0.0.1:8000/videos/spectral.mp4',
    'http://127.0.0.1:8000/videos/The_Killer.mp4',
    'http://127.0.0.1:8000/videos/The_Great_Wall.mp4',
    'http://127.0.0.1:8000/videos/Trap.mp4',
    'http://127.0.0.1:8000/videos/Venom.mp4',
    'http://127.0.0.1:8000/videos/WORLD_WAR_Z.mp4'
  ];

  String _trailerUrl = 'https://www.youtube.com/movie trailers';

  @override
  void initState() {
    super.initState();
    _selectedVideo = _videoUrls.first;
  }

  Future<void> _launchTrailerUrl() async {
    if (await canLaunch(_trailerUrl)) {
      await launch(_trailerUrl);
    } else {
      throw 'Could not launch $_trailerUrl';
    }
  }

  void _playFullScreenVideo(String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(videoUrl: videoUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Play Movie Screen'),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/image8.jpeg'), // Add your background image to assets folder and update pubspec.yaml
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: _selectedVideo,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedVideo = newValue!;
                      _playFullScreenVideo(_selectedVideo!);
                    });
                  },
                  items:
                      _videoUrls.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.split('/').last),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: _launchTrailerUrl,
                child: Text('Watch Movie Trailers on YouTube'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;

  FullScreenVideoPlayer({required this.videoUrl});

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller!.initialize();
    _controller!.setLooping(true);
    _controller!.play();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Full Screen Video'),
      ),
      body: Center(
        child: _controller != null
            ? FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            : Text('Loading...'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller!.value.isPlaying) {
              _controller!.pause();
            } else {
              _controller!.play();
            }
          });
        },
        child: Icon(
          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
