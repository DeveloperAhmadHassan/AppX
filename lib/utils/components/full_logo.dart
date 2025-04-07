import 'package:flutter/material.dart';

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
            child: Image.asset(AppConstants.iconsPrimaryLogo, fit: BoxFit.contain,),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // color: HexColor.fromHex(AppConstants.primaryColor)
            ),
            child: Image.asset(AppConstants.iconsSecondaryLogo, fit: BoxFit.contain,),
          ),
        ],
      ),
    );
  }
}
