import 'package:flutter/material.dart';
import 'package:heroapp/pages/side_page/liked_videos_page/liked_item_page.dart';

import '../../../models/reel.dart';
import '../../../repository/reel_repository.dart';

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
        title: Text(
          "Liked Videos",
          style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Reel>>(
        future: likedVideos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No liked videos"));
          } else {
            List<Reel> reels = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
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
                Navigator.pop(context);
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

class LikedItem extends StatefulWidget {
  final Reel reel;
  final VoidCallback onTap;

  const LikedItem({super.key, required this.reel, required this.onTap});

  @override
  State<LikedItem> createState() => _LikedItemState();
}

class _LikedItemState extends State<LikedItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LikedItemPage(reel: widget.reel))),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.reel.thumbnailUrl ?? 'assets/default_thumbnail.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
