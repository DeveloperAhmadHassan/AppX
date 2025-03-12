import 'package:flutter/material.dart';

import 'category_reel_page.dart';
import '../../../models/reel.dart';

class CategoryReelItem extends StatelessWidget {
  final Reel reel;

  const CategoryReelItem({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryReelPage(reel: reel))),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                reel.thumbnailUrl ?? "",
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: Text(
                "${reel.title} ${reel.id}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}