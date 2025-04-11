import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class CarouselThumbnail extends StatelessWidget {
  final String thumbnailUrl;
  const CarouselThumbnail({super.key, required this.thumbnailUrl});

  @override
  Widget build(BuildContext context) {
    return Container(

      height: AppConstants.HEIGHT,
      width: AppConstants.WIDTH,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          thumbnailUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

