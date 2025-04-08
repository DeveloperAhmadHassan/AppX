import 'package:flutter/material.dart';
import 'package:loopyfeed/utils/assets.dart';

import '../constants.dart';

class FullLogo extends StatelessWidget {
  final double size;
  const FullLogo({super.key, this.size = 110});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // color: HexColor.fromHex(AppConstants.primaryColor)
            ),
            child: Image.asset(Theme.of(context).brightness == Brightness.dark ? Assets.iconsPrimaryLogo : Assets.iconsPrimaryLogoLight, fit: BoxFit.contain,),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // color: HexColor.fromHex(AppConstants.primaryColor)
            ),
            child: Image.asset(Theme.of(context).brightness == Brightness.dark ? Assets.iconsSecondaryLogo : Assets.iconsSecondaryLogoLight, fit: BoxFit.contain,),
          ),
        ],
      ),
    );
  }
}
