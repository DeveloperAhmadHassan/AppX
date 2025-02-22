import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:heroapp/controllers/home_reel_controller.dart';
import 'package:heroapp/models/reel.dart';
import 'package:heroapp/utils/extensions/string.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_svg/svg.dart';

class WatchHistoryItemPage extends StatefulWidget {
  final Reel reel;
  const WatchHistoryItemPage({super.key, required this.reel});

  @override
  State<WatchHistoryItemPage> createState() => _WatchHistoryItemPageState();
}

class _WatchHistoryItemPageState extends State<WatchHistoryItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Watch History", style: TextStyle(
          fontSize: 18
        )),
      ),
      // backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            LikedClickedItem(reel: widget.reel,)
          ],
        ),
      ),
    );
  }
}

class LikedClickedItem extends StatefulWidget {
  const LikedClickedItem({super.key, required this.reel});
  final Reel reel;

  @override
  _LikedClickedItemState createState() => _LikedClickedItemState();
}

class _LikedClickedItemState extends State<LikedClickedItem> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool _isVideoPlaying = false;
  late HomeReelController _homeReelController;

  @override
  void initState() {
    super.initState();
    _homeReelController = HomeReelController(Dio());
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.reel.reelUrl))
      ..initialize().then((_) {
        if(mounted){
          setState(() {
            _isVideoInitialized = true;
          });
        }
        _controller.setLooping(true);
        _controller.play();
        _isVideoPlaying = true;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction <= 0.5 && _isVideoPlaying) {
      _controller.pause();
      if(mounted){
        setState(() {
          _isVideoPlaying = false;
        });
      }
    } else if (info.visibleFraction > 0.5 && !_isVideoPlaying) {
      _controller.play();
      if(mounted){
        setState(() {
          _isVideoPlaying = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // SizedBox(height: 20),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                // color: Colors.black,
                borderRadius: BorderRadius.circular(30),
              ),
              child: _isVideoInitialized
                  ? InkWell(
                onTap: () {
                  _controller.initialize().then((_) {
                    _controller.play();
                    if(mounted){
                      setState(() {
                        _isVideoPlaying = true;
                      });
                    }
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: VisibilityDetector(
                    key: Key('reel-${widget.reel.id}'),
                    onVisibilityChanged: _onVisibilityChanged,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ) : Center(child: CircularProgressIndicator()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13.0, right: 20.0, top: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/1.8,
                  child: Text(
                    "${widget.reel.title} ${widget.reel.id}",
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
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
                            icon: Icon(Icons.remove_red_eye_outlined,
                                size: 25),
                            onPressed: () => {},
                          ),
                        ),
                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Text(
                              widget.reel.views!.formattedNumber,
                              style: TextStyle(
                                // color: Colors.white,
                                  fontWeight: FontWeight.bold
                              )),
                        )
                      ],
                    ),
                    SizedBox(width: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LikeButton(
                          size: 25,
                          isLiked: widget.reel.isLiked,
                          onTap: (isCurrentlyLiked) async {
                            if(isCurrentlyLiked) {
                              _homeReelController.unlikeVideo(widget.reel);
                            } else {
                              _homeReelController.likeVideo(widget.reel);
                            }
                            setState(() {
                              widget.reel.isLiked = !isCurrentlyLiked;
                            });
                            return widget.reel.isLiked;
                          },
                          likeBuilder: (isLiked) {
                            return Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                              color: isLiked ? Colors.red : Theme.of(context).iconTheme.color,
                              size: 25,
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Text(widget.reel.likes!.formattedNumber, style: TextStyle(
                            // color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),textAlign: TextAlign.center,),
                        )
                      ],
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () {
                        print("Shared");
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/share.svg',
                            semanticsLabel: 'Share Logo',
                            height: 30,
                            width: 30,
                            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                          SizedBox(height: 16,)
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

