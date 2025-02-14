import 'package:flutter/material.dart';
import 'package:heroapp/pages/discover_page/discover_item_page.dart';

class DiscoverItem extends StatefulWidget {
  final String thumbnail;
  const DiscoverItem({super.key, required this.thumbnail});

  @override
  State<DiscoverItem> createState() => _DiscoverItemState();
}

class _DiscoverItemState extends State<DiscoverItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DiscoverItemPage())),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(widget.thumbnail),
            ),
            const Positioned(
              bottom: 15,
              left: 15,
              child: Text(
                "Satisfying Pop 💥",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
