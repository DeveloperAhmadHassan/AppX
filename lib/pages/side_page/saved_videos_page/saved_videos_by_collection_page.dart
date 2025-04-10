import 'package:flutter/material.dart';
import 'package:loopyfeed/models/saved_collection.dart';
import 'package:loopyfeed/pages/side_page/saved_videos_page/edit_collection_page.dart';

import '../../../models/reel.dart';
import '../../../repository/reel_repository.dart';
import 'saved_item.dart';

class SavedVideosByCollectionPage extends StatefulWidget {

  final SavedCollection collection;
  const SavedVideosByCollectionPage({super.key, required this.collection});

  @override
  State<SavedVideosByCollectionPage> createState() => _LikedVideosPageState();
}

class _LikedVideosPageState extends State<SavedVideosByCollectionPage> {
  final ReelRepository reelRepository = ReelRepository();
  late Future<List<Reel>> savedVideos;

  @override
  void initState() {
    super.initState();
    savedVideos = reelRepository.getSavedVideosByCollection(widget.collection.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 34),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded, size: 34),
              onSelected: (value) {
                // Handle your menu actions here
                if (value == 'option1') {
                } else if (value == 'option2') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditCollectionPage(collection: widget.collection,)));
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'option1',
                  child: Text('Manage Reels'),
                ),
                const PopupMenuItem<String>(
                  value: 'option2',
                  child: Text('Edit Collection'),
                ),
                const PopupMenuItem<String>(
                  value: 'option3',
                  child: Text('Delete Collection'),
                ),
                const PopupMenuItem<String>(
                  value: 'option4',
                  child: Text('Select...'),
                ),
              ],
            ),
          ),
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

                  return  Column(
                    children: [
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
