import 'package:flutter/material.dart';

import '../constants.dart';
import '../extensions/color.dart';

class GradientDivider extends StatelessWidget {
  final double thickness;
  final double indent;
  final double endIndent;

  const GradientDivider({
    super.key,
    this.thickness = 3.0,
    this.indent = 12.0,
    this.endIndent = 122.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: thickness,
      margin: EdgeInsets.only(left: 0, right: endIndent),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite).withValues(alpha: 1) : HexColor.fromHex(AppConstants.primaryBlack).withValues(alpha: 1),
            Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite).withValues(alpha: 1.3) : HexColor.fromHex(AppConstants.primaryBlack).withValues(alpha: 1.3),
            Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite).withValues(alpha: 0) : HexColor.fromHex(AppConstants.primaryBlack).withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
