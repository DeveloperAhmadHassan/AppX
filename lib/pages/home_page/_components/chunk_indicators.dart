import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';
import '../../../utils/extensions/string.dart';
import '../../../models/reel.dart';

class ChunkIndicators extends StatelessWidget {
  const ChunkIndicators({
    super.key,
    required this.reel,
    required double currentPosition,
  }) : _currentPosition = currentPosition;

  final Reel reel;
  final double _currentPosition;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: reel.timestamps!.asMap().entries.map((entry) {
            String timestamp = entry.value;
            int timestampInSeconds = timestamp.toSeconds();
            bool isActivated = _currentPosition >= timestampInSeconds;

            return Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: reel.timestamps!.length < 20 ? 4.0 : 0.2),
                child: LinearProgressIndicator(
                  value: 1.0,
                  backgroundColor: Colors.grey,
                  minHeight: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(isActivated ? HexColor.fromHex(AppConstants.primaryWhite) : Colors.grey),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
