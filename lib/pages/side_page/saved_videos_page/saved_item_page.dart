import 'package:flutter/material.dart';

import '../../../models/reel.dart';
import '../../../utils/components/clicked_item.dart';

class SavedItemPage extends StatefulWidget {
  final Reel reel;
  const SavedItemPage({super.key, required this.reel});

  @override
  State<SavedItemPage> createState() => _SavedItemPageState();
}

class _SavedItemPageState extends State<SavedItemPage> {
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
