import 'package:flutter/material.dart';
import 'package:heroapp/models/reel.dart';

class DiscoverItem extends StatelessWidget {
  final Reel reel;
  final VoidCallback onTap;

  const DiscoverItem({super.key, required this.reel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: Container(
                child: Text(
                  "${reel.title} ${reel.id}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
