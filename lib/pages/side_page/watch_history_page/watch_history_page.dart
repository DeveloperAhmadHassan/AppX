import 'package:flutter/material.dart';

import 'watch_history_item.dart';
import '../../../repository/reel_repository.dart';
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
        future: ReelRepository().getWatchHistory(),
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
                return WatchHistoryItem(reel: reels[index],);
              },
            );
          }
        },
      ),
    );
  }

}
