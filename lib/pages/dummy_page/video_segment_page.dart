import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoSegmentsPage extends StatefulWidget {
  @override
  _VideoSegmentsPageState createState() => _VideoSegmentsPageState();
}

class _VideoSegmentsPageState extends State<VideoSegmentsPage> {
  late VideoPlayerController _controller;
  late List<Duration> segments;
  int currentSegmentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/reels/t.mp4')
      ..initialize().then((_) {
        setState(() {
          // Define segments here, for example 5-second intervals
          segments = List.generate(
              (_controller.value.duration.inSeconds ~/ 5),
                  (index) => Duration(seconds: index * 5));
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void goToSegment(int index) {
    if (index >= 0 && index < segments.length) {
      setState(() {
        currentSegmentIndex = index;
      });
      _controller.seekTo(segments[index]);
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Segments')),
      body: Column(
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Center(child: CircularProgressIndicator()),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(segments.length, (index) {
              return GestureDetector(
                onTap: () => goToSegment(index),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: 50,
                  height: 5,
                  color: index == currentSegmentIndex
                      ? Colors.blue
                      : Colors.grey,
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
