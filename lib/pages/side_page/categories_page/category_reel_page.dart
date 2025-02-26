import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:heroapp/utils/extensions/string.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';

import '../../../controllers/discover_reel_controller.dart';
import '../../../models/reel.dart';

class CategoryReelPage extends StatefulWidget {
  final Reel reel;
  CategoryReelPage({super.key, required this.reel});

  @override
  State<CategoryReelPage> createState() => _CategoryReelPageState();
}

class _CategoryReelPageState extends State<CategoryReelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trending", style: TextStyle(
          fontSize: 18
      )),
        // foregroundColor: Colors.white, backgroundColor: Colors.black,
      ),
      // backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CategoryReelItem(reel: widget.reel,)
          ],
        ),
      ),
    );
  }
}

class CategoryReelItem extends StatefulWidget {
  CategoryReelItem({super.key, required this.reel});
  final Reel reel;

  @override
  _CategoryReelItemState createState() => _CategoryReelItemState();
}

class _CategoryReelItemState extends State<CategoryReelItem> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  late DiscoverReelController _discoverReelController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.reel.reelUrl))
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play();
      });
    _discoverReelController = DiscoverReelController(Dio());
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
                Text(widget.reel.title ?? "Satisfying Pop💥", style: Theme.of(context).textTheme.titleLarge),
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
                            icon: Icon(Icons.remove_red_eye_outlined, size: 25),
                            onPressed: () => {},
                          ),
                        ),
                        SizedBox(height: 12,),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Text(widget.reel.views!.formattedNumber, style: TextStyle(
                            // color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),),
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
                              _discoverReelController.unlikeVideo(widget.reel);
                            } else {
                              _discoverReelController.likeVideo(widget.reel);
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