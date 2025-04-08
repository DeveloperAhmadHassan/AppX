import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';
import 'reels_by_category_page.dart';
import '../../../models/category.dart';

class CategoryItem extends StatelessWidget {
  final double height;
  final double width;
  final Category category;

  const CategoryItem({super.key, required this.height, required this.width, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReelsByCategoryPage(category: "${category.title}"))),
        child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue,
              image: DecorationImage(
                image: AssetImage(category.thumbnailUrl ?? "https://example.com/your-image-url.jpg"),
                fit: BoxFit.cover,
              ),
            ),

            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: HexColor.fromHex(AppConstants.primaryBlack).withValues(alpha: 0.3),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "${category.title}",
                        style: TextStyle(
                          color: HexColor.fromHex(AppConstants.primaryWhite),
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}