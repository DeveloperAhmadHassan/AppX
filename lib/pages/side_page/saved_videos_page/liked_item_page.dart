import 'package:flutter/material.dart';

import '../../../models/reel.dart';
import '../../../utils/components/clicked_item.dart';

class LikedItemPage extends StatefulWidget {
  final Reel reel;
  const LikedItemPage({super.key, required this.reel});

  @override
  State<LikedItemPage> createState() => _LikedItemPageState();
}

class _LikedItemPageState extends State<LikedItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liked Videos", style: TextStyle(
          fontSize: 18
      )),
      ),
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
