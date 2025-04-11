import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:loopyfeed/utils/extensions/color.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../utils/assets.dart';
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
        width: AppConstants.WIDTH + 30,
        decoration: BoxDecoration(
          // color: HexColor.fromHex(AppConstants.graySwatch1),
            // borderRadius: BorderRadius.circular(30),
            // border: Border.all(color: HexColor.fromHex(AppConstants.primaryWhite), width: 2.0)
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
                width: _opacity == 1.0 ? 330 : _width,
                decoration: BoxDecoration(
                  // color: HexColor.fromHex(AppConstants.graySwatch1),
                  // borderRadius: BorderRadius.circular(30),
                  // border: Border.all(color: HexColor.fromHex(AppConstants.primaryWhite), width: 2.0)
                ),
                duration: Duration(milliseconds: 600, ),
                curve: Curves.fastEaseInToSlowEaseOut,
                child: ValueListenableBuilder(
                  valueListenable: videoFuture,
                  builder: (context, value, child) {
                    return value == null ? CarouselThumbnail(thumbnailUrl: widget.reel.thumbnailUrl!) : FutureBuilder(
                      future: value,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ValueListenableBuilder(
                            valueListenable: reel,
                            builder: (context, value, child) {
                              return value.reelUrl.isEmpty ? CarouselThumbnail(thumbnailUrl: widget.reel.thumbnailUrl!) : GestureDetector(
                                onTap: widget.onTap,
                                child: ((value.x == widget.xIndex) && (value.y == widget.yIndex)) ? Container(
                                  height: AppConstants.HEIGHT,
                                  width: AppConstants.WIDTH,
                                  decoration: BoxDecoration(
                                    color: HexColor.fromHex(AppConstants.graySwatch1),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: VideoPlayer(
                                          videoPlayerController,
                                          key: Key("reel-${widget.reel.id}-coordinates-${widget.xIndex}${widget.yIndex}-key"),
                                        ),
                                      ),
                                      // Positioned.fill(
                                      //   child: Container(
                                      //     decoration: BoxDecoration(
                                      //       borderRadius: BorderRadius.circular(20),
                                      //       gradient: LinearGradient(
                                      //         begin: Alignment.topCenter,
                                      //         end: Alignment.bottomCenter,
                                      //         colors: [
                                      //           Colors.transparent,
                                      //           Colors.transparent,
                                      //           Colors.black.withValues(alpha: 0.75),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      Positioned(
                                        bottom: 20,
                                        left: 15,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            // SizedBox(
                                            //   width: 180,
                                            //   child: Text(
                                            //     "${widget.reel.title} ${widget.reel.id}",
                                            //     style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            //       color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryBlack) : HexColor.fromHex(AppConstants.primaryWhite),
                                            //     ),
                                            //     overflow: TextOverflow.ellipsis,
                                            //     maxLines: 1,
                                            //     softWrap: false,
                                            //   ),
                                            // ),
                                          ],
                                        ),
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
                                                LikeButton(
                                                  size: 25,
                                                  isLiked: widget.reel.isLiked,
                                                  onTap: (isCurrentlyLiked) async {
                                                    if (isCurrentlyLiked) {
                                                      _carouselReelController.unlikeVideo(widget.reel);
                                                    } else {
                                                      _carouselReelController.likeVideo(widget.reel);
                                                    }
                                                    setState(() {
                                                      widget.reel.isLiked = !isCurrentlyLiked;
                                                    });
                                                    return widget.reel.isLiked;
                                                  },
                                                  likeBuilder: (isLiked) {
                                                    return Icon(
                                                      isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                                                      color: isLiked ? Colors.red : Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryWhite),
                                                      size: 20,
                                                    );
                                                  },
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(top: 0.0),
                                                  child: Text(
                                                    widget.reel.likes!.formattedNumber,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 13,
                                                      color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryWhite)
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 12,),
                                                SvgPicture.asset(
                                                  Assets.iconsShare,
                                                  semanticsLabel: 'Share Logo',
                                                  height: 20,
                                                  width: 20,
                                                  colorFilter: ColorFilter.mode(
                                                      Theme.of(context).brightness == Brightness.dark
                                                          ? HexColor.fromHex(AppConstants.primaryWhite)
                                                          : HexColor.fromHex(AppConstants.primaryWhite),
                                                      BlendMode.srcIn
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(top: 0.0),
                                                  child: Text(
                                                    widget.reel.likes!.formattedNumber,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 13,
                                                      color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryWhite)
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                // SizedBox(height: 16)
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ) : CarouselThumbnail(thumbnailUrl: widget.reel.thumbnailUrl!),
                              );
                            });
                        } else {
                          return CarouselThumbnail(thumbnailUrl: widget.reel.thumbnailUrl!);
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
