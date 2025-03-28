import 'package:flutter/material.dart';

import '../../../repository/reel_repository.dart';
import '../../../models/reel.dart';

import 'watch_history_item.dart';

//ignore: must_be_immutable
class WatchHistoryPage extends StatefulWidget {
  WatchHistoryPage({super.key});
  late List<Reel> reels = [];

  @override
  State<WatchHistoryPage> createState() => _WatchHistoryPageState();
}

class _WatchHistoryPageState extends State<WatchHistoryPage> {
  void removeFromWatchHistoryList(Reel reel) {
    setState(() {
      widget.reels.remove(reel);
    });
  }
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
            widget.reels = snapshot.data!;
            return ListView.builder(
              itemCount: widget.reels.length,
              itemBuilder: (context, index) {
                return WatchHistoryItem(reel: widget.reels[index], removeFromWatchHistoryList: removeFromWatchHistoryList);
              },
            );
          }
        },
      ),
    );
  }
}
