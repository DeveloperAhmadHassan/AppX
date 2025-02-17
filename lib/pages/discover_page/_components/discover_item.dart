import 'package:flutter/material.dart';
import 'package:heroapp/models/reel.dart';
import 'package:heroapp/pages/discover_page/discover_item_page.dart';

class DiscoverItem extends StatefulWidget {
  final Reel reel;
  const DiscoverItem({super.key, required this.reel});

  @override
  State<DiscoverItem> createState() => _DiscoverItemState();
}

class _DiscoverItemState extends State<DiscoverItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DiscoverItemPage(reel: widget.reel)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.reel.thumbnailUrl ?? "",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: Container(
                child: Text(
                  widget.reel.title ?? "Satisfying Pop",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
