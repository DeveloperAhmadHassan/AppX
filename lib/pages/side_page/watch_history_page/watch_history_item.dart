import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../controllers/home_reel_controller.dart';
import '../../../utils/extensions/string.dart';
import '../../../models/reel.dart';

import 'watch_history_item_page.dart';

class WatchHistoryItem extends StatelessWidget {
  final Reel reel;
  final Function removeFromWatchHistoryList;
  const WatchHistoryItem({super.key, required this.reel, required this.removeFromWatchHistoryList});

  @override
  Widget build(BuildContext context) {
    var homeReelController = HomeReelController(Dio());
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
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 140,
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
            onTap: () async {
              await homeReelController.deleteFromWatchHistory(reel);
              removeFromWatchHistoryList(reel);
            },
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(Icons.close, color: Theme.of(context).brightness == Brightness.dark ? Colors.red : Colors.red, size: 20,),
            )
          )
        ],
      ),
    );
  }
}
