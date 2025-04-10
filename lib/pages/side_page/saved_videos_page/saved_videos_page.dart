import 'package:flutter/material.dart';
import 'package:loopyfeed/models/saved_collection.dart';
import 'package:loopyfeed/pages/side_page/saved_videos_page/add_collection_page.dart';
import 'package:loopyfeed/pages/side_page/saved_videos_page/collections_page.dart';
import 'package:loopyfeed/pages/side_page/saved_videos_page/saved_videos_by_collection_page.dart';
import 'package:loopyfeed/utils/components/no_items_found.dart';
import 'package:loopyfeed/utils/constants.dart';
import 'package:loopyfeed/utils/extensions/color.dart';

import '../../../models/reel.dart';
import '../../../repository/reel_repository.dart';
import 'manage_saved_videos_page.dart';
import 'saved_item.dart';

class SavedVideosPage extends StatefulWidget {
  final TabController tabController;
  final Function(Reel) onReelSelected;
  final Function() onSideMenuClick;
  const SavedVideosPage({super.key, required this.tabController, required this.onReelSelected, required this.onSideMenuClick});

  @override
  State<SavedVideosPage> createState() => _LikedVideosPageState();
}

class _LikedVideosPageState extends State<SavedVideosPage> {
  final ReelRepository reelRepository = ReelRepository();
  late Future<List<Reel>> savedVideos;
  late Future<List<SavedCollection>> collections;

  @override
  void initState() {
    super.initState();
    savedVideos = reelRepository.getSavedVideos();
    collections = reelRepository.getCollections();
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
          Container(
            margin: EdgeInsets.only(top: 8.0, right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddCollectionPage()));
              },
              icon: Icon(Icons.add, size: 34,),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 0.0),
              child: Text(
                "saved videos",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            FutureBuilder<List<SavedCollection>>(
              future: collections,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  List<SavedCollection> collections = snapshot.data!;

                  return collections.isNotEmpty ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>CollectionsPage(tabController: widget.tabController, onReelSelected: widget.onReelSelected, onSideMenuClick: widget.onSideMenuClick)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  "Collections",
                                  style: Theme.of(context).textTheme.titleLarge
                                ),
                                Spacer(),
                                Icon(Icons.chevron_right, size: 34,),
                              ],
                            ),
                          ),
                        ),

                        GridView.builder(
                          itemCount: collections.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          // padding: EdgeInsets.only(top: spacing),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                            childAspectRatio: 100 / 40,
                          ),
                          itemBuilder: (context, index) {
                            final collection = collections[index];
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SavedVideosByCollectionPage(collection: collection,)));
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(collection.thumbnailUrl.toString()),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(collection.collectionName),
                                        collection.isPublic == 1 ? Row(
                                          children: [
                                            Icon(Icons.people, size: 15, color: Colors.white54,),
                                            SizedBox(width: 10,),
                                            Text("Public", style: TextStyle(
                                                color: Colors.white54
                                            ),)
                                          ],
                                        ) : Row(
                                          children: [
                                            Icon(Icons.lock, size: 15, color: Colors.white54,),
                                            SizedBox(width: 10,),
                                            Text("Private", style: TextStyle(
                                                color: Colors.white54
                                            ),)
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ) : Container();
                }
              },
            ),
            FutureBuilder<List<Reel>>(
              future: savedVideos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  List<Reel> reels = snapshot.data!;

                  return reels.isNotEmpty ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            Text(
                                "Reels",
                                style: Theme.of(context).textTheme.titleLarge
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.push(context,  MaterialPageRoute(builder: (context)=>ManageSavedVideosPage(tabController: widget.tabController, onReelSelected: widget.onReelSelected, onSideMenuClick: widget.onSideMenuClick)));
                              },
                              child: Text("Manage", style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryColor) : HexColor.fromHex(AppConstants.primaryBlack)
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
                  ) : NoItemsFound(tabController: widget.tabController, onSideMenuClick: widget.onSideMenuClick, pageTitle: "", title: "No Saved Videos Found!");
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
