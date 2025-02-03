import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Reel extends StatefulWidget {
  const Reel({super.key, this.videoUrl = "assets/reels/a.mp4"});
  final String videoUrl;

  @override
  _ReelState createState() => _ReelState();
}

class _ReelState extends State<Reel> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 120,),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height - 240,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
              ),
              child: _isVideoInitialized
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: VideoPlayer(_controller),
                  ) : Center(child: CircularProgressIndicator()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13.0, right: 13.0, top: 7.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Satisfying Pop💥", style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22
                )),
                Row(
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_red_eye_outlined, size: 25, color: Colors.white),
                          onPressed: () => {},
                        ),
                        Text("74K", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),)
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.favorite_border_outlined, size: 25, color: Colors.white),
                          onPressed: () => {},
                        ),
                        Text("20K", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),)
                      ],
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
