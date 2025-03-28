import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';

import '../../../controllers/home_reel_controller.dart';
import '../../../models/reel.dart';
import '../../../utils/extensions/string.dart';
import '../../../utils/assets.dart';

class ReelMetaData extends StatefulWidget {
  final Reel reel;
  final HomeReelController homeReelController;
  const ReelMetaData({super.key, required this.reel, required this.homeReelController});

  @override
  State<ReelMetaData> createState() => _ReelMetaDataState();
}

class _ReelMetaDataState extends State<ReelMetaData> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 13.0, right: 20.0, top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.8,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      widget.reel.views!.formattedNumber,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 7),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  LikeButton(
                    size: 25,
                    isLiked: widget.reel.isLiked,
                    onTap: (isCurrentlyLiked) async {
                      if (isCurrentlyLiked) {
                        widget.homeReelController.unlikeVideo(widget.reel);
                      } else {
                        widget.homeReelController.likeVideo(widget.reel);
                      }
                      setState(() {
                        widget.reel.isLiked = !isCurrentlyLiked;
                      });
                      return widget.reel.isLiked;
                    },
                    likeBuilder: (isLiked) {
                      return Icon(
                        isLiked
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: isLiked
                            ? Colors.red
                            : Theme.of(context).iconTheme.color,
                        size: 25,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Text(
                      widget.reel.likes!.formattedNumber,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 7),
              InkWell(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8,),
                    SvgPicture.asset(
                      Assets.iconsShare,
                      semanticsLabel: 'Share Logo',
                      height: 26,
                      width: 26,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          BlendMode.srcIn
                      ),
                    ),
                    SizedBox(height: 16)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
