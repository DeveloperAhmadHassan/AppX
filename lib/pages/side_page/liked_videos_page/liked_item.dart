import 'package:flutter/material.dart';

import '../../../models/reel.dart';
import 'liked_item_page.dart';

class LikedItem extends StatefulWidget {
  final Reel reel;
  final VoidCallback onTap;

  const LikedItem({super.key, required this.reel, required this.onTap});

  @override
  State<LikedItem> createState() => _LikedItemState();
}

class _LikedItemState extends State<LikedItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LikedItemPage(reel: widget.reel))),
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