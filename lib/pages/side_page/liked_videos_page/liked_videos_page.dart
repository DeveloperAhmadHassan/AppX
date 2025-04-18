import 'package:flutter/material.dart';
import 'package:loopyfeed/utils/components/no_items_found.dart';
import 'package:loopyfeed/utils/extensions/color.dart';

import '../../../utils/assets.dart';
import '../../../models/reel.dart';
import '../../../repository/reel_repository.dart';
import '../../../utils/constants.dart';
import 'liked_item.dart';

class LikedVideosPage extends StatefulWidget {
  final TabController tabController;
  final Function(Reel) onReelSelected;
  final Function() onSideMenuClick;
  const LikedVideosPage({super.key, required this.tabController, required this.onReelSelected, required this.onSideMenuClick});

  @override
  State<LikedVideosPage> createState() => _LikedVideosPageState();
}

class _LikedVideosPageState extends State<LikedVideosPage> {
  final ReelRepository reelRepository = ReelRepository();
  late Future<List<Reel>> likedVideos;

  @override
  void initState() {
    super.initState();
    likedVideos = reelRepository.getLikedVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 34,),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: FutureBuilder<List<Reel>>(
        future: likedVideos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return NoItemsFound(
              tabController: widget.tabController,
              onSideMenuClick: widget.onSideMenuClick,
              pageTitle: "liked videos",
              title: "No Liked Videos Found!",
            );
          } else {
            List<Reel> reels = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, bottom: 0.0),
                    child: Text(
                      "liked videos",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                    child: itemGrid(reels),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget itemGrid(List<Reel> reels) {
    return SizedBox(
      child: GridView.builder(
        itemCount: reels.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          crossAxisCount: 2,
          childAspectRatio: (MediaQuery.of(context).size.width + 40) /
              (MediaQuery.of(context).size.height / 1.4),
        ),
        itemBuilder: (context, index) {
          return Center(
            child: LikedItem(
              reel: reels[index],
              onTap: () async {
                await widget.onReelSelected(reels[index]);
                if(context.mounted){
                  Navigator.pop(context);
                }
                widget.onSideMenuClick();
                Future.delayed(const Duration(milliseconds: 800), () {
                  widget.tabController.animateTo(1);
                });
              },
            )
          );
        },
      ),
    );
  }
}
