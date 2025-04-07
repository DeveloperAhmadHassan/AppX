import 'package:flutter/material.dart';
import 'package:loopyfeed/utils/constants.dart';
import 'package:loopyfeed/utils/extensions/color.dart';

import '../../../models/reel.dart';

class DiscoverItem extends StatelessWidget {
  final Reel reel;
  final VoidCallback onTap;

  const DiscoverItem({super.key, required this.reel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // width: 300,
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
              child: Text(
                "${reel.title} ${reel.id}",
                style: TextStyle(
                  color: HexColor.fromHex(AppConstants.primaryWhite),
                  fontWeight: FontWeight.bold,
                  fontSize: 15
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
