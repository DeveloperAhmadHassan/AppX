import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:heroapp/utils/extensions/string.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../controllers/carousel_reel_controller.dart';
import '../../../models/reel.dart';
import '../../../utils/constants.dart';


class CarousalItem extends StatefulWidget {
  final int xIndex;
  final int yIndex;
  final Reel reel;
  final Function(LongPressStartDetails details, Reel reel) onLongPressStart;
  final VoidCallback onTap;

  const CarousalItem({
    super.key,
    required this.xIndex,
    required this.yIndex,
    required this.onLongPressStart,
    required this.reel,
    required this.onTap
  });

  @override
  _CarousalItemState createState() => _CarousalItemState();
}

class _CarousalItemState extends State<CarousalItem> {
  late CarouselReelController _carouselReelController;

  @override
  void initState() {
    super.initState();
    _carouselReelController = CarouselReelController(Dio());
  }

  @override
  void dispose() {
    _carouselReelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, bottom: 25.0, left: 25.0, right: 25.0),
      child: VisibilityDetector(
        key: Key('item-${widget.xIndex}${widget.yIndex}-key'),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          print('Widget ${visibilityInfo.key} is $visiblePercentage% visible');

          if (visiblePercentage >= 50 && !widget.reel.isVideoInitialized) {
            widget.reel.initialize();
          }

          if (visiblePercentage >= 90 && widget.reel.isVideoInitialized) {
            widget.reel.controller.play();
          }

          if (visiblePercentage <= 50 && widget.reel.isVideoInitialized) {
            widget.reel.controller.pause();
          }
        },
        child: GestureDetector(
          // onLongPressStart: (details) => widget.onLongPressStart(details, widget.reel),
          onTap: widget.onTap,
          // onTap: () => widget.reel.initialize().then((_) => widget.reel.controller.play()),
          onDoubleTap: () => widget.reel.initialize().then((_) => widget.reel.controller.play()),
          child: Container(
            height: AppConstants.HEIGHT,
            width: AppConstants.WIDTH,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                widget.reel.isVideoInitialized
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: VideoPlayer(widget.reel.controller),
                ) : ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: SizedBox(
                    height: AppConstants.HEIGHT,
                    child: Image.network(
                      widget.reel.thumbnailUrl ?? 'assets/thumbnails/d.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 20,
                    left: 15,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 180,
                          child: Text(
                            "${widget.reel.title} ${widget.reel.id}",
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                        // SizedBox(width: 20,),
                      ],
                    )
                ),
                Positioned(
                  bottom: 20,
                  right: 15,
                  child: Row(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}