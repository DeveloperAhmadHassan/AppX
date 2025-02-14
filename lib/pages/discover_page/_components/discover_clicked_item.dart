import 'package:flutter/material.dart';
import 'package:heroapp/utils/components/like_btn.dart';
import 'package:video_player/video_player.dart';

class DiscoverClickedItem extends StatefulWidget {
  const DiscoverClickedItem({super.key, this.videoUrl = "assets/reels/a.mp4"});
  final String videoUrl;

  @override
  _DiscoverClickedItemState createState() => _DiscoverClickedItemState();
}

class _DiscoverClickedItemState extends State<DiscoverClickedItem> {
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
          SizedBox(height: 50,),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height - 240,
              padding: EdgeInsets.symmetric(horizontal: 18.0),
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
            padding: const EdgeInsets.only(left: 13.0, right: 20.0, top: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Satisfying Pop💥", style: TextStyle(
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        SizedBox(height: 12,),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LikeBtn(),
                        // SizedBox(height: 10,),
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
      ),
    );
  }
}
