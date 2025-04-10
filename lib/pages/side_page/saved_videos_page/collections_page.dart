import 'package:flutter/material.dart';
import 'package:loopyfeed/models/saved_collection.dart';
import 'package:loopyfeed/pages/side_page/saved_videos_page/collection_item.dart';
import 'package:loopyfeed/utils/components/no_items_found.dart';

import '../../../models/reel.dart';
import '../../../repository/reel_repository.dart';
import 'add_collection_page.dart';
import 'saved_item.dart';

class CollectionsPage extends StatefulWidget {
  final TabController tabController;
  final Function(Reel) onReelSelected;
  final Function() onSideMenuClick;
  const CollectionsPage({super.key, required this.tabController, required this.onReelSelected, required this.onSideMenuClick});

  @override
  State<CollectionsPage> createState() => _LikedVideosPageState();
}

class _LikedVideosPageState extends State<CollectionsPage> {
  final ReelRepository reelRepository = ReelRepository();
  late Future<List<SavedCollection>> collections;

  @override
  void initState() {
    super.initState();
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
          Padding(
            padding: EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddCollectionPage()));
              },
              icon: Icon(Icons.add, size: 34,),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 0.0),
              child: Text(
                "collections",
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

                  return collections.isNotEmpty ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                        child: itemGrid(collections),
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

  Widget itemGrid(List<SavedCollection> collections) {
    return SizedBox(
      child: GridView.builder(
        itemCount: collections.length,
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
            child: CollectionItem(
              collection: collections[index],
              onTap: () async {
                // await widget.onReelSelected(collections[index]);
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
