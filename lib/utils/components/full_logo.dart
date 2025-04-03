import 'package:flutter/material.dart';

import '../constants.dart';

class FullLogo extends StatelessWidget {
  const FullLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            height: 110,
            width: 110,
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
