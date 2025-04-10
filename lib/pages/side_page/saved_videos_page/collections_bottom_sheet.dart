import 'package:flutter/material.dart';
import 'package:loopyfeed/pages/home_page/_components/save_details_page.dart';
import 'package:loopyfeed/pages/side_page/saved_videos_page/globals.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../models/saved_collection.dart';
import '../../../repository/reel_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';

class CollectionsBottomSheet extends StatefulWidget {
  final String thumbnailUrl;
  final int reelId;
  final VoidCallback onToggleSave;

  const CollectionsBottomSheet({super.key, required this.thumbnailUrl, required this.onToggleSave, required this.reelId});

  @override
  State<CollectionsBottomSheet> createState() => _CollectionsBottomSheetState();
}

class _CollectionsBottomSheetState extends State<CollectionsBottomSheet> {
  final ReelRepository reelRepository = ReelRepository();
  late Future<List<SavedCollection>> collections;
  bool foundCollections = false;

  @override
  void initState() {
    super.initState();
    collections = reelRepository.getCollections();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            // color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.black12,
            child: Column(
              children: [
                SizedBox(height: 18,),
                Icon(Icons.maximize_rounded, size: 35, color: Colors.grey,),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    children: [
                      Spacer(),
                      Text("Add to collection", style: Theme.of(context).textTheme.titleLarge,),
                      Spacer(),
                      Icon(Icons.add)
                    ],
                  ),
                )
              ],
            ),
          ),
          FutureBuilder<List<SavedCollection>>(
            future: collections,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasData && snapshot.data != null) {
                final collections = snapshot.data!;
                final foundCollections = collections.isNotEmpty;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      GridView.builder(
                        itemCount: collections.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          // childAspectRatio: 1/3
                        ),
                        itemBuilder: (context, index) {
                          final collection = collections[index];
                          return InkWell(
                            onTap: () async {
                              await reelRepository.addManyToCollection(collection.id, reelIds.value);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 80,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(collection.thumbnailUrl),
                                    ),
                                  ),
                                  // SizedBox(width: 10),
                                  Text(collection.collectionName),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return Expanded(child: Center(child: Text("Something went wrong.")));
              }
            },
          )

        ],
      ),
    );
  }
}