import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:heroapp/utils/extensions/string.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';

import '../../../controllers/carousel_reel_controller.dart';
import '../../../models/reel.dart';

class LongPressItem extends StatefulWidget {
  const LongPressItem({super.key, required this.reel});
  final Reel reel;

  @override
  _LongPressItemState createState() => _LongPressItemState();
}

class _LongPressItemState extends State<LongPressItem> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  late CarouselReelController _carouselReelController;

  @override
  void initState() {
    super.initState();
    _carouselReelController = CarouselReelController(Dio());
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
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // height: MediaQuery.of(context).size.height,
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
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 150,
                child: Text(
                  "${widget.reel.title} ${widget.reel.id}",
                  style: Theme.of(context).textTheme.titleMedium,
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
                    mainAxisAlignment: MainAxisAlignment.end,
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
                      SizedBox(height: 10,),
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      LikeButton(
                        size: 25,
                        isLiked: widget.reel.isLiked,
                        onTap: (isCurrentlyLiked) async {
                          if(isCurrentlyLiked) {
                            _carouselReelController.unlikeVideo(widget.reel.id ?? "1");
                          } else {
                            _carouselReelController.likeVideo(widget.reel.id ?? "1");
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
    );
  }
}
