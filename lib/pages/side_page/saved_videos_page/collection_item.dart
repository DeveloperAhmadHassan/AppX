import 'package:flutter/material.dart';
import 'package:loopyfeed/models/saved_collection.dart';
import 'package:loopyfeed/pages/side_page/saved_videos_page/saved_videos_by_collection_page.dart';

import '../../../models/reel.dart';
import 'saved_item_page.dart';

class CollectionItem extends StatefulWidget {
  final SavedCollection collection;
  final VoidCallback onTap;

  const CollectionItem({super.key, required this.collection, required this.onTap});

  @override
  State<CollectionItem> createState() => _CollectionItemState();
}
class _CollectionItemState extends State<CollectionItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SavedVideosByCollectionPage(collection: widget.collection,)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 240,
                    width: double.infinity,
                    child: Image.network(
                      widget.collection.thumbnailUrl ?? 'assets/default_thumbnail.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Text(widget.collection.collectionName, style: Theme.of(context).textTheme.titleLarge,)
          ],
        ),
      ),
    );
  }
}
