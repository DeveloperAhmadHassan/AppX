import 'package:flutter/material.dart';

import 'watch_history_item_page.dart';
import '../../../utils/extensions/string.dart';
import '../../../models/reel.dart';

class WatchHistoryItem extends StatelessWidget {
  final Reel reel;
  const WatchHistoryItem({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WatchHistoryItemPage(reel: reel))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(reel.thumbnailUrl!, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 170,
                      child: Text(
                        "${reel.title} ${reel.id}",
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                    Text(
                      reel.dateWatched.toString().toFormattedDate(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                        '${reel.views!.formattedNumber} Views',
                        style: Theme.of(context).textTheme.labelSmall
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            // TODO: Add Remove from watch history functionality
            onTap: () => {},
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(Icons.close, color: Colors.white, size: 20,),
            )
          )
        ],
      ),
    );
  }
}
