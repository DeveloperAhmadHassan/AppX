import 'package:flutter/material.dart';
import 'package:loopyfeed/models/saved_collection.dart';
import 'package:loopyfeed/pages/side_page/saved_videos_page/collections_page.dart';
import 'package:loopyfeed/utils/components/no_items_found.dart';

import '../../../models/reel.dart';
import '../../../repository/reel_repository.dart';
import 'saved_item.dart';

class SavedVideosByCollectionPage extends StatefulWidget {

  final int collectionId;
  const SavedVideosByCollectionPage({super.key, required this.collectionId});

  @override
  State<SavedVideosByCollectionPage> createState() => _LikedVideosPageState();
}

class _LikedVideosPageState extends State<SavedVideosByCollectionPage> {
  final ReelRepository reelRepository = ReelRepository();
  late Future<List<Reel>> savedVideos;

  @override
  void initState() {
    super.initState();
    savedVideos = reelRepository.getSavedVideosByCollection(widget.collectionId);
    print("collection: ${widget.collectionId}");
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
        actions: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.add, size: 34,),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Reel>>(
              future: savedVideos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  List<Reel> reels = snapshot.data!;

                  print(reels);

                  return  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Text(
                                "Reels",
                                style: Theme.of(context).textTheme.titleLarge
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {},
                              child: Text("Manage", style: TextStyle(
                                  color: Colors.blue
                              ),),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                        child: itemGrid(reels),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
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
            child: SavedItem(
              reel: reels[index],
              onTap: () async {
                // await widget.onReelSelected(reels[index]);
                if(context.mounted){
                  Navigator.pop(context);
                }
                // widget.onSideMenuClick();
                Future.delayed(const Duration(milliseconds: 800), () {
                  // widget.tabController.animateTo(1);
                });
              },
            )
          );
        },
      ),
    );
  }
}
