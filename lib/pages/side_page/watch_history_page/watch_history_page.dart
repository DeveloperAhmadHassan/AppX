import 'package:flutter/material.dart';
import 'package:heroapp/pages/side_page/watch_history_page/watch_history_item_page.dart';
import 'package:heroapp/utils/extensions/string.dart';

import '../../../database/database_helper.dart';
import '../../../models/reel.dart';

class WatchHistoryPage extends StatelessWidget {
  const WatchHistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Watch History", style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
        )),
      ),
      body: FutureBuilder<List<Reel>>(
        future: DatabaseHelper.instance.getWatchHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No watch history available'));
          } else {
            List<Reel> reels = snapshot.data!;
            return ListView.builder(
              itemCount: reels.length,
              itemBuilder: (context, index) {
                return watchHistoryItem(reels[index], context);
              },
            );
          }
        },
      ),
    );
  }

  Widget watchHistoryItem(Reel reel, BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WatchHistoryItemPage(reel: reel))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                  width: 180,
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
            )
          ],
        ),
      ),
    );
  }
}
