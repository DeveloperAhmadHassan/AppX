import 'package:flutter/material.dart';

import '../../../models/reel.dart';
import '../../../utils/components/clicked_item.dart';

class WatchHistoryItemPage extends StatefulWidget {
  final Reel reel;
  const WatchHistoryItemPage({super.key, required this.reel});

  @override
  State<WatchHistoryItemPage> createState() => _WatchHistoryItemPageState();
}

class _WatchHistoryItemPageState extends State<WatchHistoryItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Watch History", style: TextStyle(
          fontSize: 18
        )),
      ),
      // backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClickedItem(reel: widget.reel,)
          ],
        ),
      ),
    );
  }
}

