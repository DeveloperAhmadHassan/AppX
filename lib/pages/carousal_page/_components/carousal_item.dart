import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../models/reel.dart';
import '../../../utils/constants.dart';


class CarousaItem extends StatefulWidget {
  final int xIndex;
  final int yIndex;
  final Reel reel;
  final Function(LongPressStartDetails details, String text) onLongPressStart;

  const CarousaItem({
    super.key,
    required this.xIndex,
    required this.yIndex,
    required this.onLongPressStart,
    required this.reel
  });

  @override
  _CarousaItemState createState() => _CarousaItemState();
}

class _CarousaItemState extends State<CarousaItem> {
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
            print("Initializing");

            widget.reel.initialize();
          }

          if (visiblePercentage >= 90 && widget.reel.isVideoInitialized) {
            print("Playing");

            widget.reel.controller.play();
          }

          if (visiblePercentage <= 50 && widget.reel.isVideoInitialized) {
            print("Pausing");

            widget.reel.controller.pause();
          }
          // if(visiblePercentage == 100){
          //   Text("", strutStyle: StrutStyle(
          //
          //   ),);
          // }

          // if (visiblePercentage <= 20 && widget.reel.isVideoInitialized) {
          //   print("Disposing");
          //
          //   widget.reel.dispose();
          // }
          // if(visiblePercentage >= 100){
          //   await widget.reel.controller.play();
          // }

          // print('Widget ${visibilityInfo.key} is $visiblePercentage% visible');
        },
        child: GestureDetector(
          onLongPressStart: (details) => widget.onLongPressStart(details, "${widget.xIndex}, ${widget.yIndex}"),
          onTap: () => widget.reel.initialize().then((_) => widget.reel.controller.play()),
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
                    child: Image.asset(
                      widget.reel.thumbnailUrl ?? 'assets/thumbnails/d.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Satisfying Pop ${widget.xIndex}${widget.yIndex} 💥", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      )),
                      SizedBox(width: 40,),
                      Row(
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_red_eye_outlined, size: 25, color: Colors.white),
                                onPressed: () => {
                                  print("${widget.xIndex}")
                                },
                              ),
                              Text("74K", style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),)
                            ],
                          ),
                          Column(
                            // spacing: -15.0,
                            children: [
                              IconButton(
                                icon: Icon(Icons.favorite_border_outlined, size: 25, color: Colors.white),
                                onPressed: () => {
                                  print("${widget.xIndex}")
                                },
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
                  )
                )
              ],
            ),
          ),
        ),

      ),
    );
  }
}
