import 'package:flutter/material.dart';
import 'package:heroapp/models/reel.dart';
import 'package:heroapp/utils/components/like_btn.dart';
import 'package:heroapp/utils/extensions/string.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReelItem extends StatefulWidget {
  const ReelItem({super.key, required this.reel});
  final Reel reel;

  @override
  _ReelItemState createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.reel.videoPath))
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('item-${widget.reel.id}-key'),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        print('Widget ${visibilityInfo.key} is $visiblePercentage% visible');

        if (visiblePercentage <= 50.0) {
          print("Pausing video");
          print(widget.reel.controller.value.isPlaying);
          widget.reel.controller.initialize().then((_){
            widget.reel.controller.play();
          });
          print(widget.reel.controller.value.isPlaying);
        }
      },
      child: InkWell(
        onTap: (){
          _controller.initialize().then((_){
            _controller.play();
          });
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 90,),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                    Text(widget.reel.title ?? "", style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 18
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
                              child: Text(widget.reel.views!.formattedNumber, style: TextStyle(
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
                              child: Text(widget.reel.likes!.formattedNumber, style: TextStyle(
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
        ),
      ),
    );
  }
}
