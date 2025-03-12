import 'package:flutter/material.dart';

import '../../../utils/components/clicked_item.dart';
import '../../../models/reel.dart';

class CategoryReelPage extends StatefulWidget {
  final Reel reel;
  const CategoryReelPage({super.key, required this.reel});

  @override
  State<CategoryReelPage> createState() => _CategoryReelPageState();
}

class _CategoryReelPageState extends State<CategoryReelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trending", style: TextStyle(
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