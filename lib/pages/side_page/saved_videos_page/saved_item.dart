import 'package:flutter/material.dart';

import '../../../models/reel.dart';
import 'saved_item_page.dart';

class SavedItem extends StatefulWidget {
  final Reel reel;
  final VoidCallback onTap;

  const SavedItem({super.key, required this.reel, required this.onTap});

  @override
  State<SavedItem> createState() => _SavedItemState();
}

class _SavedItemState extends State<SavedItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SavedItemPage(reel: widget.reel))),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.reel.thumbnailUrl ?? 'assets/default_thumbnail.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}