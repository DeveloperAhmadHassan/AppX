import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LongPressItem extends StatefulWidget {
  const LongPressItem({super.key, this.videoUrl = "assets/reels/a.mp4"});
  final String videoUrl;

  @override
  _LongPressItemState createState() => _LongPressItemState();
}

class _LongPressItemState extends State<LongPressItem> {
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
    return Stack(
      children: [
        Container(
          // height: MediaQuery.of(context).size.height - 100,
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
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Satisfying Pop 💥 ", style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22
              )),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 40,
                        child: IconButton(
                          icon: Icon(Icons.remove_red_eye_outlined, size: 25, color: Colors.white),
                          onPressed: () => {},
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text("74K", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 43,
                        child: IconButton(
                          icon: Icon(Icons.favorite_border_outlined, size: 25, color: Colors.white),
                          onPressed: () => {},
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text("20K", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),textAlign: TextAlign.center,),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
