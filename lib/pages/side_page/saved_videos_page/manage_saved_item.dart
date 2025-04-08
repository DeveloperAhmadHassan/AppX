import 'package:flutter/material.dart';
import 'package:loopyfeed/pages/side_page/saved_videos_page/functions.dart';

import '../../../models/reel.dart';
import 'saved_item_page.dart';

class ManageSavedItem extends StatefulWidget {
  final Reel reel;
  final VoidCallback onTap;

  const ManageSavedItem({super.key, required this.reel, required this.onTap});

  @override
  State<ManageSavedItem> createState() => _ManageSavedItemState();
}

class _ManageSavedItemState extends State<ManageSavedItem> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
        if (isChecked) {
          addReel(widget.reel);
        } else {
          removeReel(widget.reel);
        }
      },
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

            Container(
              decoration: BoxDecoration(
                color: isChecked ? Colors.grey.withValues(alpha: 0.5) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Positioned(
              top: 0,
              child: Checkbox(
                activeColor: Colors.black,
                checkColor: Colors.white,
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                  });
                  if (isChecked) {
                    addReel(widget.reel);
                  } else {
                    removeReel(widget.reel);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}