import 'package:flutter/material.dart';

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
            Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 1) : Colors.black.withValues(alpha: 1),
            Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 1.3) : Colors.black.withValues(alpha: 1.3),
            Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0) : Colors.black.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
