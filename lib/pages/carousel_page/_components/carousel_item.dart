import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'functions.dart';
import 'globals.dart';
import '../../../pages/carousel_page/_components/carousel_thumbnail.dart';
import '../../../utils/extensions/string.dart';
import '../../../controllers/carousel_reel_controller.dart';
import '../../../models/reel.dart';
import '../../../utils/constants.dart';

class CarousalItem extends StatefulWidget {
  final int xIndex;
  final int yIndex;
  final Reel reel;
  final VoidCallback onTap;

  const CarousalItem({
    super.key,
    required this.xIndex,
    required this.yIndex,
    required this.reel,
    required this.onTap
  });

  @override
  State<CarousalItem> createState() => _CarousalItemState();
}

class _CarousalItemState extends State<CarousalItem> {
  double _width = 30;
  double _height = 30;
  double _opacity = 0.5;
  late CarouselReelController _carouselReelController;

  @override
  void initState() {
    super.initState();
    _carouselReelController = CarouselReelController(Dio());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, bottom: 25.0, left: 25.0, right: 25.0),
      child: Container(
        height: AppConstants.HEIGHT + 30,
        width: AppConstants.WIDTH + 10,
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(30),
            // border: Border.all(color: Colors.white, width: 2.0)
        ),
        child: VisibilityDetector(
          key: Key('item-${widget.xIndex}${widget.yIndex}-key'),
          onVisibilityChanged: (visibilityInfo) {
            var visiblePercentage = visibilityInfo.visibleFraction * 100;

            if (visiblePercentage >= 90) {
              setState(() {
                _opacity = 1.0;
              });
              if (reel.value.reelUrl != widget.reel.reelUrl) {
                videoFuture.value = play(widget.reel.reelUrl);
                reel.value = widget.reel;
              }
              else {
                if (mounted) {
                  setState(() {
                    if(widget.reel.reelUrl == reel.value.reelUrl) {
                      videoPlayerController.play();
                    }
                  });
                }
              }
            }

            if (visiblePercentage <= 50) {
              if (mounted) {
                setState(() {
                  _opacity = 0.5;
                  if(widget.reel.reelUrl == reel.value.reelUrl) {
                    videoPlayerController.pause();
                  }
                });
              }
            }

            if (visiblePercentage >= 1) {
              setState(() {
                _width = AppConstants.WIDTH;
                _height = AppConstants.HEIGHT;
              });
            }
          },
          child: Center(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(milliseconds: 600),
              child: AnimatedContainer(
                // padding: EdgeInsets.all(10.0),
                height: _opacity == 1.0 ? 630 : _height,
                width: _opacity == 1.0 ? 310 : _width,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(30),
                  // border: Border.all(color: Colors.white, width: 2.0)
                ),
                duration: Duration(milliseconds: 600, ),
                curve: Curves.fastEaseInToSlowEaseOut,
                child: ValueListenableBuilder(
                  valueListenable: videoFuture,
                  builder: (context, value, child) {
                    return value == null ? CarouselThumbnail(thumbnailUrl: "assets/thumbnails/Artsy.jpg") : FutureBuilder(
                      future: value,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ValueListenableBuilder(
                            valueListenable: reel,
                            builder: (context, value, child) {
                              return value.reelUrl.isEmpty ? CarouselThumbnail(thumbnailUrl: "assets/thumbnails/Artsy.jpg") : CarouselThumbnail(thumbnailUrl: "assets/thumbnails/Artsy.jpg");
                            });
                        } else {
                          return CarouselThumbnail(thumbnailUrl: "assets/thumbnails/Artsy.jpg");
                        }
                      });
                  }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
