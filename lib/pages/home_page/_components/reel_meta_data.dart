import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:loopyfeed/services/notification_service.dart';

import '../../../controllers/home_reel_controller.dart';
import '../../../models/reel.dart';
import '../../../models/saved_collection.dart';
import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';
import '../../../utils/extensions/string.dart';
import '../../../utils/assets.dart';

import '../../side_page/saved_videos_page/saved_videos_by_collection_page.dart';
import 'bookmark_bottom_sheet.dart';

class ReelMetaData extends StatefulWidget {
  final Reel reel;
  final HomeReelController homeReelController;
  const ReelMetaData({super.key, required this.reel, required this.homeReelController});

  @override
  State<ReelMetaData> createState() => _ReelMetaDataState();
}

class _ReelMetaDataState extends State<ReelMetaData> {
  bool isCurrentlySaved = false;

  @override
  void initState() {
    super.initState();
    isCurrentlySaved = widget.reel.isSaved ?? false;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            // color: Colors.red,
            // margin: EdgeInsets.only(top: 25),
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
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      widget.reel.likes!.formattedNumber,
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
                  SizedBox(height: 10),
                  SizedBox(
                    height: 20,
                    width: 40,
                    child: InkWell(
                      child: Icon(!isCurrentlySaved ? Icons.bookmark_border_outlined : Icons.bookmark, size: 25, color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack),),
                      onTap: () async {
                        if(!isCurrentlySaved) {
                          isCurrentlySaved = !isCurrentlySaved;
                          widget.homeReelController.saveVideo(widget.reel);
                        } else {
                          widget.homeReelController.unSaveVideo(widget.reel);
                        }
                        final res = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          constraints: BoxConstraints(
                            maxHeight: 700,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (BuildContext context) {
                            return BookmarkBottomSheet(
                              isSaved: isCurrentlySaved,
                              reelId: int.parse(widget.reel.id != null ? widget.reel.id! : "1"),
                              thumbnailUrl: widget.reel.thumbnailUrl ?? "",
                              onToggleSave: () {
                                setState(() {
                                  isCurrentlySaved = !isCurrentlySaved;
                                });
                                Navigator.pop(context);
                              },
                              parentContext: context,
                            );
                          },
                        );

                        if(res is SavedCollection) {
                          final snackBar = SnackBar(
                            content: RichText(text: TextSpan(
                                style: Theme.of(context).textTheme.titleLarge,
                                children: [
                                  TextSpan(text: 'Reel Added to '),
                                  TextSpan(text: res.collectionName, style: TextStyle(color: HexColor.fromHex(AppConstants.primaryColor))),
                                ]
                            )),
                            backgroundColor: HexColor.fromHex(AppConstants.primaryBlack),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: "View",
                              textColor: HexColor.fromHex(AppConstants.primaryColor),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(builder: (_) => SavedVideosByCollectionPage(collection: res,)),
                                );
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },

                    ),
                  ),
                  SizedBox(height: 4),
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
                  // SizedBox(height: 10),
                  SizedBox(
                    // height: 28,
                    // width: 40,
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 12,),
                          InkWell(
                            onTap: () {
                              print("send notification");

                              // NotificationService().showNotification(
                              //   title: widget.reel.title,
                              //   body: "This is some description",
                              // );
                              NotificationService().showNativeCustomNotification(
                                title: widget.reel.title ?? "Title not found!!!",
                                body: "This is some description",
                              );
                            },
                            child: SvgPicture.asset(
                              Assets.iconsShare,
                              semanticsLabel: 'Share Logo',
                              height: 20,
                              width: 20,
                              colorFilter: ColorFilter.mode(
                              Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex(AppConstants.primaryWhite)
                                  : HexColor.fromHex(AppConstants.primaryBlack),
                              BlendMode.srcIn
                              ),
                            ),
                          ),
                          // SizedBox(height: 16)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      widget.reel.views!.formattedNumber,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }
}
